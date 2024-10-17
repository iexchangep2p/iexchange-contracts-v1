import * as dotenv from "dotenv";

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.26",
        settings: {
          viaIR: true,
          optimizer: {
            enabled: true,
            runs: 1_000_000,
          },
          evmVersion: "london",
        },
      },
    ],
  },
  networks: {
    morphTestnet: {
      url: "https://rpc-quicknode-holesky.morphl2.io",
      accounts: [process.env.PRIVATE_KEY!],
      gasPrice: 20000000000, // 2 gwei in wei
    },
    baseTestnet: {
      url: "https://intensive-tame-sound.base-sepolia.quiknode.pro/4eebc97d37bc1e1c22d663a99a3ddbb0a4cf41c5/",
      chainId: 84532,
      accounts: [process.env.PRIVATE_KEY!],
    },
    kakarotSepolia: {
      url: "https://sepolia-rpc.kakarot.org",
      chainId: 920637907288165,
      accounts: [process.env.PRIVATE_KEY!],
      gasPrice: 20000000000, // 2 gwei in wei
    }
  },
  etherscan: {
    apiKey: {
      baseSepolia: process.env.ETHERSCAN_KEY!,
      kakarotSepolia: "testnet/evm/920637907288165",
      morphTestnet: "anything",
    },
    customChains: [
      {
        network: "morphTestnet",
        chainId: 2810,
        urls: {
          apiURL: "https://explorer-api-holesky.morphl2.io/api? ",
          browserURL: "https://explorer-holesky.morphl2.io/",
        },
      },
      {
        network: "kakarotSepolia",
        chainId: 920637907288165,
        urls: {
          apiURL:
            "https://api.routescan.io/v2/network/testnet/evm/920637907288165/etherscan",
          browserURL: "https://blockscout-kkrt-sepolia.karnot.xyz",
        },
      },
    ],
  },
};

export default config;
