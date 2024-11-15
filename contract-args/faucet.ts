import "dotenv/config";

const cedih = process.env.CEDIH!;
const troken = process.env.TRK!;
const ramp = process.env.RAMP!;
const usdt = process.env.IXUSDT!;
const usdc = process.env.IXUSDC!;

const faucet = [cedih, troken, ramp, usdt, usdc].filter(Boolean)

export default [faucet];
