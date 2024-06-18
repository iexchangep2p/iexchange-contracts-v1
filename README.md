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

#### Cedih

Deploy - `npx hardhat run scripts/deploy_topic_registry.ts --network morphTestnet`
Verify - `npx hardhat verify [TOPIC_REGISTRY] --network morphTestnet`
Url - https://explorer-holesky.morphl2.io/address/0x8BA0d448FAD5469D0BE9E7aF3c2b7be0d689db47