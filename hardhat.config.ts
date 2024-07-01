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
    baseTestnet: {
      url: "https://intensive-tame-sound.base-sepolia.quiknode.pro/4eebc97d37bc1e1c22d663a99a3ddbb0a4cf41c5/",
      chainId: 84532,
      accounts: [process.env.PRIVATE_KEY!],
    },
    kakarotSepolia: {
      url: "https://sepolia-rpc.kakarot.org/",
      chainId: 1802203764,
      accounts: [process.env.PRIVATE_KEY!],
    },
  },
  etherscan: {
    apiKey: {
      baseSepolia: process.env.ETHERSCAN_KEY!,
      "kakarotSepolia": "testnet/evm/1802203764",
    },
    customChains: [
      {
        network: "kakarotSepolia",
        chainId: 1802203764,
        urls: {
          apiURL:
            "https://api.routescan.io/v2/network/testnet/evm/1802203764_2/etherscan",
          browserURL: "https://sepolia.kakarotscan.org",
        },
      },
    ],
  },
};

export default config;
