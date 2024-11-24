# iExchange = P2P (Onchian)

P2P contract uses an optimistic P2P algorithm, find spec here [P2P Spec](./p2p.spec.md).

AML & KYC contract with offchian zkKyc agent, find spec here [KYC Spec](./kyc.spec.md).

## Initial Deployment & Setup Steps

1. Deploy erc20 tokens or use existing ones

- Cedih `IXUSDC`
- Ramp `IXUSDT`

2. Deploy KYC & AML Contracts

- Deploy zkpass attestations `IEXATT`
- Kyc `KYC`
- Aml `AML`

3. Deploy Optimistic P2P contract `OP2P`

4. Deploy Pair Factor

5. Deploy WETH

6. Deploy Router

### Deployments

<details>
<summary> Ink Sepolia </summary>

#### Deploy erc20 tokens

##### IXUSDC

Deploy - `npx hardhat run scripts/deploy_usdc.ts --network inkSepolia`
Verify - `npx hardhat verify [IXUSDC] --network inkSepolia --contract contracts/tokens/IXUSDC.sol:IXUSDC`
Url - <https://explorer-sepolia.inkonchain.com/address/0xACBC1eC300bBea9A9FD0A661cD717d8519c5FCA5>

##### IXUSDT

Deploy - `npx hardhat run scripts/deploy_usdt.ts --network inkSepolia`
Verify - `npx hardhat verify [IXUSDT] --network inkSepolia --contract contracts/tokens/IXUSDT.sol:IXUSDT`
Url - <https://explorer-sepolia.inkonchain.com/address/0x28cB409154beb695D5E9ffA85dA8f1564Aa3cD76>

#### Deploy Token Faucet

Deploy - `npx hardhat run scripts/deploy_faucet.ts --network inkSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/faucet.ts --network inkSepolia [IXFAUCET]`
Url - <https://explorer-sepolia.inkonchain.com/address/0x935E49458145B917a0EaEE279652F724EA78d8F0>

#### Deploy KYC & AML Contracts

##### IEXATT

Deploy - `npx hardhat run scripts/deploy_attest.ts --network inkSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/attest.ts --network inkSepolia [IEXATT]`
Url - <https://explorer-sepolia.inkonchain.com/address/0xa7c3a5bd99E11E0d8cD21952a0133449b194d3A8>

##### KYC

Deploy - `npx hardhat run scripts/deploy_kyc.ts --network inkSepolia`
Verify - `npx hardhat verify [KYC] [IEXATT] --network inkSepolia`
Url - <https://explorer-sepolia.inkonchain.com/address/0x18604e817ad31fF53031B955f834Df4B26e5AB73>

##### AML

Deploy - `npx hardhat run scripts/deploy_aml.ts --network inkSepolia`
Verify - `npx hardhat verify [AML] --network inkSepolia`
Url - <https://explorer-sepolia.inkonchain.com/address/0xB2002EaFC86DD21eaDAed4b1a7857357a6C3f41f>

#### Deploy Optimistic P2P contract

Deploy - `npx hardhat run scripts/deploy_p2p.ts --network inkSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/p2p.ts --network inkSepolia [OP2P]`
Url - <https://explorer-sepolia.inkonchain.com/address/0x08FD9b19435dD5bdbaF183EE3fe68dCD6fD709EF>

##### After Deployment

`npx hardhat run scripts/add_tokens.ts --network inkSepolia`
`npx hardhat run scripts/add_currency_payments.ts --network inkSepolia`
</details>

<details>
<summary> Scroll Sepolia </summary>

#### Deploy erc20 tokens

##### IXUSDC

Deploy - `npx hardhat run scripts/deploy_usdc.ts --network scrollSepolia`
Verify - `npx hardhat verify [IXUSDC] --network scrollSepolia --contract contracts/tokens/IXUSDC.sol:IXUSDC`
Url - <https://sepolia.scrollscan.com/address/0xACBC1eC300bBea9A9FD0A661cD717d8519c5FCA5>

##### IXUSDT

Deploy - `npx hardhat run scripts/deploy_usdt.ts --network scrollSepolia`
Verify - `npx hardhat verify [IXUSDT] --network scrollSepolia --contract contracts/tokens/IXUSDT.sol:IXUSDT`
Url - <https://sepolia.scrollscan.com/address/0x28cB409154beb695D5E9ffA85dA8f1564Aa3cD76>

#### Deploy Token Faucet

Deploy - `npx hardhat run scripts/deploy_faucet.ts --network scrollSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/faucet.ts --network scrollSepolia [IXFAUCET]`
Url - <https://sepolia.scrollscan.com/address/0x0089326cF33fF85f9AA39e02F4557B454327A17F>

#### Deploy KYC & AML Contracts

##### IEXATT

Deploy - `npx hardhat run scripts/deploy_attest.ts --network scrollSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/attest.ts --network scrollSepolia [IEXATT]`
Url - <https://sepolia.scrollscan.com/address/0xa7c3a5bd99E11E0d8cD21952a0133449b194d3A8>

##### KYC

Deploy - `npx hardhat run scripts/deploy_kyc.ts --network scrollSepolia`
Verify - `npx hardhat verify [KYC] [IEXATT] --network scrollSepolia`
Url - <https://sepolia.scrollscan.com/address/0x18604e817ad31fF53031B955f834Df4B26e5AB73>

##### AML

Deploy - `npx hardhat run scripts/deploy_aml.ts --network scrollSepolia`
Verify - `npx hardhat verify [AML] --network scrollSepolia`
Url - <https://sepolia.scrollscan.com/address/0xB2002EaFC86DD21eaDAed4b1a7857357a6C3f41f>

#### Deploy Optimistic P2P contract

Deploy - `npx hardhat run scripts/deploy_p2p.ts --network scrollSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/p2p.ts --network scrollSepolia [OP2P]`
Url - <https://sepolia.scrollscan.com/address/0x08FD9b19435dD5bdbaF183EE3fe68dCD6fD709EF>

##### After Deployment

`npx hardhat run scripts/add_tokens.ts --network scrollSepolia`
`npx hardhat run scripts/add_currency_payments.ts --network scrollSepolia`
</details>

<details>
<summary> Arbitrum Sepolia </summary>

#### Deploy erc20 tokens

##### IXUSDC

Deploy - `npx hardhat run scripts/deploy_usdc.ts --network arbTestnet`
Verify - `npx hardhat verify [IXUSDC] --network arbTestnet --contract contracts/tokens/IXUSDC.sol:IXUSDC`
Url - <https://sepolia.arbscan.org/address/0x8750753695D7F994eF159Cc52B49f0930374D4CE>

##### IXUSDT

Deploy - `npx hardhat run scripts/deploy_usdt.ts --network arbTestnet`
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

##### IXUSDC

Deploy - `npx hardhat run scripts/deploy_usdc.ts --network baseSepolia`
Verify - `npx hardhat verify [IXUSDC] --network baseSepolia --contract contracts/tokens/IXUSDC.sol:IXUSDC`
Url - <https://base-sepolia.blockscout.com/address/0xf23Dd142E074534eCB784b067DBFa68a10712759>

##### IXUSDT

Deploy - `npx hardhat run scripts/deploy_usdt.ts --network baseSepolia`
Verify - `npx hardhat verify [IXUSDT] --network baseSepolia --contract contracts/tokens/IXUSDT.sol:IXUSDT`
Url - <https://base-sepolia.blockscout.com/address/0xf6A2C93fDC1d1eA25E1aEc278c13AAca884394D5>

#### Deploy Token Faucet

Deploy - `npx hardhat run scripts/deploy_faucet.ts --network baseSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/faucet.ts --network baseSepolia [IXFAUCET]`
Url - <https://base-sepolia.blockscout.com/address/0x8dd31A3eB73c13D535b2F615b1c5C8D761162436>

#### Deploy KYC & AML Contracts

##### IEXATT

Deploy - `npx hardhat run scripts/deploy_attest.ts --network baseSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/attest.ts --network baseSepolia [IEXATT]`
Url - <https://base-sepolia.blockscout.com/address/0x963375d44E0D6A794D9cb10e8EdE80A2f1335587>

##### KYC

Deploy - `npx hardhat run scripts/deploy_kyc.ts --network baseSepolia`
Verify - `npx hardhat verify [KYC] [IEXATT] --network baseSepolia`
Url - <https://base-sepolia.blockscout.com/address/0x0906Ac92b77728A0131F172ef0CE64eB0bC2957B>

##### AML

Deploy - `npx hardhat run scripts/deploy_aml.ts --network baseSepolia`
Verify - `npx hardhat verify [AML] --network baseSepolia`
Url - <https://base-sepolia.blockscout.com/address/0x945E4c081D9da869D61dc7bdC6682B54b197eb2D>

#### Deploy Optimistic P2P contract

Deploy - `npx hardhat run scripts/deploy_p2p.ts --network baseSepolia`
Verify - `npx hardhat verify --constructor-args contract-args/p2p.ts --network baseSepolia [OP2P]`
Url - <https://base-sepolia.blockscout.com/address/0x0c3C2c104A7eDeC4251f8f8D0C737B1C854207b5>

##### After Deployment

`npx hardhat run scripts/add_tokens.ts --network baseSepolia`
`npx hardhat run scripts/add_currency_payments.ts --network baseSepolia`
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