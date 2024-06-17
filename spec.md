## Protocol & Flows

### Register Merchant & Settler Flow

1. Ensure Connect wallet
2. Initiate Registration
3. Provide KYC Details
4. Sign and Send Transaction

### Stake Flow

1. Ensure Connect Wallet
2. Enter Amount to Stake
3. Approve contract to transfer erc20 token for stake
4. Sign and Send Transaction

### Create Offer Flow

1. Ensure Connect Wallet
2. Enter Offer Details
3. Approve contract to transfer erc20 token for stake
4. Sign and Send Transaction

### Delete Offer Flow

1. Ensure Connect Wallet
2. Select Offer to Delete and Confirm
3. Sign and Send Transaction

### Create Order Flow

And order can either be a buy order or a sell order

#### Buy Flow (Summary)

1. Ensure Connect Wallet

2. The trader will see a list of offers which are listed from the smart contract.

3. The trader will place the order to the smart contract. (Sign and Send Transaction)

4. The seller will confirm the order prompting the trader to send fiat to the seller. They can also decide to cancel. (Sign and Send Transaction)

5. The trader will confirm they've sent fiat to the smart contract. (Sign and Send Transaction)

6. The seller will see the order and confirm receipt to the smart contract. (Sign and Send Transaction)

7. Crypto will be automatically released to the trader.

8. In case of dispute several settlers are invited to investigate and vote.

#### Buy Flow(Contract Specification)

1. Trader places a buy order by calling `CreateOrder` 

2. Tokens are transferred from the Merchant to the Contract

3. Merchant can see available orders and decide to accept(`acceptOrder`) or cancel(`cancelOrder`)

4. If Merchant accepts the buy order(`acceptOrder`), Trader will then be prompted to send fiat. Here, Merchant cannot cannot cancel the order after he has accpeted it.

5. Trader can also decide to cancel order(`cancelOrder`) here after Merchant has accepted it(before Trader pays order), tokens will then be released back to the Merchant

6. After Trader has sent fiat, Trader calls `payOrder` prompting Merchant to release tokens

7. FInally, If Merchant confirms fiat has been received, `releaseOrder` is then triggered and tokens are sent to the traders wallet.

#### Buy Flow Disputes
In a case of a disagreement between a Merchant and a Trader:

1. A Merchant can open an appeal(`appealOrder`) when he thinks trader did not send fiat but has called `payOrder`.

2. A Trader can also call for an appeal when he thinks the Merchant did not release tokens after calling `payOrder`

<h3>
<details>
    <summary>Diagram for Buy Flow</summary>

![](/specification-assets/buy_flow.png)
</details>
</h3>


#### Sell Flow (Summary)

1. Ensure Connect Wallet

2. The trader will see a list of offers which are listed from the smart contract.

3. The trader will place the order by sending crypto to the smart contract. (Sign and Send Transaction) (erc20 token approval needed)

4. The buyer will see the order and send fiat. They can also decide to cancel.

5. The buyer will confirm they’ve sent fiat to the smart contract. (Sign and Send Transaction)

6. The trader will confirm receipt to the smart contract. (Sign and Send Transaction)

7. Money will be automatically released to the buyer.

8. In case of dispute, several settlers are invited to investigate and vote.

#### Sell Flow(Contract Specification)
1. Trader places a sell order by calling `CreateOrder` and transfers token to the Contract

2. Merchant sees a traders order to sell tokens. Merchant can decide to cancel(`cancelOrder`) or accept the order.

3. If Merchant accepts the order, Merchant must send fiat to the Trader and then call `payOrder` prompting Trader to release token.

4. Trader after confirming fiat will then call `releaseOrder` for contract to release tokens to the Merchant

#### Sell Flow Disputes
In a case of a disagreement between a Merchant and a Trader:

1. A Trader can open an appeal(`appealOrder`) when he thinks Merchant did not send fiat but has called `payOrder`.

2. A Merchant can also call for an appeal(`appealOrder`) when he thinks the Trader has received fiat but did not release tokens after calling `payOrder`.

<h3>
<details>
    <summary>Diagram for Sell Flow</summary>

![](/specification-assets/sell_flow.png)
</details>
</h3>


### Settling Flow (Summary)

In case there is a dispute over whether fiat is sent, either party in the trade can opt for an appeal. A settler will be invited to settle the situation.

1. After the initial appeal a settler is invited to oversee the situation.
2. The settler decides which party is not guilty by voting to either cancel or release the token.
3. If either party does not agree they can opt for another appeal.
4. Appeal can happen 4 times max.
5. If there is still misunderstanding it will be open for the entire DAO to also make their decision.
6. The majority decision of the DAO is final. 70% quorum with 75% majority is required.
7. Settlers gets rewarded. The reward is a fraction of the penalty.
8. DAO gets rewarded if they end up participating.
9. Penalty is charged to guilty party.

### Settling Flow (Contract Specifications)
To settle appeals:
1. A Trader or Merchant first appeals an order (`appealOrder`) 

2. A Settler is invited to cast investigate and cast a vote. A settler can vote for an order to be cancelled (`voteCancelOrder`) or an order to be released (`voteReleaseOrder`)

3. If both Trader and Merchant agrees on the Settler's vote, the order is then cancelled (`cancelOrder`) or released (`releaseOrder`)

4. In the event of a disagreement, both Trader or Merchant can appeal the voting decision. A new Settler will then be invited to cast new votes. This process can happen a maximum of 4 times. 

5. On the 5th time, the voting will be left for the DAO (`daoVote`) who's decision will be final either to cancel the order (`cancelOrder`) or release the order (`releaseOrder`)

<h3>
<details>
    <summary>Diagram for Settle Flow</summary>

![](/specification-assets/settle_flow.png)
</details>
</h3>

## Higher Level Overview

### Buy and Sell Flow Interactions
<h3>
<details>
    <summary>Diagram for Buy, Sell and Settle Flow</summary>

![](/specification-assets/buy_sell_combined.png)
</details>
</h3>

## Buy, Sell and Settlement Interactions

<h3>
<details>
    <summary>Diagram for Settle Flow</summary>

![](/specification-assets/buy_sell_settle_combined.png)
</details>
</h3>

## DAO

The DAO is automatically comprised of all merchants, traders and settlers. All of these actors are eligible to vote on issues as long as the following conditions are met.

- Member has completed at least kyc level2
- Member has reputation score > 0

The weight of a member's vote is linearly determined by their reputation score and kyc vote

## Reputation

Reputation score can increase or decrease based on the behaviour of the actor.

### Increase

- successfull trade with no appeals both parties are awarded
- Correct judging by setller. At the end of settling process, a correct judge is part of the majority.

### Decrease

- Guilty party in appeal is punished by deduction.
- Wrong judging by settler. At the end of the settling process, a wrong judge is part of the minority.

## Penalty

Depending on the actor in question, the penalty is slashed from different sources. In any case, their reputation is slashed to 0.

### Settler

- If a settler is caught being dishonest, 50% of their stake will be slashed.

- Also, a settler must have a stake of at least 20% of the amount on the trade to be able to settle the trade.

- Example, if a trade is valued 1000 usdt, the settler must have a stake of 200 usdt.

- A settler can only settle trades involving the tokens they have staked.

### Trader

- A trader can be a buyer or a seller.

- A seller can only sell 90% of the tokens in their possesion. The remaining will be used as a stake to be slashed in event of any dishonest behaviour.

- A dishonest buyer will only receive 90% of the intended amount to be received.

### Merchant

- If a merchant is caught being dishonest, 50% of their stake will be slashed.

- Also, a merchant must have a stake of at least 100% of the amount on the trade to be able to settle the trade.

- Example, if a trade is valued 1000 usdt, the merchant must have a stake of 1000 usdt.

- A merchant can only trade tokens they have staked.

## Entities

# Actors

- Merchant
- Trader
- Settler

# Abstract

- Offer
- Order
- Payment Method
- Payment Details
- Appeal
- AppealVote
