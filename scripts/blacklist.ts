import { ethers } from "hardhat";

async function main() {
  const shadow = await ethers.getContractAt(
    "AMLBlacklist",
    process.env.AML!
  );

  await shadow.addBlacklist("0x3950355B679D6d115Bb680C620a3B7b32f540001");

  console.log("Address Blacklisted ...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
