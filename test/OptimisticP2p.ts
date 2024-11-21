import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { deployZk } from "./zk";

export async function deployP2P() {
  const [owner, merchant, trader1, trader2, amlAgent, kycAgent, settler] =
    await ethers.getSigners();

  const Ramp = await ethers.getContractFactory("Ramp");

  const ramp = await Ramp.deploy();

  const one_million = BigInt(1e6 * 1e18);

  await ramp.transfer(await merchant.getAddress(), one_million);
  await ramp.transfer(await trader1.getAddress(), one_million);
  await ramp.transfer(await trader2.getAddress(), one_million);
  await ramp.transfer(await settler.getAddress(), one_million);

  const Cedih = await ethers.getContractFactory("Cedih");

  const cedih = await Cedih.deploy();

  await cedih.transfer(await merchant.getAddress(), one_million);
  await cedih.transfer(await trader1.getAddress(), one_million);
  await cedih.transfer(await trader2.getAddress(), one_million);
  await cedih.transfer(await settler.getAddress(), one_million);

  const Troken = await ethers.getContractFactory("Cedih");

  const troken = await Troken.deploy();

  await troken.transfer(await merchant.getAddress(), one_million);
  await troken.transfer(await trader1.getAddress(), one_million);
  await troken.transfer(await trader2.getAddress(), one_million);
  await troken.transfer(await settler.getAddress(), one_million);

  const AML = await ethers.getContractFactory("AMLBlacklist");

  const aml = await AML.deploy();

  await aml.addAgent(await amlAgent.getAddress());

  const { iex, proof } = await loadFixture(deployZk);

  const KYC = await ethers.getContractFactory("KYCWhitelist");

  const kyc = await KYC.deploy(await iex.getAddress());

  await kyc.addAgent(await kycAgent.getAddress());

  await kyc.connect(kycAgent).upgradeKYCLevel(await merchant.getAddress(), 4);

  await kyc.connect(kycAgent).upgradeKYCLevel(await settler.getAddress(), 4);

  await kyc.connect(kycAgent).upgradeKYCLevel(await trader1.getAddress(), 3);

  await kyc.connect(kycAgent).upgradeKYCLevel(await trader2.getAddress(), 3);

  const OptimisticP2P = await ethers.getContractFactory("OptimisticP2P");
  const ONE_HOUR = 60 * 60;
  const ONE_MINUTE = 60;

  const daoAddress = await owner.getAddress();
  const kycAddress = await kyc.getAddress();
  const amlAddress = await aml.getAddress();
  const stakeToken = await cedih.getAddress();
  const merchantStakeAmount = BigInt(1500 * 1e18);
  const settlerStakeAmount = BigInt(1500 * 1e18);
  const settlerMinTime = ONE_MINUTE * 15;
  const settlerMaxTime = ONE_HOUR;
  const daoMinTime = ONE_HOUR;
  const concurrentSettlerSettlements = 3;
  const concurrentMerchantSettlements = 3;
  const appealAfter = ONE_MINUTE * 30;
  const maxAppealRounds = 4;

  const p2p = await OptimisticP2P.deploy(
    daoAddress,
    kycAddress,
    amlAddress,
    stakeToken,
    merchantStakeAmount,
    settlerStakeAmount,
    settlerMinTime,
    settlerMaxTime,
    daoMinTime,
    concurrentSettlerSettlements,
    concurrentMerchantSettlements,
    appealAfter,
    maxAppealRounds
  );

  const cedi = "GHS";
  const naira = "NGN";

  const momo = "Mobile Money";
  const fidelity = "Fidelity Bank";
  const mtn = "MTN Mobile Money";
  const telecel = "Telecel Mobile Money";
  const airtelTigo = "Airtel Tigo Mobile Money";

  await p2p.addCurrency(cedi);
  await p2p.addCurrency(naira);

  await p2p.addPaymentMethod(momo);
  await p2p.addPaymentMethod(mtn);
  await p2p.addPaymentMethod(fidelity);
  await p2p.addPaymentMethod(telecel);
  await p2p.addPaymentMethod(airtelTigo);

  await p2p.addToken(await cedih.getAddress());
  await p2p.addToken(await ramp.getAddress());
  await p2p.addToken(await troken.getAddress());

  await cedih
    .connect(merchant)
    .approve(await p2p.getAddress(), merchantStakeAmount);

  await p2p.connect(merchant).registerMerchant();

  await cedih
    .connect(settler)
    .approve(await p2p.getAddress(), settlerStakeAmount);

  await p2p.connect(settler).registerSettler();

  await p2p.connect(trader1).registerTrader();

  await p2p.connect(trader2).registerTrader();

  return {
    owner,
    merchant,
    trader1,
    trader2,
    amlAgent,
    kycAgent,
    settler,
    ramp,
    troken,
    cedih,
    p2p,
  };
}

describe("Optimistic P2P", function () {
  describe("Deployment", function () {
    it("Should Deploy and test P2p", async function () {
      const {
        owner,
        merchant,
        trader1,
        trader2,
        amlAgent,
        kycAgent,
        settler,
        ramp,
        troken,
        cedih,
        p2p,
      } = await loadFixture(deployP2P);
      const cedi = "GHS";
      const naira = "NGN";

      const momo = "Mobile Money";
      const fidelity = "Fidelity Bank";
      const mtn = "MTN Mobile Money";
      const telecel = "Telecel Mobile Money";
      const airtelTigo = "Airtel Tigo Mobile Money";
      const token = await cedih.getAddress();
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
      const tokenS = await ramp.getAddress();
      const currencyS = cedi;
      const paymentMethodS = fidelity;
      const rateS = 15;
      const offerTypeS = 1;

      await p2p
        .connect(merchant)
        .createOffer(
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

      await p2p
        .connect(merchant)
        .createOffer(
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

      const sellOfferId = 0;
      const sellQuantity = BigInt(1e5 * 1e18);
      const sellDepositAddress = await trader1.getAddress();

      await ramp.connect(trader1).approve(await p2p.getAddress(), sellQuantity);

      await expect(
        p2p
          .connect(trader1)
          .createOrder(
            sellOfferId,
            sellQuantity,
            sellDepositAddress,
            accountHash
          )
      ).emit(p2p, "NewOrder");

      await expect(p2p.connect(merchant).payOrder(0)).emit(p2p, "OrderPaid");
      await expect(p2p.connect(trader1).releaseOrder(0)).emit(
        p2p,
        "OrderReleased"
      );

      const buyOfferId = 1;
      const buyQuantity = BigInt(1e5 * 1e18);
      const buyDepositAddress = await trader2.getAddress();

      await expect(
        p2p
          .connect(trader2)
          .createOrder(buyOfferId, buyQuantity, buyDepositAddress, accountHash)
      ).emit(p2p, "NewOrder");

      await cedih
        .connect(merchant)
        .approve(await p2p.getAddress(), buyQuantity);

      await expect(p2p.connect(merchant).acceptOrder(1)).emit(
        p2p,
        "OrderAccepted"
      );

      await expect(p2p.connect(trader2).payOrder(1)).emit(p2p, "OrderPaid");

      await expect(p2p.connect(merchant).releaseOrder(1)).emit(
        p2p,
        "OrderReleased"
      );
    });
  });
});
