// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "../interfaces/IAMLBlacklist.sol";
import "../interfaces/IKYCWhitelist.sol";

abstract contract P2Pparams {
    enum OrderState {
        pending,
        accepted,
        paid,
        appealed,
        released,
        cancelled
    }
    enum AppealDecision {
        unvoted,
        release,
        cancel
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
        string paymentMethod;
        uint256 rate;
        uint256 minOrder;
        uint256 maxOrder;
        bool active;
        address merchant;
        bytes32 accountHash;
        address depositAddress;
        TradeType offerType;
        uint256 createdAt;
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
        uint256 createdAt;
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
        address currentSettler;
        uint256 settlerPickTime;
    }

    // protocol variables
    address public daoAddress;
    IKYCWhitelist public kycAddress;
    IAMLBlacklist public amlAddress;
    IERC20Metadata public usdtAddress;
    uint256 public merchantStakeAmount = 1500 * 1e6;
    uint256 public settlerStakeAmount = 1500 * 1e6;
    uint256 public settlerMinTime = 15 minutes;
    uint256 public settlerMaxTime = 1 hours;
    uint256 public daoMinTime = 1 hours;
    uint256 public concurrentSettlerSettlements = 3;
    uint256 public concurrentMerchantSettlements = 3;
    uint256 public appealAfter = 30 minutes;
    uint256 public maxAppealRounds = 4;

    mapping(address => Merchant) public merchants;
    mapping(address => uint256) public merchantStake; // merchant -> amount
    mapping(address => uint256) public merchantOrders; // merchant -> orderCount
    mapping(address => Settler) public settlers;
    mapping(address => uint256) public settlerStake; // settler -> amount
    mapping(address => uint256) public settlerSettlements; // settler -> settlementCount
    mapping(address => Trader) public traders;
    mapping(address => bool) public tradedTokens;
    mapping(string => bool) public acceptedCurrencies;
    mapping(string => bool) public acceptedPaymentMethods;
    Offer[] public offers;
    Order[] public orders;
    Appeal[] public appeals;

    event NewMerchant(address  merchant);
    event NewSettler(address  settler);
    event NewTrader(address  trader);
    event NewOffer(
        address  token,
        string  currency,
        string  paymentMethod,
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
    event OfferDisabled(uint256  offerId, bool  active);
    event OfferEnabled(uint256  offerId, bool  active);
    event NewOrder(
        uint256  orderId,
        address  trader,
        TradeType  orderType,
        uint256 offerId,
        uint256 quantity,
        address depositAddress,
        bytes32 accountHash,
        uint256 appealId,
        OrderState status
    );
    event OrderAccepted(uint256  orderId, OrderState  status);
    event OrderPaid(uint256  orderId, OrderState  status);
    event OrderReleased(uint256  orderId, OrderState  status);
    event OrderCancelled(uint256  orderId, OrderState  status);
    event OrderAppealed(
        uint256  orderId,
        uint256  appealId,
        address  appealer,
        bytes32 reasonHash,
        AppealDecision daoVote,
        AppealDecision appealDecision,
        OrderState status
    );
    event SettlerVoted(
        uint256  appealId,
        address  settler,
        bool  settled,
        AppealDecision settlerVote,
        uint256 roundId
    );
    event MerchantVoted(
        uint256  appealId,
        address  merchant,
        bool  settled,
        AppealDecision merchantVote,
        uint256 roundId
    );
    event TraderVoted(
        uint256  appealId,
        address  trader,
        bool  settled,
        AppealDecision traderVote,
        uint256 roundId
    );
    event DAOVoted(uint256  appealId, AppealDecision  daoVote);
    event PenaltySlashed(uint256  appealId, address[]  affected);
    event RewardDistributed(
        uint256  appealId,
        address[]  beneficiaries
    );
    event SettlerStaked(address  settler, uint256  amount);
    event MerchantStaked(address  merchant, uint256  amount);
    event SettlerUnstaked(address  settler, uint256  amount);
    event MerchantUnstaked(address  merchant, uint256  amount);
    event TokenAdded(address  _addedBy, address  _token);
    event TokenRemoved(address  _addedBy, address  _token);
    event PaymentMethodAdded(address  _addedBy, string  _method);
    event PaymentMethodRemoved(
        address  _removedBy,
        string  _method
    );
    event CurrencyAdded(address  _addedBy, string  _currency);
    event CurrencyRemoved(address  _removedBy, string  _currency);
    event SettlerAssignedToCase(
        address  _settler,
        uint256  _caseId
    );
    event ProtocolParamsUpdated();

    error UnauthorizedUser(string messsage);
    error NonTradeToken();
    error InsufficientMerchantCapacity();
    error InvalidOfferId(uint256 offerId);
    error InvalidOrderId(uint256 orderId);
    error InvalidAppeal(uint256 appealId);
    error InvalidKYCLevel(IKYCWhitelist.KYCLevel _level);
    error BlacklistedAddress(address _address);
    error SettlerConcurrencyReached(uint256 _count);
    error MerchantConcurrencyReached(uint256 _count);
    error InvalidMerchantStake(uint256 _stakeAmount);
    error InvalidSettlerStake(uint256 _stakeAmount);
    error OfferMaxExceeded(uint256 _orderQuantity, uint256 _offerMax);
    error InvalidStateForAction(
        OrderState _currentState,
        OrderState _requiredState
    );
    error AcceptNotRequiredForSell();
    error UnsupportedCurrency();
    error UnsupportedPaymentMethod();
    error OrderAlreadyAppealed();
    error ZeroMerchantOrders();
    error ZeroSetterSettlements();
    error EmptyReasonHash();
    error SettlingInProgress(address _currentSettler);
    error SettlerNotVoted(uint256 _round);
    error SettlerAlreadyVoted(uint256 _round);
    error MerchantAlreadyVoted(uint256 _round);
    error TraderAlreadyVoted(uint256 _round);
    error InvalidVote(AppealDecision _vote);
    error AppealInProgress(uint256 _appealId);
    error AppealOver(uint256 _appealId);
    error PreviousRoundOngoing(uint256 _roundId);

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
        if (offers[offerId].merchant != msg.sender) {
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

    modifier onlyDAO() {
        if (msg.sender != daoAddress) {
            revert UnauthorizedUser("onlyDAO");
        }
        _;
    }

    modifier isTradeToken(address token) {
        if (!tradedTokens[token]) {
            revert NonTradeToken();
        }
        _;
    }

    modifier isSupportedCurrency(string memory _currency) {
        if (!acceptedCurrencies[_currency]) {
            revert UnsupportedCurrency();
        }
        _;
    }

    modifier isSupportedPaymentMethod(string memory _paymentMethod) {
        if (!acceptedPaymentMethods[_paymentMethod]) {
            revert UnsupportedPaymentMethod();
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

    modifier isValidVote(AppealDecision _vote) {
        if (_vote == AppealDecision.unvoted) {
            revert InvalidVote(_vote);
        }
        _;
    }

    modifier orderAccess(uint256 orderId) {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        require(msg.sender == order.trader || msg.sender == offer.merchant);
        _;
    }

    modifier validKYCLevel(IKYCWhitelist.KYCLevel _level) {
        if (kycAddress.getKYCLevel(msg.sender) < _level) {
            revert InvalidKYCLevel(_level);
        }
        _;
    }

    modifier noBlacklisted() {
        if (amlAddress.isBlacklisted(msg.sender)) {
            revert BlacklistedAddress(msg.sender);
        }
        _;
    }

    modifier nonEmptyReason(bytes32 _reasonHash) {
        if (
            sha256(abi.encodePacked(_reasonHash)) ==
            sha256(abi.encodePacked(""))
        ) {
            revert EmptyReasonHash();
        }
        _;
    }

    function checkKYCLevel(
        address _address,
        IKYCWhitelist.KYCLevel _level
    ) internal view returns (bool) {
        return kycAddress.getKYCLevel(_address) >= _level;
    }

    function validateSettler(address settler) internal view {
        if (amlAddress.isBlacklisted(settler)) {
            revert BlacklistedAddress(settler);
        }
        IKYCWhitelist.KYCLevel level = kycAddress.getKYCLevel(settler);
        if (level == IKYCWhitelist.KYCLevel.level0) {
            revert InvalidKYCLevel(level);
        }
        if (settlerSettlements[settler] >= concurrentSettlerSettlements) {
            revert SettlerConcurrencyReached(settlerSettlements[settler]);
        }
    }

    function validateMerchant(address merchant) internal view {
        if (amlAddress.isBlacklisted(merchant)) {
            revert BlacklistedAddress(merchant);
        }
        IKYCWhitelist.KYCLevel level = kycAddress.getKYCLevel(merchant);
        if (level == IKYCWhitelist.KYCLevel.level0) {
            revert InvalidKYCLevel(level);
        }
        if (merchantOrders[merchant] >= concurrentMerchantSettlements) {
            revert MerchantConcurrencyReached(merchantOrders[merchant]);
        }
    }

    function incrementMerchantOrders(address merchant) internal {
        merchantOrders[merchant] += 1;
    }

    function decrementMerchantOrders(address merchant) internal {
        if (merchantOrders[merchant] == 0) {
            revert ZeroMerchantOrders();
        }
        merchantOrders[merchant] -= 1;
    }

    function incrementSettlerSettlements(address settler) internal {
        settlerSettlements[settler] += 1;
    }

    function decrementSettlerSettlements(address settler) internal {
        if (settlerSettlements[settler] == 0) {
            revert ZeroSetterSettlements();
        }
        settlerSettlements[settler] -= 1;
    }
}
