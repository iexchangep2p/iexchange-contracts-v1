import { ethers } from "hardhat";
import "dotenv/config";

async function main() {
  const shadow = await ethers.getContractAt(
    "UniswapV2Router02",
    process.env.ROUTER!
  );

  const cedih = await ethers.getContractAt(
    "Cedih",
    process.env.CEDIH!
  );

  const ramp = await ethers.getContractAt(
    "Ramp",
    process.env.RAMP!
  );

  const trk = await ethers.getContractAt(
    "Troken",
    process.env.TRK!
  );

  const maxAllowance = BigInt(1e6 * 1e18);

  const tokenA = process.env.CEDIH!;
  const tokenB = process.env.RAMP!;
  const amountADesired = BigInt(1e4 * 1e18);
  const amountBDesired = BigInt(1e5 * 1e18);
  const amountAMin = BigInt(BigInt(amountADesired * BigInt(90)) / BigInt(100));
  const amountBMin = BigInt(BigInt(amountADesired * BigInt(90)) / BigInt(100));
  const to = process.env.DA0_ADDRESS!;
  const deadline = Math.floor(Date.now() / 1000) + 60 * 60;

  await cedih.approve(process.env.ROUTER!, maxAllowance);
  await ramp.approve(process.env.ROUTER!, maxAllowance);
  await trk.approve(process.env.ROUTER!, maxAllowance);
  console.log(tokenA, tokenB, amountADesired, amountBDesired, 0, 0, to, deadline);
  
  await shadow.addLiquidity(
    tokenA,
    tokenB,
    amountADesired,
    amountBDesired,
    amountAMin,
    amountBMin,
    to,
    deadline
  );

  console.log("liquidity Added");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
