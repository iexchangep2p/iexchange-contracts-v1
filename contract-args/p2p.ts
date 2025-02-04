import "dotenv/config";

const ONE_HOUR = 60 * 60;
const ONE_MINUTE = 60;

const daoAddress = process.env.DA0_ADDRESS!;
const kycAddress = process.env.KYC!;
const amlAddress = process.env.AML!;
const stakeToken = process.env.IXUSDC!;
const merchantStakeAmount = BigInt(1500 * 1e18);
const settlerStakeAmount = BigInt(1500 * 1e18);
const settlerMinTime = ONE_MINUTE * 15;
const settlerMaxTime = ONE_HOUR;
const daoMinTime = ONE_HOUR;
const concurrentSettlerSettlements = 1000000;
const concurrentMerchantSettlements = 1000000;
const appealAfter = ONE_MINUTE * 30;
const maxAppealRounds = 4;

export default [
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
  maxAppealRounds,
];
