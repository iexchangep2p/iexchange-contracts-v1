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
### Contract Addresses

- **IXUSDC**: [0x8750753695D7F994eF159Cc52B49f0930374D4CE](https://sepolia.arbiscan.io/address/0x8750753695D7F994eF159Cc52B49f0930374D4CE)
- **IXUSDT**: [0xe8fB78FD7C76A3e2f500d4302E8a75E6706804f8](https://sepolia.arbiscan.io/address/0xe8fB78FD7C76A3e2f500d4302E8a75E6706804f8)
- **IXFAUCET**: [0xe38b25BC2421F5Fde72661FA4c5c3035453bfCE6](https://sepolia.arbiscan.io/address/0xe38b25BC2421F5Fde72661FA4c5c3035453bfCE6)
- **KYC**: [0x13041cDFB971226Ac07c171A274cB72Ac8e209Be](https://sepolia.arbiscan.io/address/0x13041cDFB971226Ac07c171A274cB72Ac8e209Be)
- **AML**: [0x11342913a0b3814D1C39C78b3809c0b65B113eAC](https://sepolia.arbiscan.io/address/0x11342913a0b3814D1C39C78b3809c0b65B113eAC)
- **IEXATT**: [0xba15d76f67afc55455c1a9acc6b296114a42c641](https://sepolia.arbiscan.io/address/0xba15d76f67afc55455c1a9acc6b296114a42c641)
- **OP2P**: [0x3B42D1dEF553EE484984C6c3c769BE58005f5d11](https://sepolia.arbiscan.io/address/0x3B42D1dEF553EE484984C6c3c769BE58005f5d11)
- **DAO_ADDRESS**: [0x612Dfa9fF8d6D19eff48A78D2827aC5a8F138596](https://sepolia.arbiscan.io/address/0x612Dfa9fF8d6D19eff48A78D2827aC5a8F138596)

### Arbitrum Sepolia Deployment Instructions
#### Deploy erc20 tokens

##### IXUSDT

Deploy - `npx hardhat run scripts/deploy_usdt.ts --network arbitrumSepolia`
Verify - `npx hardhat verify [IXUSDT] --network arbitrumSepolia --contract contracts/tokens/IXUSDT.sol:IXUSDT`
Url - <https://sepolia.arbiscan.io/address/0x1234567890abcdef1234567890abcdef12345678>

##### IXUSDC

Deploy - `npx hardhat run scripts/deploy_usdc.ts --network arbitrumSepolia`
Verify - `npx hardhat verify [IXUSDC] --network arbitrumSepolia --contract contracts/tokens/IXUSDC.sol:IXUSDC`
Url - <https://sepolia.arbiscan.io/address/0xabcdef1234567890abcdef1234567890abcdef12>



#### Deploy KYC & AML Contracts

##### IEXATT

Deploy - `npx hardhat run scripts/deploy_attest.ts --network arbitrumSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/attest.ts --network arbitrumSepolia [IEXATT]`
Url - <https://sepolia.arbiscan.io/address/0xabcdef7890abcdef1234567890abcdef12345678>

##### KYC

Deploy - `npx hardhat run scripts/deploy_kyc.ts --network arbitrumSepolia`
Verify - `npx hardhat verify [KYC] [IEXATT] --network arbitrumSepolia`
Url - <https://sepolia.arbiscan.io/address/0x1234567890abcdef7890abcdef1234567890abcd>

##### AML

Deploy - `npx hardhat run scripts/deploy_aml.ts --network arbitrumSepolia`
Verify - `npx hardhat verify [AML] --network arbitrumSepolia`
Url - <https://sepolia.arbiscan.io/address/0xabcdef1234567890abcdef7890abcdef12345678>

#### Deploy Optimistic P2P contract

Deploy - `npx hardhat run scripts/deploy_p2p.ts --network arbitrumSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/p2p.ts --network arbitrumSepolia [OP2P]`
Url - <https://sepolia.arbiscan.io/address/0x7890abcdef1234567890abcdef7890abcdef1234>

##### After Deployment

`npx hardhat run scripts/add_tokens.ts --network arbitrumSepolia`
`npx hardhat run scripts/add_currency_payments.ts --network arbitrumSepolia`
`npx hardhat run scripts/register_merchant.ts --network arbitrumSepolia`
`npx hardhat run scripts/register_settler.ts --network arbitrumSepolia`
`npx hardhat run scripts/create_offer.ts --network arbitrumSepolia`