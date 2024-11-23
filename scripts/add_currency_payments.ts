import { ethers } from "hardhat";

async function main() {
  const shadow = await ethers.getContractAt(
    "OptimisticP2P",
    process.env.OP2P!
  );

  const cedi = "GHS";
  const naira = "NGN";
  const shill = "KES";
  const usd = "USD";
  const euro = "EUR";

  const momo = "Mobile Money";
  const fidelity = "Fidelity Bank";
  const mtn = "MTN Mobile Money";
  // const mtn2 = "MTN Mobile Money";
  const telecel = "Telecel Mobile Money";
  const airtelTigo = "Airtel Tigo Mobile Money";
  const mp = "M-Pesa";
  const rev = "Revolut";
  const bank = "Bank Transfer";
  const ze = "Zelle";
  const pm = "PerfectMoney"

  await shadow.addCurrency(cedi);
  await shadow.addCurrency(naira);
  await shadow.addCurrency(shill);
  await shadow.addCurrency(usd);
  await shadow.addCurrency(euro);
  
  await shadow.addPaymentMethod(momo);
  await shadow.addPaymentMethod(fidelity);
  await shadow.addPaymentMethod(mtn);
  await shadow.addPaymentMethod(telecel);
  await shadow.addPaymentMethod(airtelTigo);
  await shadow.addPaymentMethod(mp);
  await shadow.addPaymentMethod(rev);
  await shadow.addPaymentMethod(bank);
  await shadow.addPaymentMethod(ze);
  await shadow.addPaymentMethod(pm);

  console.log("Currencies and Payments Added ...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
