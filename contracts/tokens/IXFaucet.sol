// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract IXFaucet is Ownable {
    uint256 public dailyClaim = 5000 * 1e18;

    uint256 public claimInterval = 1 days;

    mapping(address => uint256) public lastClaimed;

    address[] public faucetTokens;
    constructor(address[] memory _tokenAddresses) Ownable(msg.sender) {
        faucetTokens = _tokenAddresses;
    }

    error AlreadyClaimed();

    event Claimed(address _cliamer, uint256 _amount);

    function claim() external {
        if ((block.timestamp - lastClaimed[msg.sender]) < claimInterval) {
            revert AlreadyClaimed();
        }
        for (uint i = 0; i < faucetTokens.length; i++) {
            IERC20 token = IERC20(faucetTokens[i]);
            SafeERC20.safeTransfer(token, msg.sender, dailyClaim);
            emit Claimed(msg.sender, dailyClaim);
        }
        lastClaimed[msg.sender] = block.timestamp;
    }

    function setTokens(address[] memory _tokenAddresses) external onlyOwner {
        faucetTokens = _tokenAddresses;
    }

    function drain() external onlyOwner {
        for (uint i = 0; i < faucetTokens.length; i++) {
            IERC20 token = IERC20(faucetTokens[i]);
            SafeERC20.safeTransfer(
                token,
                owner(),
                token.balanceOf(address(this))
            );
        }
    }
}
