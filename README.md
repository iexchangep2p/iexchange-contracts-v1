# iExchange = DEX + P2P (Onchian)

P2P contract uses an optimistic P2P algorithm, find spec here [Specification](./specification.md).

## Initial Deployment & Setup Steps

1. Deploy erc20 tokens or use existing ones

- Cedih `CEDIH`
- Ramp `RAMP`
- Troken `TRK`

2. Deploy KYC & AML Contracts

- Kyc `KYC`
- Aml `AML`

3. Deploy Optimistic P2P contract `OP2P`

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
##### KYC
Deploy - `npx hardhat run scripts/deploy_kyc.ts --network baseTestnet`
Verify - `npx hardhat verify [KYC] --network baseTestnet`
Url - https://sepolia.basescan.org/address/0xa7c3a5bd99E11E0d8cD21952a0133449b194d3A8

##### AML
Deploy - `npx hardhat run scripts/deploy_aml.ts --network baseTestnet`
Verify - `npx hardhat verify [AML] --network baseTestnet`
Url - https://sepolia.basescan.org/address/0x18604e817ad31fF53031B955f834Df4B26e5AB73

#### Deploy Optimistic P2P contract

Deploy - `npx hardhat run scripts/deploy_p2p.ts --network baseTestnet`
Verify - `npx hardhat verify --constructor-args contract-args/p2p.ts --network baseTestnet [OP2P]`
Url - https://sepolia.basescan.org/address/0xB2002EaFC86DD21eaDAed4b1a7857357a6C3f41f
