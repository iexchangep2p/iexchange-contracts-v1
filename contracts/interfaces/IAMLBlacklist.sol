// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

//Uncomment this line to use console.log
// import "hardhat/console.sol";

interface IAMLBlacklist {

    error MinBlackListPeriodNotEnded(uint256 _timeToEnd);

    event BlacklistAdded(address _address, address _agent);
    event BlacklistRemoved(address _address, address _agent);

    function addBlacklist(address _address) external;

    function removeBlacklist(address _address) external;

    function isBlacklisted(address _address) external view returns (bool);
}
