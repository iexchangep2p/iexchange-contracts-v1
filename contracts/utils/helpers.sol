// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/math/Math.sol";
abstract contract Helpers {
    error EmptyString();
    error ZeroAddress();
    modifier positiveAddress(address addr) {
        if (address(0) == addr) {
            revert ZeroAddress();
        }
        _;
    }

    modifier nonEmptyString(string memory str) {
        if (bytes(str).length == 0) {
            revert EmptyString();
        }
        _;
    }

    // @dev computes fraction of [value] in [bps]
    // 100 bps is equivalent to 1%
    function basisPoint(
        uint256 value,
        uint256 bps
    ) internal pure returns (uint256) {
        require((value * bps) >= 10_000);
        return Math.mulDiv(value, bps, 10_000);
    }

    function compareStrings(
        string memory a,
        string memory b
    ) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }
}
