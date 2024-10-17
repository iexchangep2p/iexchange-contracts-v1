import { ethers } from "hardhat";

async function main() {
  const shadow = await ethers.getContractAt(
    "OptimisticP2P",
    process.env.OP2P!
  );

  const cedi = "GHS";
  const naira = "NGN";
  const shill = "KES";

  const momo = "Mobile Money";
  const fidelity = "Fidelity Bank";
  const mtn = "MTN Mobile Money";
  const telecel = "Telecel Mobile Money";
  const airtelTigo = "Airtel Tigo Mobile Money";
  const mp = "M-Pesa";

  // await shadow.addCurrency(cedi);
  // await shadow.addCurrency(naira);
  // await shadow.addCurrency(shill);
  
  // await shadow.addPaymentMethod(momo);
  // await shadow.addPaymentMethod(mp);
  // await shadow.addPaymentMethod(mtn);
  // await shadow.addPaymentMethod(fidelity);
  // await shadow.addPaymentMethod(telecel);
  // await shadow.addPaymentMethod(airtelTigo);

  console.log("Currencies and Payments Added ...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
