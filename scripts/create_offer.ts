import { ethers } from "hardhat";

async function main() {
  const shadow = await ethers.getContractAt("OptimisticP2P", process.env.OP2P!);

  const cedi = "GHS";
  const naira = "NGN";

  const momo = "Mobile Money";
  const fidelity = "Fidelity Bank";
  const mtn = "MTN Mobile Money";
  const telecel = "Telecel Mobile Money";
  const airtelTigo = "Airtel Tigo Mobile Money";

  //   await shadow.createOffer();
  // buy
  const token = process.env.CEDIH!;
  const currency = cedi;
  const paymentMethod = momo;
  const rate = 14;
  const minOrder = BigInt(1e4 * 1e18);
  const maxOrder = BigInt(1e6 * 1e18);
  const accountHash = ethers.sha256(
    ethers.encodeBytes32String("Seth Baah Kusi0553339728")
  );
  const depositAddress = process.env.DA0_ADDRESS!;
  const offerType = 0;

  // sell
  const tokenS = process.env.CEDIH!;
  const currencyS = cedi;
  const paymentMethodS = momo;
  const rateS = 15;
  const offerTypeS = 1;

  await shadow.createOffer(
    tokenS,
    currencyS,
    paymentMethodS,
    rateS,
    minOrder,
    maxOrder,
    accountHash,
    depositAddress,
    offerTypeS
  );

  // await shadow.createOffer(
  //   token,
  //   currency,
  //   paymentMethod,
  //   rate,
  //   minOrder,
  //   maxOrder,
  //   accountHash,
  //   depositAddress,
  //   offerType
  // );

  console.log("Created two fing offers ...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
