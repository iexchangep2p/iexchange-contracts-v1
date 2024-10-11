// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract IXUSDT is ERC20 {
    constructor() ERC20("IX USDT", "USDT") {
        _mint(msg.sender, 100_000_000 * 1e18);
    }
}