import { ethers } from "hardhat";
import faucet from "../contract-args/faucet";

async function main() {
  const shadow = await ethers.getContractAt(
    "IXFaucet",
    process.env.IXFAUCET!
  );

  await shadow.setTokens(faucet);


  console.log("new faucet tokens set");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
