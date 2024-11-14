// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

//Uncomment this line to use console.log
// import "hardhat/console.sol";

import "../interfaces/IAMLBlacklist.sol";
import "./OffchainAgent.sol";

contract AMLBlacklist is IAMLBlacklist, OffchainAgent {
    struct Blacklist {
        bool _black;
        uint256 _addedAt;
    }

    mapping(address => Blacklist) public blacklist;
    uint256 public minRemovePeriod = 24 hours; // when address is added to a blacklist it can't be removed until after this period
    constructor() Ownable(msg.sender) {}

    function addBlacklist(address _address) external onlyAgent {
        blacklist[_address] = Blacklist(true, block.timestamp);
        emit BlacklistAdded(_address, msg.sender);
    }

    function removeBlacklist(address _address) external onlyAgent {
        delete blacklist[_address];
        emit BlacklistRemoved(_address, msg.sender);
    }

    function isBlacklisted(address _address) external view returns (bool) {
        return blacklist[_address]._black;
    }
}
