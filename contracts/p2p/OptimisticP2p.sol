// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "../interfaces/IAMLBlacklist.sol";
import "../interfaces/IKYCWhitelist.sol";
import "../utils/helpers.sol";

import "./P2Pparams.sol";

//Uncomment this line to use console.log
// import "hardhat/console.sol";

contract OptimisticP2P is P2Pparams, Ownable, ReentrancyGuard, Helpers {
    constructor(
        address _daoAddress,
        IKYCWhitelist _kycAddress,
        IAMLBlacklist _amlAddress,
        IERC20Metadata _usdtAddress,
        uint256 _merchantStakeAmount,
        uint256 _settlerStakeAmount,
        uint256 _settlerMinTime,
        uint256 _settlerMaxTime,
        uint256 _daoMinTime,
        uint256 _concurrentSettlerSettlements,
        uint256 _concurrentMerchantSettlements,
        uint256 _appealAfter,
        uint256 _maxAppealRounds
    ) Ownable(msg.sender) {
        daoAddress = _daoAddress;
        kycAddress = IKYCWhitelist(_kycAddress);
        amlAddress = IAMLBlacklist(_amlAddress);
        usdtAddress = IERC20Metadata(_usdtAddress);
        merchantStakeAmount = _merchantStakeAmount;
        settlerStakeAmount = _settlerStakeAmount;
        settlerMinTime = _settlerMinTime;
        settlerMaxTime = _settlerMaxTime;
        daoMinTime = _daoMinTime;
        concurrentSettlerSettlements = _concurrentSettlerSettlements;
        concurrentMerchantSettlements = _concurrentMerchantSettlements;
        appealAfter = _appealAfter;
        maxAppealRounds = _maxAppealRounds;
    }

    function updateProtocolParams(
        address _daoAddress,
        IKYCWhitelist _kycAddress,
        IAMLBlacklist _amlAddress,
        IERC20Metadata _usdtAddress,
        uint256 _merchantStakeAmount,
        uint256 _settlerStakeAmount,
        uint256 _settlerMinTime,
        uint256 _settlerMaxTime,
        uint256 _daoMinTime,
        uint256 _concurrentSettlerSettlements,
        uint256 _concurrentMerchantSettlements,
        uint256 _appealAfter,
        uint256 _maxAppealRounds
    ) external onlyOwner {
        daoAddress = _daoAddress;
        kycAddress = IKYCWhitelist(_kycAddress);
        amlAddress = IAMLBlacklist(_amlAddress);
        usdtAddress = IERC20Metadata(_usdtAddress);
        merchantStakeAmount = _merchantStakeAmount;
        settlerStakeAmount = _settlerStakeAmount;
        settlerMinTime = _settlerMinTime;
        settlerMaxTime = _settlerMaxTime;
        daoMinTime = _daoMinTime;
        concurrentSettlerSettlements = _concurrentSettlerSettlements;
        concurrentMerchantSettlements = _concurrentMerchantSettlements;
        appealAfter = _appealAfter;
        maxAppealRounds = _maxAppealRounds;
        emit ProtocolParamsUpdated();
    }

    function addToken(address token) external onlyOwner {
        tradedTokens[token] = true;
        emit TokenAdded(msg.sender, token);
    }

    function removeToken(address token) external onlyOwner isTradeToken(token) {
        delete tradedTokens[token];
        emit TokenRemoved(msg.sender, token);
    }

    function addPaymentMethod(string memory _paymentMethod) external onlyOwner {
        acceptedPaymentMethods[_paymentMethod] = true;
        emit PaymentMethodAdded(msg.sender, _paymentMethod);
    }

    function removePaymentMethod(
        string memory _paymentMethod
    ) external onlyOwner isSupportedPaymentMethod(_paymentMethod) {
        delete acceptedPaymentMethods[_paymentMethod];
        emit PaymentMethodRemoved(msg.sender, _paymentMethod);
    }

    function addCurrency(string memory currency) external onlyOwner {
        acceptedCurrencies[currency] = true;
        emit CurrencyAdded(msg.sender, currency);
    }

    function removeCurrency(
        string memory currency
    ) external onlyOwner isSupportedCurrency(currency) {
        delete acceptedCurrencies[currency];
        emit CurrencyRemoved(msg.sender, currency);
    }

    function registerMerchant() external noBlacklisted {
        merchants[msg.sender] = Merchant(true);
        stakeMerchant(merchantStakeAmount);
        emit NewMerchant(msg.sender);
    }

    function registerSettler() external noBlacklisted {
        settlers[msg.sender] = Settler(true);
        stakeSettler(merchantStakeAmount);
        emit NewSettler(msg.sender);
    }

    function registerTrader() external noBlacklisted {
        traders[msg.sender] = Trader(true);
        emit NewTrader(msg.sender);
    }

    function stakeSettler(uint256 amount) internal onlySettlers {
        if (amount < settlerStakeAmount) {
            revert InvalidSettlerStake(amount);
        }
        SafeERC20.safeTransferFrom(
            usdtAddress,
            msg.sender,
            address(this),
            amount
        );
        emit SettlerStaked(msg.sender, amount);
    }

    function setterUnstake() external onlySettlers {
        uint256 amount = settlerStake[msg.sender];
        settlerStake[msg.sender] = 0;
        SafeERC20.safeTransfer(usdtAddress, msg.sender, amount);
        emit SettlerUnstaked(msg.sender, amount);
    }

    function stakeMerchant(
        uint256 amount
    ) internal noBlacklisted {
        if (amount < merchantStakeAmount) {
            revert InvalidMerchantStake(amount);
        }
        SafeERC20.safeTransferFrom(
            usdtAddress,
            msg.sender,
            address(this),
            amount
        );
        emit MerchantStaked(msg.sender, amount);
    }

    function merchantUnstake() external noBlacklisted onlyMerchants {
        uint256 amount = merchantStake[msg.sender];
        merchantStake[msg.sender] = 0;
        SafeERC20.safeTransfer(usdtAddress, msg.sender, amount);
        emit MerchantUnstaked(msg.sender, amount);
    }

    function createOffer(
        address token,
        string memory currency,
        string memory paymentMethod,
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
        validateMerchant(msg.sender);
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
                offerType,
                block.timestamp
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

    function enableOffer(
        uint256 offerId
    ) external onlyMerchants isOfferMerchant(offerId) {
        offers[offerId].active = true;
        emit OfferEnabled(offerId, true);
    }

    function createOrder(
        uint256 offerId,
        uint256 quantity,
        address depositAddress,
        bytes32 accountHash
    )
        external
        noBlacklisted
        positiveAddress(depositAddress)
        isValidOffer(offerId)
        validKYCLevel(IKYCWhitelist.KYCLevel.level1)
    {
        Offer storage offer = offers[offerId];
        validateMerchant(offer.merchant);
        uint256 orderId = orders.length;
        if (quantity > offer.maxOrder) {
            revert OfferMaxExceeded(quantity, offer.maxOrder);
        }
        incrementMerchantOrders(offer.merchant);
        if (offer.offerType == TradeType.sell) {
            SafeERC20.safeTransferFrom(
                IERC20(offer.token),
                msg.sender,
                address(this),
                quantity
            );
        }
        orders.push(
            Order(
                offerId,
                msg.sender,
                offer.offerType,
                quantity,
                depositAddress,
                accountHash,
                0,
                OrderState.pending,
                block.timestamp
            )
        );
        emit NewOrder(
            orderId,
            msg.sender,
            offer.offerType,
            offerId,
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
        if (msg.sender != offer.merchant) {
            revert UnauthorizedUser("Invalid Merchant!");
        }
        if (order.status != OrderState.pending) {
            revert InvalidStateForAction(order.status, OrderState.pending);
        }
        if (order.orderType == TradeType.sell) {
            revert AcceptNotRequiredForSell();
        }

        order.status = OrderState.accepted;

        SafeERC20.safeTransferFrom(
            IERC20(offer.token),
            msg.sender,
            address(this),
            order.quantity
        );
        emit OrderAccepted(orderId, OrderState.accepted);
    }

    function payOrder(uint256 orderId) external isValidOrder(orderId) {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        if (order.orderType == TradeType.sell) {
            if (order.status != OrderState.pending) {
                revert InvalidStateForAction(order.status, OrderState.pending);
            }
            if (msg.sender != offer.merchant) {
                revert UnauthorizedUser("Invalid Merchant!");
            }
        } else {
            if (order.status != OrderState.accepted) {
                revert InvalidStateForAction(order.status, OrderState.accepted);
            }
            if (msg.sender != order.trader) {
                revert UnauthorizedUser("Invalid Trader!");
            }
        }
        order.status = OrderState.paid;
        emit OrderPaid(orderId, OrderState.paid);
    }

    function releaseOrder(uint256 orderId) external isValidOrder(orderId) {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        if (order.status != OrderState.paid) {
            revert InvalidStateForAction(order.status, OrderState.paid);
        }
        order.status = OrderState.released;
        if (order.orderType == TradeType.sell) {
            if (msg.sender != order.trader) {
                revert UnauthorizedUser("Invalid Trader!");
            }
            SafeERC20.safeTransfer(
                IERC20(offer.token),
                offer.merchant,
                order.quantity
            );
        } else {
            if (msg.sender != offer.merchant) {
                revert UnauthorizedUser("Invalid Merchant!");
            }
            SafeERC20.safeTransfer(
                IERC20(offer.token),
                order.trader,
                order.quantity
            );
        }
        decrementMerchantOrders(offer.merchant);
        emit OrderReleased(orderId, OrderState.released);
    }

    function _releaseAfterSettle(uint256 orderId) private {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        order.status = OrderState.released;
        if (order.orderType == TradeType.sell) {
            SafeERC20.safeTransfer(
                IERC20(offer.token),
                offer.merchant,
                order.quantity
            );
        } else {
            SafeERC20.safeTransfer(
                IERC20(offer.token),
                order.trader,
                order.quantity
            );
        }
        decrementMerchantOrders(offer.merchant);
        emit OrderReleased(orderId, OrderState.released);
    }
    function cancelOrder(uint256 orderId) external isValidOrder(orderId) {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        if (order.orderType == TradeType.sell) {
            if (order.status != OrderState.pending) {
                revert InvalidStateForAction(order.status, OrderState.paid);
            }
            if (msg.sender != offer.merchant) {
                revert UnauthorizedUser("Invalid Merchant!");
            }
            order.status = OrderState.cancelled;
            SafeERC20.safeTransfer(
                IERC20(offer.token),
                order.trader,
                order.quantity
            );
        } else {
            order.status = OrderState.cancelled;
            if (order.status == OrderState.pending) {
                if (msg.sender != offer.merchant) {
                    revert UnauthorizedUser("Invalid Merchant!");
                }
            } else if (order.status == OrderState.accepted) {
                if (msg.sender != order.trader) {
                    revert UnauthorizedUser("Invalid Trader!");
                }
                SafeERC20.safeTransfer(
                    IERC20(offer.token),
                    offer.merchant,
                    order.quantity
                );
            } else {
                revert InvalidStateForAction(order.status, OrderState.accepted);
            }
        }
        decrementMerchantOrders(offer.merchant);
        emit OrderCancelled(orderId, OrderState.cancelled);
    }

    function _cancelAferSettle(uint256 orderId) private {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        order.status = OrderState.cancelled;
        if (order.orderType == TradeType.sell) {
            SafeERC20.safeTransfer(
                IERC20(offer.token),
                order.trader,
                order.quantity
            );
        } else {
            SafeERC20.safeTransfer(
                IERC20(offer.token),
                offer.merchant,
                order.quantity
            );
        }
        decrementMerchantOrders(offer.merchant);
        emit OrderCancelled(orderId, OrderState.cancelled);
    }

    function appealOrder(
        uint256 orderId,
        bytes32 reasonHash
    ) external isValidOrder(orderId) nonEmptyReason(reasonHash) {
        Order storage order = orders[orderId];
        Offer storage offer = offers[order.offerId];
        if (order.status != OrderState.paid) {
            revert InvalidStateForAction(order.status, OrderState.paid);
        }
        if (msg.sender != order.trader || msg.sender != offer.merchant) {
            revert UnauthorizedUser("Invalid Merchant or Trader!");
        }
        if (order.appealId != 0) {
            revert OrderAlreadyAppealed();
        }
        uint256 appealId = appeals.length + 1;
        appeals[appealId] = Appeal(
            orderId,
            msg.sender,
            reasonHash,
            AppealDecision.unvoted,
            AppealDecision.unvoted,
            new AppealVote[](0),
            address(0),
            block.timestamp
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

    function _roundOver(AppealVote storage _round) private view returns (bool) {
        return
            (_round.settlerVote != AppealDecision.unvoted) &&
            (_round.traderVote != AppealDecision.unvoted) &&
            (_round.merchantVote != AppealDecision.unvoted);
    }

    function _settlerVoted(
        AppealVote storage _round
    ) private view returns (bool) {
        return _round.settlerVote != AppealDecision.unvoted;
    }

    function _appealOver(Appeal storage _appeal) private view returns (bool) {
        if (_appeal.votes.length >= maxAppealRounds) {
            return _roundOver(_appeal.votes[_roundId(_appeal.votes.length)]);
        }

        return false;
    }

    function _roundId(uint256 _length) private pure returns (uint256) {
        if (_length == 0) {
            return 0;
        } else {
            return _length - 1;
        }
    }

    function pickCase(
        uint256 appealId
    ) external onlySettlers isValidAppeal(appealId) {
        validateSettler(msg.sender);
        Appeal storage appeal = appeals[appealId];
        if (appeal.currentSettler != address(0)) {
            if ((block.timestamp - appeal.settlerPickTime) < settlerMaxTime) {
                revert SettlingInProgress(appeal.currentSettler);
            }
            AppealVote storage round = appeal.votes[
                _roundId(appeal.votes.length)
            ];
            if (_settlerVoted(round) && !_roundOver(round)) {
                revert SettlingInProgress(appeal.currentSettler);
            }
        }
        appeal.currentSettler = msg.sender;
        appeal.settlerPickTime = block.timestamp;
        incrementSettlerSettlements(msg.sender);
        emit SettlerAssignedToCase(msg.sender, appealId);
    }

    function traderVote(
        uint256 appealId,
        AppealDecision vote
    ) external onlyTraders isValidVote(vote) isValidAppeal(appealId) {
        Appeal storage appeal = appeals[appealId];
        uint256 roundId = _roundId(appeal.votes.length);
        AppealVote storage round = appeal.votes[roundId];
        if (round.settlerVote == AppealDecision.unvoted) {
            revert SettlerNotVoted(roundId);
        }
        if (round.traderVote != AppealDecision.unvoted) {
            revert TraderAlreadyVoted(roundId);
        }
        round.traderVote = vote;
        if (_roundOver(round)) {
            bool merchantSettlerAgree = round.traderVote == round.settlerVote;
            bool traderSettlerAgree = round.traderVote == round.settlerVote;
            bool merchantTraderAgree = round.traderVote == round.traderVote;
            round.settled =
                merchantSettlerAgree &&
                traderSettlerAgree &&
                merchantTraderAgree;
        }
        if (round.settled) {
            if (vote == AppealDecision.release) {
                _releaseAfterSettle(appeal.orderId);
            } else if (vote == AppealDecision.cancel) {
                _cancelAferSettle(appeal.orderId);
            }
            appeal.appealDecision = vote;
        }
        emit TraderVoted(appealId, msg.sender, round.settled, vote, roundId);
    }

    function merchantVote(
        uint256 appealId,
        AppealDecision vote
    ) external onlyMerchants isValidVote(vote) isValidAppeal(appealId) {
        Appeal storage appeal = appeals[appealId];
        uint256 roundId = _roundId(appeal.votes.length);
        AppealVote storage round = appeal.votes[roundId];
        if (round.settlerVote == AppealDecision.unvoted) {
            revert SettlerNotVoted(roundId);
        }
        if (round.merchantVote != AppealDecision.unvoted) {
            revert MerchantAlreadyVoted(roundId);
        }
        round.merchantVote = vote;
        if (_roundOver(round)) {
            bool merchantSettlerAgree = round.merchantVote == round.settlerVote;
            bool traderSettlerAgree = round.traderVote == round.settlerVote;
            bool merchantTraderAgree = round.merchantVote == round.traderVote;
            round.settled =
                merchantSettlerAgree &&
                traderSettlerAgree &&
                merchantTraderAgree;
        }
        if (round.settled) {
            appeal.appealDecision = vote;
            if (vote == AppealDecision.release) {
                _releaseAfterSettle(appeal.orderId);
            } else if (vote == AppealDecision.cancel) {
                _cancelAferSettle(appeal.orderId);
            }
        }
        emit MerchantVoted(appealId, msg.sender, round.settled, vote, roundId);
    }

    function settlerVote(
        uint256 appealId,
        AppealDecision vote
    ) external onlySettlers isValidVote(vote) isValidAppeal(appealId) {
        Appeal storage appeal = appeals[appealId];
        if (appeal.currentSettler != msg.sender) {
            revert SettlingInProgress(appeal.currentSettler);
        }
        if (appeal.appealDecision != AppealDecision.unvoted) {
            revert AppealOver(appealId);
        }
        uint256 roundId = _roundId(appeal.votes.length);
        AppealVote storage round = appeal.votes[roundId];
        if (round.settlerVote == AppealDecision.unvoted) {
            revert SettlerAlreadyVoted(roundId);
        }
        if (roundId > 0) {
            AppealVote storage previousRound = appeal.votes[roundId - 1];
            if (!_roundOver(previousRound)) {
                revert PreviousRoundOngoing(roundId - 1);
            }
        }
        round.settler = msg.sender;
        round.settlerVote = vote;
        emit SettlerVoted(appealId, msg.sender, false, vote, roundId);
    }

    function daoVote(
        uint256 appealId,
        AppealDecision vote
    ) external onlyDAO isValidVote(vote) isValidAppeal(appealId) {
        Appeal storage appeal = appeals[appealId];
        if (!_appealOver(appeal)) {
            revert AppealInProgress(appealId);
        }
        appeal.daoVote = vote;
        appeal.appealDecision = vote;
        if (vote == AppealDecision.release) {
            _releaseAfterSettle(appeal.orderId);
        } else if (vote == AppealDecision.cancel) {
            _cancelAferSettle(appeal.orderId);
        }
        emit DAOVoted(appealId, vote);
    }
}
