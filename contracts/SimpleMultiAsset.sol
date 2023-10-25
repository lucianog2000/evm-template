// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.21;
import "@rmrk-team/evm-contracts/contracts/implementations/premint/RMRKMultiAssetPreMint.sol";

contract SimpleMultiAsset is RMRKMultiAssetPreMint {
    /// Mapping of string VIN to tokenId
    mapping(string => uint256) private vinToTokenId;
    mapping(string => bool) private isVinUsed;
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

    function createAutoken(
        address to,
        uint256 numToMint,
        string memory tokenURI,
        string memory vin
    ) public virtual returns (uint256) {
        (uint256 nextToken, uint256 totalSupplyOffset) = _prepareMint(
            numToMint
        );
        require(isVinUsed[vin] == false, "Car with this VIN already exists");
        for (uint256 i = nextToken; i < totalSupplyOffset; ) {
            _setTokenURI(i, tokenURI);
            vinToTokenId[vin] = i;
            _safeMint(to, i, "");
            unchecked {
                ++i;
            }
            isVinUsed[vin] = true;
        }

        return nextToken;
    }
    
    function getTokenIdByVin(string memory vin) public view returns (uint256) {
        return vinToTokenId[vin];
    }

    function getTokenURIByVIN(string memory vin) public view returns (string memory) {
        uint256 tokenId = getTokenIdByVin(vin);
        return tokenURI(tokenId);
    }

    function getAssetMetadataWithVIN(
        string memory vin,
        uint64 assetId
    ) public view virtual returns (string memory) {
        uint256 tokenId = getTokenIdByVin(vin);
        return getAssetMetadata(tokenId, assetId);
    }

    function getActiveAssetsIdsWithVIN(
        string memory vin
    ) public view virtual returns (uint64[] memory) {
        uint256 tokenId = getTokenIdByVin(vin);
        return getActiveAssets(tokenId);
    }

    function getAllAssetsMetadata(
        string memory vin
    ) public view virtual returns (string[] memory) {
        uint256 tokenId = getTokenIdByVin(vin);
        uint64[] memory activeAssets = getActiveAssets(tokenId);
        string[] memory assetsMetadata = new string[](activeAssets.length);
        for (uint i = 0; i < activeAssets.length; i++) {
            string memory assetMetadata = getAssetMetadata(tokenId, activeAssets[i]);
            assetsMetadata[i] = assetMetadata;
        }
        return assetsMetadata;
    }
}
