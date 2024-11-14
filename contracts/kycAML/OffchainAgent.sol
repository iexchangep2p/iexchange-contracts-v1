// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

//Uncomment this line to use console.log
// import "hardhat/console.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "../utils/helpers.sol";

abstract contract OffchainAgent is Ownable, Helpers {
    mapping(address => bool) public agent;

    error AgentOnly();

    event AgentAdded(address indexed _agent);
    event AgentRemoved(address indexed _agent);

    modifier onlyAgent() {
        if (!agent[msg.sender]) {
            revert AgentOnly();
        }
        _;
    }

    function addAgent(address _agent) external onlyOwner {
        agent[_agent] = true;
        emit AgentAdded(_agent);
    }

    function removeAgent(address _agent) external onlyOwner {
        delete agent[_agent];
        emit AgentRemoved(_agent);
    }
}
