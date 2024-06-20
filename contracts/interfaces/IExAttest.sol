// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IExAttest {
    struct Attestation {
        bytes32 uid;
        bytes32 schema;
        bytes32 uHash;
        address recipient;
        bytes32 publicFieldsHash;
    }
    function getiExAttestation(
        address recipient
    ) external view returns (Attestation memory);
}
