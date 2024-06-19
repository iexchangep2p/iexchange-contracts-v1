import { ethers } from "hardhat";

async function main() {
  const shadow = await ethers.getContractAt(
    "KYCWhitelist",
    process.env.KYC!
  );

  await shadow.upgradeKYCLevel("0xbd8904cD5F3b8383D3B90bCFa52E9Ca3f48E4163", 3);

  console.log("Address Whitelisted ...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
