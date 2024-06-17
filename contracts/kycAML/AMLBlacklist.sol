// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

//Uncomment this line to use console.log
// import "hardhat/console.sol";

import "./OffchainAgent.sol";

contract AMLBlacklist is OffchainAgent {
    struct Blacklist {
        address _address;
        uint256 _addedAt;
    }

    mapping(address => Blacklist) public blacklist;
    uint256 public minRemovePeriod = 24 hours; // when address is added to a blacklist it can't be removed until after this period
    constructor() Ownable(msg.sender) {}

    error MinBlackListPeriodNotEnded(uint256 _timeToEnd);

    event BlacklistAdded(address _address);
    event BlacklistRemoved(address _address);

    function addBlacklist(address _address) external onlyAgent {
        blacklist[_address] = Blacklist(_address, block.timestamp);
        emit BlacklistAdded(_address);
    }

    function removeBlacklist(address _address) external onlyAgent {

        delete blacklist[_address];
        emit BlacklistRemoved(_address);
    }

    function isBlacklisted(address _address) external view returns (bool) {
        return blacklist[_address]._address != address(0);
    }
}
