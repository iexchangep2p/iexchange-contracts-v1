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

<details>
<summary> Arbitrum Sepolia </summary>

#### Deploy erc20 tokens

##### IXUSDC

Deploy - `npx hardhat run scripts/deploy_cd.ts --network arbTestnet`
Verify - `npx hardhat verify [IXUSDC] --network arbTestnet --contract contracts/tokens/IXUSDC.sol:IXUSDC`
Url - <https://sepolia.arbscan.org/address/0x8750753695D7F994eF159Cc52B49f0930374D4CE>

##### IXUSDT

Deploy - `npx hardhat run scripts/deploy_rmp.ts --network arbTestnet`
Verify - `npx hardhat verify [IXUSDT] --network arbTestnet --contract contracts/tokens/IXUSDT.sol:IXUSDT`
Url - <https://sepolia.arbscan.org/address/0xe8fB78FD7C76A3e2f500d4302E8a75E6706804f8>

#### Deploy Token Faucet

Deploy - `npx hardhat run scripts/deploy_faucet.ts --network arbTestnet`
Verify - `npx hardhat verify --constructor-args contract-args/faucet.ts --network arbTestnet [IXFAUCET]`
Url - <https://sepolia.arbscan.org/address/0xe38b25BC2421F5Fde72661FA4c5c3035453bfCE6>

#### Deploy KYC & AML Contracts

##### IEXATT

Deploy - `npx hardhat run scripts/deploy_attest.ts --network arbTestnet`
Verify - `npx hardhat verify --constructor-args contract-args/attest.ts --network arbTestnet [IEXATT]`
Url - <https://sepolia.arbscan.org/address/0xba15d76f67afc55455c1a9acc6b296114a42c641>

##### KYC

Deploy - `npx hardhat run scripts/deploy_kyc.ts --network arbTestnet`
Verify - `npx hardhat verify [KYC] [IEXATT] --network arbTestnet`
Url - <https://sepolia.arbscan.org/address/0x13041cDFB971226Ac07c171A274cB72Ac8e209Be>

##### AML

Deploy - `npx hardhat run scripts/deploy_aml.ts --network arbTestnet`
Verify - `npx hardhat verify [AML] --network arbTestnet`
Url - <https://sepolia.arbscan.org/address/0x11342913a0b3814D1C39C78b3809c0b65B113eAC>

#### Deploy Optimistic P2P contract

Deploy - `npx hardhat run scripts/deploy_p2p.ts --network arbTestnet`
Verify - `npx hardhat verify --constructor-args contract-args/p2p.ts --network arbTestnet [OP2P]`
Url - <https://sepolia.arbscan.org/address/0x3B42D1dEF553EE484984C6c3c769BE58005f5d11>

##### After Deployment

`npx hardhat run scripts/add_tokens.ts --network arbTestnet`
`npx hardhat run scripts/add_currency_payments.ts --network arbTestnet`
</details>
<details>
<summary>  Morph Holesky </summary>

##### Cedih

Deploy - `npx hardhat run scripts/deploy_cd.ts --network morphTestnet`
Verify - `npx hardhat verify [CEDIH] --network morphTestnet --contract contracts/tokens/Cedih.sol:Cedih`
Url - <https://explorer-holesky.morphl2.io/address/0xE4052c1cCd27C049763fb42D58d612f3C79Bb9FC>

##### Ramp

Deploy - `npx hardhat run scripts/deploy_rmp.ts --network morphTestnet`
Verify - `npx hardhat verify [RAMP] --network morphTestnet --contract contracts/tokens/Ramp.sol:Ramp`
Url - <https://explorer-holesky.morphl2.io/address/0x1840BD3e5636Ab619B1A4399b1C60d71b9FEB3a3>

##### TRK

Deploy - `npx hardhat run scripts/deploy_trk.ts --network morphTestnet`
Verify - `npx hardhat verify [TRK] --network morphTestnet --contract contracts/tokens/Troken.sol:Troken`
Url - <https://explorer-holesky.morphl2.io/address/0x8F3c46C38506E76F2614621E5c4255BA8B8b12ae>

##### IXUSDC

Deploy - `npx hardhat run scripts/deploy_usdc.ts --network morphTestnet`
Verify - `npx hardhat verify [IXUSDC] --network morphTestnet --contract contracts/tokens/IXUSDC.sol:IXUSDC`
Url - <https://explorer-holesky.morphl2.io/address/0x6805F4d4BAB919f4e1e9fa593A03E5d13CBeDfb2>

##### IXUSDT

Deploy - `npx hardhat run scripts/deploy_usdt.ts --network morphTestnet`
Verify - `npx hardhat verify [IXUSDT] --network morphTestnet --contract contracts/tokens/IXUSDT.sol:IXUSDT`
Url - <https://explorer-holesky.morphl2.io/address/0x9bABB7c87eb0D2b39981D12e44196b52694ed7a5>

#### Deploy Token Faucet

Deploy - `npx hardhat run scripts/deploy_faucet.ts --network morphTestnet`
Verify - `npx hardhat verify --constructor-args contract-args/faucet.ts --network morphTestnet [IXFAUCET]`
Url - <https://explorer-holesky.morphl2.io/address/0x8C49Fd0b3E42DbAE0b13Fde81E3023c626E6f198>

#### Deploy KYC & AML Contracts

##### IEXATT

Deploy - `npx hardhat run scripts/deploy_attest.ts --network morphTestnet`
Verify - `npx hardhat verify --constructor-args contract-args/attest.ts --network morphTestnet [IEXATT]`
Url - <https://explorer-holesky.morphl2.io/address/0x28d4073C5A7eC8eb107331de600c6EE40d057ECC>

##### KYC

Deploy - `npx hardhat run scripts/deploy_kyc.ts --network morphTestnet`
Verify - `npx hardhat verify [KYC] [IEXATT] --network morphTestnet`
Url - <https://explorer-holesky.morphl2.io/address/0xf2D9A61999f22245831b2C51904Fe11F80e5bFD0>

##### AML

Deploy - `npx hardhat run scripts/deploy_aml.ts --network morphTestnet`
Verify - `npx hardhat verify [AML] --network morphTestnet`
Url - <https://explorer-holesky.morphl2.io/address/0xF99F96fe433E79f2A83c67cBd1a6b1B6b986aA6B>

##### After Deployment

`npx hardhat run scripts/add_agents.ts --network morphTestnet`
`npx hardhat run scripts/whitelist.ts --network morphTestnet`
`npx hardhat run scripts/blacklist.ts --network morphTestnet`

#### Deploy Optimistic P2P contract

Deploy - `npx hardhat run scripts/deploy_p2p.ts --network morphTestnet`
Verify - `npx hardhat verify --constructor-args contract-args/p2p.ts --network morphTestnet [OP2P]`
Url - <https://explorer-holesky.morphl2.io/address/0x1E7f97Fc8C240D2B26A42d9A50592Fcd78574B41>

##### After Deployment

`npx hardhat run scripts/add_tokens.ts --network morphTestnet`
`npx hardhat run scripts/add_currency_payments.ts --network morphTestnet`
`npx hardhat run scripts/register_merchant.ts --network morphTestnet`
`npx hardhat run scripts/register_settler.ts --network morphTestnet`
`npx hardhat run scripts/create_offer.ts --network morphTestnet`
</details>
<details>
<summary>  Base Sepolia</summary>

#### Deploy erc20 tokens

##### Cedih

Deploy - `npx hardhat run scripts/deploy_cd.ts --network baseTestnet`
Verify - `npx hardhat verify [CEDIH] --network baseTestnet --contract contracts/tokens/Cedih.sol:Cedih`
Url - <https://sepolia.basescan.org/address/0xACBC1eC300bBea9A9FD0A661cD717d8519c5FCA5>

##### Ramp

Deploy - `npx hardhat run scripts/deploy_rmp.ts --network baseTestnet`
Verify - `npx hardhat verify [RAMP] --network baseTestnet --contract contracts/tokens/Ramp.sol:Ramp`
Url - <https://sepolia.basescan.org/address/0x28cB409154beb695D5E9ffA85dA8f1564Aa3cD76>

##### TRK

Deploy - `npx hardhat run scripts/deploy_trk.ts --network baseTestnet`
Verify - `npx hardhat verify [TRK] --network baseTestnet --contract contracts/tokens/Troken.sol:Troken`
Url - <https://sepolia.basescan.org/address/0x935E49458145B917a0EaEE279652F724EA78d8F0>

#### Deploy KYC & AML Contracts

##### IEXATT

Deploy - `npx hardhat run scripts/deploy_attest.ts --network baseTestnet`
Verify - `npx hardhat verify --constructor-args contract-args/attest.ts --network baseTestnet [IEXATT]`
Url - <https://sepolia.basescan.org/address/0x8C49Fd0b3E42DbAE0b13Fde81E3023c626E6f198>

##### KYC

Deploy - `npx hardhat run scripts/deploy_kyc.ts --network baseTestnet`
Verify - `npx hardhat verify [KYC] [IEXATT] --network baseTestnet`
Url - <https://sepolia.basescan.org/address/0xEa9Fee2c40Fc49139482a77626dAd0Dcf2b6c0C9>

##### AML

Deploy - `npx hardhat run scripts/deploy_aml.ts --network baseTestnet`
Verify - `npx hardhat verify [AML] --network baseTestnet`
Url - <https://sepolia.basescan.org/address/0x18604e817ad31fF53031B955f834Df4B26e5AB73>

#### Deploy Optimistic P2P contract

Deploy - `npx hardhat run scripts/deploy_p2p.ts --network baseTestnet`
Verify - `npx hardhat verify --constructor-args contract-args/p2p.ts --network baseTestnet [OP2P]`
Url - <https://sepolia.basescan.org/address/0x2977c7941c59572433DF543cDBDF92a5Ae8F6267>

##### After Deployment

`npx hardhat run scripts/add_tokens.ts --network baseTestnet`
`npx hardhat run scripts/add_currency_payments.ts --network baseTestnet`
</details>
<details>
<summary> Kakarot Sepolia</summary>

##### Cedih

Deploy - `npx hardhat run scripts/deploy_cd.ts --network kakarotSepolia`
Verify - `npx hardhat verify [CEDIH] --network kakarotSepolia --contract contracts/tokens/Cedih.sol:Cedih`
Url - <https://sepolia.kakarotscan.org/address/0xB2002EaFC86DD21eaDAed4b1a7857357a6C3f41f>

##### Ramp

Deploy - `npx hardhat run scripts/deploy_rmp.ts --network kakarotSepolia`
Verify - `npx hardhat verify [RAMP] --network kakarotSepolia --contract contracts/tokens/Ramp.sol:Ramp`
Url - <https://sepolia.kakarotscan.org/address/0x08FD9b19435dD5bdbaF183EE3fe68dCD6fD709EF>

##### TRK

Deploy - `npx hardhat run scripts/deploy_trk.ts --network kakarotSepolia`
Verify - `npx hardhat verify [TRK] --network kakarotSepolia --contract contracts/tokens/Troken.sol:Troken`
Url - <https://sepolia.kakarotscan.org/address/0x53637cE365d796FA32eE3FB1A0cB8408Df0fB554>

##### IXUSDC

Deploy - `npx hardhat run scripts/deploy_usdc.ts --network kakarotSepolia`
Verify - `npx hardhat verify [IXUSDC] --network kakarotSepolia --contract contracts/tokens/IXUSDC.sol:IXUSDC`
Url - <https://sepolia.kakarotscan.org/address/0xF5Bd8F96A9cb7e27a838aFA4AF55df5594bc9041>

##### IXUSDT

Deploy - `npx hardhat run scripts/deploy_usdt.ts --network kakarotSepolia`
Verify - `npx hardhat verify [IXUSDT] --network kakarotSepolia --contract contracts/tokens/IXUSDT.sol:IXUSDT`
Url - <https://sepolia.kakarotscan.org/address/0x7281b4cCA308aF757D8BE75e62241e5e0c88CAA3>

#### Deploy Token Faucet

Deploy - `npx hardhat run scripts/deploy_faucet.ts --network kakarotSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/faucet.ts --network kakarotSepolia [IXFAUCET]`
Url - <https://sepolia.kakarotscan.org/address/0x5FBDb7C37E3338130F925ec5355B29A6d6Da5309>

#### Deploy KYC & AML Contracts

##### IEXATT

Deploy - `npx hardhat run scripts/deploy_attest.ts --network kakarotSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/attest.ts --network kakarotSepolia [IEXATT]`
Url - <https://sepolia.kakarotscan.org/address/0xc1272b64F1b500dCe5059b3951afEA77b329e2B9>

##### KYC

Deploy - `npx hardhat run scripts/deploy_kyc.ts --network kakarotSepolia`
Verify - `npx hardhat verify [KYC] [IEXATT] --network kakarotSepolia`
Url - <https://sepolia.kakarotscan.org/address/0x76411bBAAf025F3D25aFFcEb79209eE89cA554Bd>

##### AML

Deploy - `npx hardhat run scripts/deploy_aml.ts --network kakarotSepolia`
Verify - `npx hardhat verify [AML] --network kakarotSepolia`
Url - <https://sepolia.kakarotscan.org/address/0x6e5407517BaBc317b4D4003f12f51a9D2179ee7E>

##### After Deployment

`npx hardhat run scripts/add_agents.ts --network kakarotSepolia`
`npx hardhat run scripts/whitelist.ts --network kakarotSepolia`
`npx hardhat run scripts/blacklist.ts --network kakarotSepolia`

#### Deploy Optimistic P2P contract

Deploy - `npx hardhat run scripts/deploy_p2p.ts --network kakarotSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/p2p.ts --network kakarotSepolia [OP2P]`
Url - <https://sepolia.kakarotscan.org/address/0xEd64A15A6223588794A976d344990001a065F3f1>

##### After Deployment

`npx hardhat run scripts/add_tokens.ts --network kakarotSepolia`
`npx hardhat run scripts/add_currency_payments.ts --network kakarotSepolia`
`npx hardhat run scripts/register_merchant.ts --network kakarotSepolia`
`npx hardhat run scripts/register_settler.ts --network kakarotSepolia`
`npx hardhat run scripts/create_offer.ts --network kakarotSepolia`
</details>