// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../utils/helpers.sol";

//Uncomment this line to use console.log
// import "hardhat/console.sol";

contract OptimisticP2P is Ownable, Helpers {
    enum OrderState {
        pending,
        accepted,
        paid,
        appealed,
        released,
        cancelled
    }
    enum AppealDecision {
        release,
        cancel,
        unvoted
    }
    enum TradeType {
        buy,
        sell
    }

    struct Merchant {
        bool active;
    }
    struct Settler {
        bool active;
    }
    struct Trader {
        bool active;
    }
    struct Offer {
        address token;
        string currency;
        bytes32 paymentMethod;
        uint256 rate;
        uint256 minOrder;
        uint256 maxOrder;
        bool active;
        address merchant;
        bytes32 accountHash;
        address depositAddress;
        TradeType offerType;
    }
    struct Order {
        uint256 offerId;
        address trader;
        TradeType orderType;
        uint256 quantity;
        address depositAddress;
        bytes32 accountHash;
        uint256 appealId;
        OrderState status;
    }
    struct AppealVote {
        address settler;
        bool settled;
        AppealDecision settlerVote;
        AppealDecision merchantVote;
        AppealDecision traderVote;
    }
    struct Appeal {
        uint256 orderId;
        address appealer;
        bytes32 reasonHash;
        AppealDecision daoVote;
        AppealDecision appealDecision;
        AppealVote[] votes;
    }

    address public daoAddress;
    address public kycAddress;
    mapping(address => Merchant) public merchants;
    mapping(address => mapping(address => uint256)) public merchantStakes; // merchant -> token -> amount
    mapping(address => mapping(address => uint256)) public merchantOrders; // merchant -> token -> amount
    mapping(address => Settler) public settlers;
    mapping(address => mapping(address => uint256)) public settlerStakes; // settler -> token -> amount
    mapping(address => mapping(address => uint256)) public settlerSettlements; // settler -> token -> amount
    mapping(address => Trader) public traders;
    mapping(address => bool) public tradedTokens;
    Offer[] public offers;
    Order[] public orders;
    Appeal[] public appeals;

    event NewMerchant(address indexed merchant);
    event NewSettler(address indexed settler);
    event NewTrader(address indexed trader);
    event NewOffer(
        address indexed token,
        string indexed currency,
        bytes32 indexed paymentMethod,
        uint256 offerId,
        uint256 rate,
        uint256 minOrder,
        uint256 maxOrder,
        bool active,
        address merchant,
        bytes32 accountHash,
        address depositAddress,
        TradeType offerType
    );
    event OfferDisabled(uint256 indexed offerId, bool indexed active);
    event OfferEnabled(uint256 indexed offerId, bool indexed active);
    event NewOrder(
        uint256 indexed offerId,
        address indexed trader,
        TradeType indexed orderType,
        uint256 quantity,
        address depositAddress,
        bytes32 accountHash,
        uint256 appealId,
        OrderState status
    );
    event OrderAccepted(uint256 indexed orderId, OrderState status);
    event OrderPaid(uint256 indexed orderId, OrderState status);
    event OrderReleased(uint256 indexed orderId, OrderState status);
    event OrderCancelled(uint256 indexed orderId, OrderState status);
    event OrderAppealed(
        uint256 indexed orderId,
        uint256 indexed appealId,
        address indexed appealer,
        bytes32 reasonHash,
        AppealDecision daoVote,
        AppealDecision appealDecision,
        OrderState status
    );
    event SettlerVoted(
        uint256 indexed appealId,
        address indexed settler,
        bool indexed settled,
        AppealDecision settlerVote,
        AppealDecision merchantVote,
        AppealDecision traderVote
    );
    event MerchantVoted(
        uint256 indexed appealId,
        address indexed merchant,
        bool indexed settled,
        AppealDecision vote,
        AppealDecision merchantVote,
        AppealDecision traderVote
    );
    event TraderVoted(
        uint256 indexed appealId,
        address indexed trader,
        bool indexed settled,
        AppealDecision vote,
        AppealDecision merchantVote,
        AppealDecision traderVote
    );
    event DAOVoted(uint256 indexed appealId, AppealDecision daoVote);
    event PenaltySlashed(
        uint256 indexed orderId,
        uint256 indexed appealId,
        address[] affected
    );
    event RewardDistributed(
        uint256 indexed orderId,
        uint256 indexed appealId,
        address[] beneficiaries
    );
    event SettlerStaked(
        address indexed settler,
        address indexed token,
        uint256 indexed amount
    );
    event MerchantStaked(
        address indexed merchant,
        address indexed token,
        uint256 indexed amount
    );
    event SettlerUnstaked(
        address indexed settler,
        address indexed token,
        uint256 indexed amount
    );
    event MerchantUnstaked(
        address indexed merchant,
        address indexed token,
        uint256 indexed amount
    );
    event TokenAdded(address indexed token);
    event TokenRemoved(address indexed token);

    error UnauthorizedUser(string messsage);
    error NonTradeToken();
    error InsufficientMerchantCapacity();
    error InvalidOfferId(uint256 offerId);
    error InvalidOrderId(uint256 orderId);
    error InvalidAppeal(uint256 appealId);

    constructor() Ownable(msg.sender) {
        daoAddress = msg.sender;
    }

    modifier onlyTraders() {
        if (!traders[msg.sender].active) {
            revert UnauthorizedUser("onlyTraders");
        }
        _;
    }

    modifier onlyMerchants() {
        if (!merchants[msg.sender].active) {
            revert UnauthorizedUser("onlyMerchants");
        }
        _;
    }

    modifier isOfferMerchant(uint256 offerId) {
        if(offers[offerId].merchant != msg.sender) {
            revert UnauthorizedUser("notOfferMerchant");
        }
        _; 
    }

    modifier onlySettlers() {
        if (!settlers[msg.sender].active) {
            revert UnauthorizedUser("onlySettlers");
        }
        _;
    }

    modifier isTradeToken(address token) {
        if (!tradedTokens[token]) {
            revert NonTradeToken();
        }
        _;
    }

    modifier isValidOffer(uint256 offerId) {
        if (offers[offerId].token == address(0)) {
            revert InvalidOrderId(offerId);
        }
        _;
    }

    modifier isValidOrder(uint256 orderId) {
        if (orders[orderId].trader == address(0)) {
            revert InvalidOrderId(orderId);
        }
        _;
    }

    modifier isValidAppeal(uint256 appealId) {
        if (appeals[appealId].appealer == address(0)) {
            revert InvalidAppeal(appealId);
        }
        _;
    }

    modifier orderAccess(uint256 orderId) {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        require(msg.sender == order.trader || msg.sender == offer.merchant);
        _;
    }

    modifier appealAccess(uint256 appealId) {
        _;
    }

    function merchantCapacity(
        address merchant,
        address token
    ) internal view returns (uint256) {
        return
            merchantStakes[merchant][token] - merchantOrders[merchant][token];
    }

    function settlerCapacity(
        address settler,
        address token
    ) internal view returns (uint256) {
        return
            settlerStakes[settler][token] - settlerSettlements[settler][token];
    }

    function registerMerchant() external {
        merchants[msg.sender] = Merchant(true);
        emit NewMerchant(msg.sender);
    }

    function registerSettler() external {
        settlers[msg.sender] = Settler(true);
        emit NewSettler(msg.sender);
    }

    function registerTrader() internal {
        traders[msg.sender] = Trader(true);
        emit NewTrader(msg.sender);
    }

    function createOffer(
        address token,
        string memory currency,
        bytes32 paymentMethod,
        uint256 rate,
        uint256 minOrder,
        uint256 maxOrder,
        bytes32 accountHash,
        address depositAddress,
        TradeType offerType
    )
        external
        onlyMerchants
        isTradeToken(token)
        positiveAddress(depositAddress)
    {
        if (merchantCapacity(msg.sender, token) < maxOrder) {
            revert InsufficientMerchantCapacity();
        }
        offers.push(
            Offer(
                token,
                currency,
                paymentMethod,
                rate,
                minOrder,
                maxOrder,
                true,
                msg.sender,
                accountHash,
                depositAddress,
                offerType
            )
        );
        emit NewOffer(
            token,
            currency,
            paymentMethod,
            offers.length - 1,
            rate,
            minOrder,
            maxOrder,
            true,
            msg.sender,
            accountHash,
            depositAddress,
            offerType
        );
    }

    function disableOffer(
        uint256 offerId
    ) external onlyMerchants isValidOffer(offerId) isOfferMerchant(offerId) {
        offers[offerId].active = false;
        emit OfferDisabled(offerId, false);
    }

    function enableOffer(uint256 offerId) external onlyMerchants isOfferMerchant(offerId){
        offers[offerId].active = true; 
        emit OfferEnabled(offerId, true);
    }

    function createOrder( 
        uint256 offerId,
        TradeType orderType,
        uint256 quantity,
        address depositAddress,
        bytes32 accountHash
    ) external positiveAddress(depositAddress) isValidOffer(offerId) {
        Offer storage offer = offers[offerId];
        require(quantity < merchantCapacity(offer.merchant, offer.token));
        require(quantity < offer.maxOrder);
        merchantOrders[offer.merchant][offer.token] += quantity;
        if (orderType == TradeType.sell) {
            SafeERC20.safeTransferFrom(
                IERC20(offer.token),
                msg.sender,
                address(this),
                quantity
            );
        } else if(orderType == TradeType.buy) {
            merchantOrders[offer.merchant][offer.token] -= quantity;
            SafeERC20.safeTransferFrom(IERC20(offer.token), offer.merchant, address(this), quantity); 
        }
        orders.push(
            Order(
                offerId,
                msg.sender,
                orderType,
                quantity,
                depositAddress,
                accountHash,
                0,
                OrderState.pending
            )
        );
        emit NewOrder(
            offerId,
            msg.sender,
            orderType,
            quantity,
            depositAddress,
            accountHash,
            0,
            OrderState.pending
        );
    }

    function acceptOrder(uint256 orderId) external isValidOrder(orderId) {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        require(order.status == OrderState.pending);
        require(msg.sender == offer.merchant);
        order.status = OrderState.accepted;
        emit OrderAccepted(orderId, OrderState.accepted);
    }

    function payOrder(uint256 orderId) external isValidOrder(orderId) {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        if (order.orderType == TradeType.sell) {
            require(order.status == OrderState.pending);
            require(msg.sender == offer.merchant);
        } else {
            require(order.status == OrderState.accepted);
            require(msg.sender == order.trader);
        }
        order.status = OrderState.paid;
        emit OrderReleased(orderId, OrderState.paid);
    }

    function releaseOrder(uint256 orderId) external isValidOrder(orderId) {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        require(
            order.status == OrderState.paid
        );
        order.status = OrderState.released;
        merchantOrders[offer.merchant][offer.token] -= order.quantity;
        if (order.orderType == TradeType.sell) {
            require(msg.sender == order.trader);
            merchantStakes[offer.merchant][offer.token] += order.quantity;
            SafeERC20.safeTransfer(
                IERC20(offer.token),
                offer.merchant,
                order.quantity
            );
        } else {
            require(msg.sender == offer.merchant);
            merchantStakes[offer.merchant][offer.token] -= order.quantity;
            SafeERC20.safeTransfer(
                IERC20(offer.token),
                order.trader,
                order.quantity
            );
        }
        emit OrderReleased(orderId, OrderState.released);
    }

    function appealOrder(
        uint256 orderId,
        bytes32 reasonHash
    ) external isValidOrder(orderId) {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        require(order.status == OrderState.paid);
        require(msg.sender == order.trader || msg.sender == offer.merchant);
        require(order.appealId == 0); 
        uint256 appealId = appeals.length + 1;
        appeals[appealId] = Appeal(
            orderId,
            msg.sender,
            reasonHash,
            AppealDecision.unvoted,
            AppealDecision.unvoted,
            new AppealVote[](0)
        );
        order.appealId = appealId;
        emit OrderAppealed(
            orderId,
            appealId,
            msg.sender,
            reasonHash,
            AppealDecision.unvoted,
            AppealDecision.unvoted,
            OrderState.appealed
        );
    }
    function cancelOrder(uint256 orderId) public isValidOrder(orderId) {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        require(msg.sender == order.trader || msg.sender == offer.merchant);
        require(
                order.status == OrderState.pending ||
                order.status == OrderState.accepted
        );
        merchantOrders[offer.merchant][offer.token] -= order.quantity;
        order.status = OrderState.cancelled;
        if (order.orderType == TradeType.sell) {
                SafeERC20.safeTransfer(
                    IERC20(offer.token),
                    order.trader,
                    order.quantity
                );
        } else {
            SafeERC20.safeTransfer(IERC20(offer.token), offer.merchant, order.quantity);
        }
        emit OrderCancelled(orderId, OrderState.cancelled);
    }

    function addToken(address token) external onlyOwner {
        tradedTokens[token] = true;
        emit TokenAdded(token);
    }

    function removeToken(address token) external onlyOwner isTradeToken(token) {
        tradedTokens[token] = false;
        emit TokenRemoved(token);
    }

    function settlerStake(address token, uint256 amount) external onlySettlers {
        settlerStakes[msg.sender][token] += amount;
        SafeERC20.safeTransferFrom(
            IERC20(token),
            msg.sender,
            address(this),
            amount
        );
        emit SettlerStaked(msg.sender, token, amount);
    }

    function setterUnstake(
        address token,
        uint256 amount
    ) external onlySettlers {
        require(amount < settlerCapacity(msg.sender, token));
        settlerStakes[msg.sender][token] -= amount;
        SafeERC20.safeTransfer(IERC20(token), msg.sender, amount);
        emit SettlerUnstaked(msg.sender, token, amount);
    }

    function merchantStake(
        address token,
        uint256 amount
    ) external onlyMerchants isTradeToken(token) {
        merchantStakes[msg.sender][token] += amount;
        SafeERC20.safeTransferFrom(
            IERC20(token),
            msg.sender,
            address(this),
            amount
        );
        emit MerchantStaked(msg.sender, token, amount);
    }

    function merchantUnstake(
        address token,
        uint256 amount
    ) external onlyMerchants {
        require(amount < merchantCapacity(msg.sender, token));
        merchantStakes[msg.sender][token] -= amount;
        SafeERC20.safeTransfer(IERC20(token), msg.sender, amount);
        emit MerchantUnstaked(msg.sender, token, amount);
    }

//! Reference point
    function traderVote(
        uint256 appealId,
        AppealDecision vote
    ) external onlyTraders isValidAppeal(appealId) {
        Appeal storage appeal = appeals[appealId];
        //loop through AppealVote[] votes to get AppealDecision
        uint256 appealVotesLength = appeal.votes.length;
        for (uint256 i = 0; i < appealVotesLength; i++) {
            if(appeal.votes[i].traderVote == AppealDecision.unvoted) {
                appeal.votes[i].traderVote = vote;
                return;
            }
        }
        emit TraderVoted(appealId, msg.sender, false, vote, vote, vote);
    }


    function merchantVote(
        uint256 appealId,
        AppealDecision vote
    ) external onlyMerchants isValidAppeal(appealId) {
        Appeal storage appeal = appeals[appealId];
        uint256 appealVotesLength = appeal.votes.length;
        for(uint256 i = 0; i < appealVotesLength; i++) {
            if(appeal.votes[i].merchantVote == AppealDecision.unvoted) {
                appeal.votes[i].merchantVote == vote;
                return;
            }
        }
        emit MerchantVoted(appealId, msg.sender, false, vote, vote, vote);
    }

    function settlerVote(
        uint256 appealId,
        AppealDecision vote
    ) external onlySettlers isValidAppeal(appealId) {
        Appeal storage appeal = appeals[appealId];
        uint256 appealsVoteLength = appeal.votes.length;
        for (uint256 i = 0; i < appealsVoteLength; i++) {
            if(appeal.votes[i].settlerVote == AppealDecision.unvoted) { 
                appeal.votes[i].settlerVote == vote;
                return;
            }
        }
        emit SettlerVoted(appealId, msg.sender, true, vote, vote, vote);
    }

    function daoVote(
        uint256 appealId,
        AppealDecision vote
    ) external onlySettlers {
        emit DAOVoted(appealId, vote);
    }
}