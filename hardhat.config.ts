import * as dotenv from "dotenv";

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.26",
    settings: {
      viaIR: true,
      optimizer: {
        enabled: true,
        runs: 99999,
      },
      evmVersion: "london",
    },
  },
  networks: {
    baseTestnet: {
      url: "https://intensive-tame-sound.base-sepolia.quiknode.pro/4eebc97d37bc1e1c22d663a99a3ddbb0a4cf41c5/",
      chainId: 11155420,
      accounts: [process.env.PRIVATE_KEY!],
    },
  },
  etherscan: {
    apiKey: {
      baseTestnet: process.env.ETHERSCAN_KEY!,
    },
  },
};

export default config;
