import { ethers } from "hardhat";

async function main() {
  const shadow = await ethers.getContractAt("OptimisticP2P", process.env.OP2P!);

  const cedi = "GHS";
  const naira = "NGN";
  const shill = "KES";

  const momo = "Mobile Money";
  const fidelity = "Fidelity Bank";
  const mp = "M-Pesa";

  // await shadow.createOffer();
  // buy
  const token = process.env.RAMP!;
  const currency = naira;
  const paymentMethod = fidelity;
  const rate = 11;
  const minOrder = BigInt(1e4) * BigInt(1e18);
  const maxOrder = BigInt(1e6) * BigInt(1e18);
  const accountHash = ethers.keccak256(
    ethers.encodeBytes32String("Seth Baah Kusi0553339728")
  );
  const depositAddress = process.env.DA0_ADDRESS!;
  const offerType = 1;

  const cd = await ethers.getContractAt("Ramp", process.env.RAMP!);

  const merchantStakeAmount = BigInt(1500 * 1e18);

  await cd.approve(process.env.OP2P!, merchantStakeAmount);

  await shadow.createOffer(
    token,
    currency,
    paymentMethod,
    rate,
    minOrder,
    maxOrder,
    accountHash,
    depositAddress,
    offerType
  );

  console.log("Created offer ...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
