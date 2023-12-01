// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./PrivateVotingConsumer.sol";
import "./interfaces/PrivateVotingInterface.sol";

contract PrivateVotingClient is PrivateVotingConsumer {

    PrivateVotingInterface private _privateVoting;
    uint256 public lastRequestId;
    bytes32 public lastBallotId;
    bytes32 public lastPublicKeyHash;
    string public lastBallotResult;
    uint256 public lastErrorCode;

    error InvalidRequestId();
    error InvalidBallotId();

    constructor(address privateVoting)
        PrivateVotingConsumer(privateVoting)
    {
        _privateVoting = PrivateVotingInterface(privateVoting);
    }

    function requestCreateBallot(
        uint256 minimumVoters
    ) external returns (uint256) {
        lastRequestId = _privateVoting.requestCreateBallot(minimumVoters);
        return lastRequestId;
    }

    function requestVote(
        bytes32 ballotId,
        bytes memory encryptedVote
    ) external returns (uint256) {
        lastRequestId = _privateVoting.requestVote(ballotId, encryptedVote);
        return lastRequestId;
    }

    function requestFinalizeBallot(
        bytes32 ballotId
    ) external returns (uint256) {
        lastRequestId = _privateVoting.requestFinalizeBallot(ballotId);
        return lastRequestId;
    }

    function _fulfillCreateBallot(
        uint256 requestId,
        bytes32 ballotId,
        bytes memory publicKey,
        uint256 errorCode
    ) internal override {
        if (requestId != lastRequestId) {
            revert InvalidRequestId();
        }
        lastBallotId = ballotId;
        lastPublicKeyHash = keccak256(publicKey);
        lastErrorCode = errorCode;
    }

    function _fulfillVote(
        uint256 requestId,
        bytes32 ballotId,
        uint256 errorCode
    ) internal override {
        if (requestId != lastRequestId) {
            revert InvalidRequestId();
        }
        lastErrorCode = errorCode;
    }

    function _fulfillFinalizeBallot(
        uint256 requestId,
        bytes32 ballotId,
        string memory result,
        uint256 errorCode
    ) internal override {
        if (requestId != lastRequestId) {
            revert InvalidRequestId();
        }
        lastBallotResult = result;
        lastErrorCode = errorCode;
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}
