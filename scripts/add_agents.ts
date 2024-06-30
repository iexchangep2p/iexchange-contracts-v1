import { ethers } from "hardhat";

async function main() {
  const shadow = await ethers.getContractAt(
    "AMLBlacklist",
    process.env.AML!
  );

  await shadow.addAgent(process.env.DA0_ADDRESS!);
  const shadowey = await ethers.getContractAt(
    "KYCWhitelist",
    process.env.KYC!
  );
  await shadowey.addAgent(process.env.DA0_ADDRESS!);

  console.log("Agents Added ...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
