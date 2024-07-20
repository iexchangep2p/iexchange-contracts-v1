# iExchange = P2P (Onchian)

P2P contract uses an optimistic P2P algorithm, find spec here [P2P Spec](./p2p.spec.md).

AML & KYC contract with offchian zkKyc agent, find spec here [KYC Spec](./kyc.spec.md).

## Initial Deployment & Setup Steps

1. Deploy erc20 tokens or use existing ones

- Cedih `CEDIH`
- Ramp `RAMP`
- Troken `TRK`

2. Deploy KYC & AML Contracts

- Deploy zkpass attestations `IEXATT`
- Kyc `KYC`
- Aml `AML`

3. Deploy Optimistic P2P contract `OP2P`

4. Deploy Pair Factor

5. Deploy WETH

6. Deploy Router

## Deployments

### Base Sepolia

#### Deploy erc20 tokens
##### Cedih
Deploy - `npx hardhat run scripts/deploy_cd.ts --network baseTestnet`
Verify - `npx hardhat verify [CEDIH] --network baseTestnet --contract contracts/tokens/Cedih.sol:Cedih`
Url - https://sepolia.basescan.org/address/0xACBC1eC300bBea9A9FD0A661cD717d8519c5FCA5
##### Ramp
Deploy - `npx hardhat run scripts/deploy_rmp.ts --network baseTestnet`
Verify - `npx hardhat verify [RAMP] --network baseTestnet --contract contracts/tokens/Ramp.sol:Ramp`
Url - https://sepolia.basescan.org/address/0x28cB409154beb695D5E9ffA85dA8f1564Aa3cD76
##### TRK
Deploy - `npx hardhat run scripts/deploy_trk.ts --network baseTestnet`
Verify - `npx hardhat verify [TRK] --network baseTestnet --contract contracts/tokens/Troken.sol:Troken`
Url - https://sepolia.basescan.org/address/0x935E49458145B917a0EaEE279652F724EA78d8F0

#### Deploy KYC & AML Contracts
##### IEXATT
Deploy - `npx hardhat run scripts/deploy_attest.ts --network baseTestnet`
Verify - `npx hardhat verify --constructor-args contract-args/attest.ts --network baseTestnet [IEXATT]`
Url - https://sepolia.basescan.org/address/0x8C49Fd0b3E42DbAE0b13Fde81E3023c626E6f198
##### KYC
Deploy - `npx hardhat run scripts/deploy_kyc.ts --network baseTestnet`
Verify - `npx hardhat verify [KYC] [IEXATT] --network baseTestnet`
Url - https://sepolia.basescan.org/address/0xEa9Fee2c40Fc49139482a77626dAd0Dcf2b6c0C9
##### AML
Deploy - `npx hardhat run scripts/deploy_aml.ts --network baseTestnet`
Verify - `npx hardhat verify [AML] --network baseTestnet`
Url - https://sepolia.basescan.org/address/0x18604e817ad31fF53031B955f834Df4B26e5AB73

#### Deploy Optimistic P2P contract
Deploy - `npx hardhat run scripts/deploy_p2p.ts --network baseTestnet`
Verify - `npx hardhat verify --constructor-args contract-args/p2p.ts --network baseTestnet [OP2P]`
Url - https://sepolia.basescan.org/address/0x2977c7941c59572433DF543cDBDF92a5Ae8F6267

##### After Deployment
`npx hardhat run scripts/add_tokens.ts --network baseTestnet`
`npx hardhat run scripts/add_currency_payments.ts --network baseTestnet`

### Kakarot Sepolia

##### Cedih
Deploy - `npx hardhat run scripts/deploy_cd.ts --network kakarotSepolia`
Verify - `npx hardhat verify [CEDIH] --network kakarotSepolia --contract contracts/tokens/Cedih.sol:Cedih`
Url - https://sepolia.kakarotscan.org/address/0x3d63fEc287aD7963B614eD873690A745E635D5Fa
##### Ramp
Deploy - `npx hardhat run scripts/deploy_rmp.ts --network kakarotSepolia`
Verify - `npx hardhat verify [RAMP] --network kakarotSepolia --contract contracts/tokens/Ramp.sol:Ramp`
Url - https://sepolia.kakarotscan.org/address/0x39a7f0a342a0509C1aC248F379ba283e99c36Ae5
##### TRK
Deploy - `npx hardhat run scripts/deploy_trk.ts --network kakarotSepolia`
Verify - `npx hardhat verify [TRK] --network kakarotSepolia --contract contracts/tokens/Troken.sol:Troken`
Url - https://sepolia.kakarotscan.org/address/0x670a1c39227C2475de0459fAB245111F0f78A4Bf

#### Deploy KYC & AML Contracts
##### IEXATT
Deploy - `npx hardhat run scripts/deploy_attest.ts --network kakarotSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/attest.ts --network kakarotSepolia [IEXATT]`
Url - https://sepolia.kakarotscan.org/address/0xB3b75E9d2BAE1Aa3AF2caeC46ec7377c27f09D28
##### KYC
Deploy - `npx hardhat run scripts/deploy_kyc.ts --network kakarotSepolia`
Verify - `npx hardhat verify [KYC] [IEXATT] --network kakarotSepolia`
Url - https://sepolia.kakarotscan.org/address/0x9A7477C4fcD9ef5715cD1a96c567117F9fda3a7d
##### AML
Deploy - `npx hardhat run scripts/deploy_aml.ts --network kakarotSepolia`
Verify - `npx hardhat verify [AML] --network kakarotSepolia`
Url - https://sepolia.kakarotscan.org/address/0xFB7E20739Fa2b8b4351c9F87a1C68b728E7aa614
##### After Deployment
`npx hardhat run scripts/add_agents.ts --network kakarotSepolia`
`npx hardhat run scripts/whitelist.ts --network kakarotSepolia`
`npx hardhat run scripts/blacklist.ts --network kakarotSepolia`
#### Deploy Optimistic P2P contract
Deploy - `npx hardhat run scripts/deploy_p2p.ts --network kakarotSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/p2p.ts --network kakarotSepolia [OP2P]`
Url - https://sepolia.kakarotscan.org/address/0x06E33C181394c4910D078F71855fF6c5ccA0f375

##### After Deployment
`npx hardhat run scripts/add_tokens.ts --network kakarotSepolia`
`npx hardhat run scripts/add_currency_payments.ts --network kakarotSepolia`
`npx hardhat run scripts/register_merchant.ts --network kakarotSepolia`
`npx hardhat run scripts/register_settler.ts --network kakarotSepolia`
`npx hardhat run scripts/create_offer.ts --network kakarotSepolia`
