// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.21;
import "@rmrk-team/evm-contracts/contracts/implementations/premint/RMRKMultiAssetPreMint.sol";

contract SimpleMultiAsset is RMRKMultiAssetPreMint {
    // Variables

    // Constructor
    constructor(
        string memory collectionMetadata,
        uint256 maxSupply,
        address royaltyRecipient,
        uint16 royaltyPercentageBps
    )
        RMRKMultiAssetPreMint(
            "SimpleMultiAsset",
            "SMA",
            collectionMetadata,
            maxSupply,
            royaltyRecipient,
            royaltyPercentageBps
        )
    {}

    // Methods
}
