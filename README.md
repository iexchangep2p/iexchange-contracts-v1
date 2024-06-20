# iExchange = DEX + P2P (Onchian)

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

#### Deploy Factory Contract
Deploy - `npx hardhat run scripts/deploy_factory.ts --network baseTestnet`
Verify - `npx hardhat verify [PAIR_FACTORY] [DA0_ADDRESS] --network baseTestnet`
Url - https://sepolia.basescan.org/address/0xaA629706369aB3399D2D538D9d301C32a821927F

#### Deploy WETH
Deploy - `npx hardhat run scripts/deploy_weth.ts --network baseTestnet`
Verify - `npx hardhat verify [WETH] --network baseTestnet`
Url - https://sepolia.basescan.org/address/0xcB05E9aCA0d9b9d51d61E729b76e962e84F52f2A

#### Deploy Router Contract
Deploy - `npx hardhat run scripts/deploy_router.ts --network baseTestnet`
Verify - `npx hardhat verify [ROUTER] [PAIR_FACTORY] [WETH] --network baseTestnet`
Url - https://sepolia.basescan.org/address/0xDE25ffe99176C3aFeB56c47f3391e1F126976d08