// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract PrivateVotingConsumer {
    // @dev The PrivateVoting contract address
    address private immutable _privateVoting;

    // @dev The caller is not PrivateVoting contract
    error OnlyPrivateVotingCanFulfill(address have, address want);

    // @dev Initializes the contract setting the address of PrivateVoting contract
    constructor(address privateVoting) {
        _privateVoting = privateVoting;
    }

    // @dev Throws if called by any account other than the PrivateVoting contract
    modifier onlyPrivateVoting() {
        if (_privateVoting != msg.sender) {
            revert OnlyPrivateVotingCanFulfill(msg.sender, _privateVoting);
        }
        _;
    }

    // @dev is called by PrivateVoting when it receives a response for the create ballot request
    function fulfillCreateBallot(
        uint256 requestId,
        bytes32 ballotId,
        bytes memory publicKey,
        uint256 errorCode
    ) external onlyPrivateVoting {
        _fulfillCreateBallot(requestId, ballotId, publicKey, errorCode);
    }

    // @dev handles the PrivateVoting response for the create ballot request
    function _fulfillCreateBallot(
        uint256 requestId,
        bytes32 ballotId,
        bytes memory publicKey,
        uint256 errorCode
    ) internal virtual;

    // @dev is called by PrivateVoting when it receives a response for the vote request
    function fulfillVote(
        uint256 requestId,
        bytes32 ballotId,
        uint256 errorCode
    ) external onlyPrivateVoting {
        _fulfillVote(requestId, ballotId, errorCode);
    }

    // @dev handles the PrivateVoting response for the vote request
    function _fulfillVote(
        uint256 requestId,
        bytes32 ballotId,
        uint256 errorCode
    ) internal virtual;

    // @dev is called by PrivateVoting when it receives a response for the finalize ballot request
    function fulfillFinalizeBallot(
        uint256 requestId,
        bytes32 ballotId,
        string memory result,
        uint256 errorCode
    ) external onlyPrivateVoting {
        _fulfillFinalizeBallot(requestId, ballotId, result, errorCode);
    }

    // @dev handles the PrivateVoting response for the finalize ballot request
    function _fulfillFinalizeBallot(
        uint256 requestId,
        bytes32 ballotId,
        string memory result,
        uint256 errorCode
    ) internal virtual;
}
