import { ethers } from "hardhat";
import "dotenv/config";

async function main() {
  const shadow = await ethers.getContractAt(
    "UniswapV2Factory",
    process.env.PAIR_FACTORY!
  );

  
  await shadow.createPair(
    process.env.CEDIH!,
    process.env.TRK!
  );

  console.log("Pairs Created");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
