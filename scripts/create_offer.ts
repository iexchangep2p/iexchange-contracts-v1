import { ethers } from "hardhat";

async function main() {
  const shadow = await ethers.getContractAt("OptimisticP2P", process.env.OP2P!);

  const cedi = "GHS";
  const naira = "NGN";
  const shill = "KES";

  const momo = "Mobile Money";
  const fidelity = "Fidelity Bank";
  const mp = "M-Pesa";

  //   await shadow.createOffer();
  // buy
  const token = process.env.TRK!;
  const currency = shill;
  const paymentMethod = mp;
  const rate = 10;
  const minOrder = BigInt(1e4 * 1e18);
  const maxOrder = BigInt(1e6 * 1e18);
  const accountHash = ethers.keccak256(
    ethers.encodeBytes32String("Seth Baah Kusi0553339728")
  );
  const depositAddress = process.env.DA0_ADDRESS!;
  const offerType = 0;

  // sell
  const tokenS = process.env.TRK!;
  const currencyS = shill;
  const paymentMethodS = mp;
  const rateS = 11;
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

  console.log("Created two fing offers ...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
