import { ethers } from "hardhat";

async function main() {
  const shadow = await ethers.getContractAt(
    "AMLBlacklist",
    process.env.AML!
  );

  await shadow.addAgent("0x8DB769ccD2f5946a94fCe8b3Ad9a296D5309c36c");
  const shadowey = await ethers.getContractAt(
    "KYCWhitelist",
    process.env.KYC!
  );
  await shadowey.addAgent("0x8DB769ccD2f5946a94fCe8b3Ad9a296D5309c36c");

  console.log("Agents Added ...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
