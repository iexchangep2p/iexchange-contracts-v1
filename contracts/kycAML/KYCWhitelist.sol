// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

//Uncomment this line to use console.log
// import "hardhat/console.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IKYCWhitelist.sol";
import "../interfaces/IExAttest.sol";
import "./OffchainAgent.sol";

contract KYCWhitelist is IKYCWhitelist, OffchainAgent {
    IExAttest public zkKyc;
    mapping(address => KYCLevel) public addressKYCLevel;
    constructor(IExAttest _zkKyc) Ownable(msg.sender) {
        zkKyc = _zkKyc;
    }

    function upgradeKYCLevel(
        address _address,
        KYCLevel _level
    ) external onlyAgent {
        if (_level <= addressKYCLevel[_address]) {
            revert InvalidUpgrade();
        }
        addressKYCLevel[_address] = _level;
        emit KYCLevelUpgraded(_address, msg.sender, _level);
    }

    function downgradeKYCLevel(
        address _address,
        KYCLevel _level
    ) external onlyAgent {
        if (_level >= addressKYCLevel[_address]) {
            revert InvalidDowngrade();
        }
        addressKYCLevel[_address] = _level;
        emit KYCLevelDowngraded(_address, msg.sender, _level);
    }

    function getKYCLevel(address _address) external view returns (KYCLevel level) {
        level = KYCLevel.level4;
        // level =  addressKYCLevel[_address];
        // if (level < KYCLevel.level2) {
        //     IExAttest.Attestation memory attestation = zkKyc.getiExAttestation(_address);
        //     if (attestation.uid != 0) {
        //         level = KYCLevel.level2;
        //     }
        // }
    }
}
