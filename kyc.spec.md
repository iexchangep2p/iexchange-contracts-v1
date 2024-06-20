## On-chain AML & KYC solution with off-chain AI monitoring agents for real-time detection and reporting of fraudulent accounts to the blockchain.

- Our system integrates real-time AML & KYC on-chain. This is to ensure that the P2P meets regulatory needs of fiat system.
- Blockchain accounts involved in hacks could try to sell their stolen funds on the P2P platform. 
- It is therefore necessary to have blacklist checks in place to ensure fraudulent accounts are not able to use the smart contract.
- This is made possible with offchain monitoring agents. Agents could be AI and or individual organizations dedicated to ensuring the purity of the platform.

### System Architecture for AML & KYC

- Image depicts how the P2P system interacts with the On-chain AML & KYC system. 
- It also shows how off-chain agents updates the on-chain AML & KYC contracts.


![](/specification-assets/aml_kyc_p2p.png)

- There are three main smart contract components depicted.
    - P2P Contract
    - AML Blacklisting Contract
    - KYC Whitelisting Contract

- Each of these have specific off-chain agents that interact with them.
    - zkPass Attestation Agent for sending kyc confirmations to the KYC smart contract
    - AML monitoring agents for detecting fraudulents accounts and blacklisting them on the AML contract.
    - Merchants, Traders and Settlers who use the P2P contract for their transactions.
