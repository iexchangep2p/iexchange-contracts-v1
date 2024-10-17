import { ethers } from "hardhat";

async function main() {
  const shadow = await ethers.getContractAt("OptimisticP2P", process.env.OP2P!);

  const cedi = "GHS";
  const naira = "NGN";
  const shill = "KES";

  const momo = "Mobile Money";
  const fidelity = "Fidelity Bank";
  const mp = "M-Pesa";
  const mtn = "MTN Mobile Money";
  const telecel = "Telecel Mobile Money";
  const airtelTigo = "Airtel Tigo Mobile Money";

  // IXUSDC
  // IXUSDT
  // CEDIH
  // RAMP
  // TRK

  const token = process.env.IXUSDC!;
  const currency = shill;
  const paymentMethod = mp;
  const rate = 2200;
  const minOrder = BigInt(1e3) * BigInt(1e18);
  const maxOrder = BigInt(1e8) * BigInt(1e18);
  const accountHash = ethers.keccak256(ethers.encodeBytes32String("nkbkd1234"));
  const depositAddress = "0xe0f529c753a22b77f8292f3695287787fA27BEBf";
  const offerType = 0;

  const tx = await shadow.createOffer(
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

  console.log("Created offer ...", tx.hash);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
