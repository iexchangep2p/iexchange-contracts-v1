// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Proof} from "./Common.sol";
import {ProofVerifier} from "./ProofVerifier.sol";

struct Attestation {
    bytes32 uid;
    bytes32 schema;
    bytes32 uHash;
    address recipient;
    bytes32 publicFieldsHash;
}

contract iExAttestation is ProofVerifier, Ownable {
    mapping(bytes32 uid => Attestation) private attestations;
    mapping(address recipient => bytes32 uid) private iexAttestation;
    mapping(bytes32 schemaId => bool) private iexSchemas;
    constructor(
        bytes32[] memory _acceptedSchemas
    ) ProofVerifier() Ownable(msg.sender) {
        require(_acceptedSchemas.length < 5, "Too many initial schemes.");
        for (uint i = 0; i < _acceptedSchemas.length; i++) {
            iexSchemas[_acceptedSchemas[i]] = true;
        }
    }

    function addSchema(bytes32 _schema) external onlyOwner {
        iexSchemas[_schema] = true;
    }

    function removeSchema(bytes32 _schema) external onlyOwner {
        delete iexSchemas[_schema];
    }

    function attest(Proof calldata _proof) public {
        require(verify(_proof), "verify proof fail!");

        Attestation memory attestation = Attestation({
            uid: 0,
            schema: _proof.schemaId,
            uHash: _proof.uHash,
            recipient: _proof.recipient,
            publicFieldsHash: _proof.publicFieldsHash
        });

        bytes32 uid;
        uint32 bump = 0;
        while (true) {
            uid = getUID(attestation, bump);
            if (attestations[uid].uid == 0) {
                break;
            }

            unchecked {
                ++bump;
            }
        }

        attestation.uid = uid;

        attestations[uid] = attestation;
        if (iexSchemas[_proof.schemaId]) {
            iexAttestation[_proof.recipient] = uid;
        }
    }

    function getAttestation(
        bytes32 uid
    ) public view returns (Attestation memory) {
        return attestations[uid];
    }

    function getiExAttestation(
        address recipient
    ) public view returns (Attestation memory) {
        return getAttestation(iexAttestation[recipient]);
    }

    function getUID(
        Attestation memory attestation,
        uint32 bump
    ) private pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    attestation.schema,
                    attestation.uHash,
                    attestation.recipient,
                    attestation.publicFieldsHash,
                    bump
                )
            );
    }
}
