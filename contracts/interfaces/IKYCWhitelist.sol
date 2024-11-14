// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

//Uncomment this line to use console.log
// import "hardhat/console.sol";

interface IKYCWhitelist {
    enum KYCLevel {
        level0,
        level1,
        level2,
        level3,
        level4
    }

    event KYCLevelUpgraded(address _address, address _agent, KYCLevel _level);
    event KYCLevelDowngraded(address _address, address _agent, KYCLevel _level);

    error InvalidUpgrade();
    error InvalidDowngrade();

    function upgradeKYCLevel(address _address, KYCLevel _level) external;

    function downgradeKYCLevel(address _address, KYCLevel _level) external;

    function getKYCLevel(address _address) external view returns (KYCLevel);
}
