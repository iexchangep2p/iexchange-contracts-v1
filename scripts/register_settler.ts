import { ethers } from "hardhat";
import "dotenv/config";

async function main() {
  const p2p = await ethers.getContractAt("OptimisticP2P", process.env.OP2P!);

  const cd = await ethers.getContractAt("IXUSDC", process.env.IXUSDC!);

  const settlerStakeAmount = BigInt(1500 * 1e18);

  await cd.approve(process.env.OP2P!, settlerStakeAmount);

  await p2p.registerSettler();

  console.log("New Settler Registered ...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
