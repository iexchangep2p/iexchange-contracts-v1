import "dotenv/config";

const usdt = process.env.IXUSDT!;
const usdc = process.env.IXUSDC!;

export default [[usdt, usdc]];