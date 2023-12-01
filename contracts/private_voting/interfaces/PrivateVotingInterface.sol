// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface PrivateVotingInterface {

    /**
     * @notice Request a new ballot creation.
     */
    function requestCreateBallot(
        uint256 minimumVoters
    ) external returns (uint256 requestId);

    /**
     * @notice Request a vote.
     */
    function requestVote(
        bytes32 ballotId,
        bytes memory encryptedVote
    ) external returns (uint256 requestId);

    /**
     * @notice Request a ballot finalization.
     */
    function requestFinalizeBallot(
        bytes32 ballotId
    ) external returns (uint256 requestId);
}
