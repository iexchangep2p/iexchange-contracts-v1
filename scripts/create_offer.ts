import { ethers } from "hardhat";
import combos from "./combinations.json";
const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));
type OfferConfig = { payment_method: string; token: string; currency: string };
async function main() {
  const shadow = await ethers.getContractAt("OptimisticP2P", process.env.OP2P!);

  const cedi = "GHS";
  const naira = "NGN";
  const shill = "KES";
  const usd = "USD";
  const euro = "EUR";

  const momo = "Mobile Money";
  const fidelity = "Fidelity Bank";
  const mtn = "MTN Mobile Money";
  const telecel = "Telecel Mobile Money";
  const airtelTigo = "Airtel Tigo Mobile Money";
  const mp = "M-Pesa";
  const rev = "Revolut";
  const bank = "Bank Transfer";
  const ze = "Zelle";
  const pm = "PerfectMoney";

  // IXUSDC
  // IXUSDT
  // CEDIH
  // RAMP
  // TRK

  const tokens: Record<string, string> = {
    USDC: process.env.IXUSDC!,
    USDT: process.env.IXUSDT!,
    CEDIH: process.env.CEDIH!,
    RMP: process.env.RAMP!,
    TRK: process.env.TRK!,
  };

  const rates: Record<string, number> = {
    GHS: 12,
    USD: 1,
    EUR: 2,
    NGN: 2100,
    KES: 49,
  };

  for (const c of combos) {
    try {
      const offerConfig = c as OfferConfig;
      const token = tokens[offerConfig.token];
      const currency = offerConfig.currency;
      const paymentMethod = offerConfig.payment_method;
      const rate = rates[offerConfig.currency];
      const minOrder = BigInt(10) * BigInt(1e18);
      const maxOrder = BigInt(1e8) * BigInt(1e18);
      const accountHash = ethers.keccak256(
        ethers.encodeBytes32String("bot1234")
      );
      const depositAddress = "0xe0f529c753a22b77f8292f3695287787fA27BEBf";
      const buyType = 0;

      const buyTx = await shadow.createOffer(
        token,
        currency,
        paymentMethod,
        rate,
        minOrder,
        maxOrder,
        accountHash,
        depositAddress,
        buyType
      );
      console.log("Created buy offer ...", buyTx.hash);
      await delay(2000);
      const sellType = 1;
      const sellTx = await shadow.createOffer(
        token,
        currency,
        paymentMethod,
        rate,
        minOrder,
        maxOrder,
        accountHash,
        depositAddress,
        sellType
      );
      console.log("Created sell offer ...", sellTx.hash);
      await delay(2000);
    } catch (error) {
      console.log(error);

      console.log("Error on: ", c);
    }
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
