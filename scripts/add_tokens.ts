import { ethers } from "hardhat";

async function main() {
  const shadow = await ethers.getContractAt(
    "OptimisticP2P",
    process.env.OP2P!
  );

  await shadow.addToken(process.env.IXUSDT!);
  await shadow.addToken(process.env.IXUSDC!);

  console.log("Tokens Added ...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
