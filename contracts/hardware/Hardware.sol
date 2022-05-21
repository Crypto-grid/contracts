// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "base64-sol/base64.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../interfaces/IBERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Hardware is ERC721, Ownable {
	using Counters for Counters.Counter;

	// This will count NFT tokens as an unique index
	Counters.Counter private _tokenIds;

	// This pricefeed will be for the ETH/USD so there is some variation in the price
	AggregatorV3Interface internal priceFeed;
	uint256 public idCount = 0;
	uint256 public basePrice;
	address public upgradeToken;
	uint256 mintStatus;

	enum RarityLevel {
		Common, // 0
		Uncommon, // 1
		Rare, // 2
		Epic, // 3
		Legendary // 4
	}

	struct hardwareStruct {
		string brand;
		string series;
		string CPUname;
	}

	// Assign rarity to the given NFT index
	mapping(uint256 => RarityLevel) public tokenIndexRarity;

	// Rarity to image svg mapping
	// mapping(uint8(Rarity) => string) public rarityToSVG;

	constructor(
		hardwareStruct memory _hw,
		uint256 _basePrice,
		address _priceFeed,
		address _upgradeToken
	)
		// string _imageLegendaryURI etc...
		ERC721(string(abi.encodePacked(_hw.brand, " ", _hw.series, " ", _hw.CPUname)), "GridHardware")
	{
		require(address(_priceFeed) != address(0) && address(_upgradeToken) != address(0), "Addresses cannot be 0");
		priceFeed = AggregatorV3Interface(_priceFeed);
		basePrice = _basePrice;
		upgradeToken = _upgradeToken;
		// use the commented code below on minting stage
		// string memory _imageURI
		// hardwareRarity[uint8(Rarity.Common)] = Rarity.Common;
	}

	// Get NFT base price currenty defined
	function getBasePrice() public view returns (uint256) {
		return basePrice;
	}

	// changeBasePrice should only be executed once a governance vote has passed
	function changeBasePrice(uint256 _basePrice) public onlyOwner {
		basePrice = _basePrice;
	}

	function mint() public {
		IBERC20 _upgrade = IBERC20(upgradeToken);

		// get random number from 0 to 4 to pick up the rerity on minting time
		RarityLevel rarity = fechRarity();
		uint8 rarityValue = uint8(rarity);

		// define the price plus rarity level
		uint256 price = getMintPrice() * (rarityValue + 1); // Level will from 1 to 5 times the price
		require(_upgrade.transfer(address(this), price), "Insufficient allowance");
		_upgrade.burn(price);

		// increment NFT index on minting
		_tokenIds.increment();
		uint256 newItemId = _tokenIds.current();

		// assign token rarity + mint
		tokenIndexRarity[newItemId] = rarity;
		_safeMint(msg.sender, newItemId);

		// TODO :: get base64 token URI (SVG) and save it to the NFT
		//_setTokenURI(newItemId, tokenURI);
	}

	function getMintPrice() public view returns (uint256) {
		// kinda dumb the interface doesn't have getLastestAnswer()
		(, int256 price, , , ) = priceFeed.latestRoundData();
		uint256 uPrice = uint256(price) * 1e18;
		// pegged to ETH/USD
		return ((1000 * 1e18) * basePrice) / uPrice;
	}

	function fechRarity() internal pure returns (RarityLevel) {
		// TODO :: Implement logic for randomness with chainlink VRF v2 or something
		// return random number from 0 to 4 related to the rarity level
		return RarityLevel.Common;
	}

	function _baseURI() internal pure override returns (string memory) {
		return "data:application/json;base64,";
	}

	function tokenURI(uint256 tokenId) public view override returns (string memory uri) {
		// TODO :: build specific URIs based on rarity
		RarityLevel _rarity = tokenIndexRarity[tokenId];
		if (_rarity == RarityLevel.Common) {
			return
				string(
					abi.encodePacked(
						_baseURI(),
						Base64.encode(
							bytes(
								abi.encodePacked(
									'{"name":',
									name(), // You can add whatever name here
									'", "description": "A CPU based hardware for the game cryptogrid",',
									'"attributes": ["rarity": ',
									_rarity,
									']"image":"',
									tokenIndexRarity[uint256(_rarity)],
									"}"
								)
							)
						)
					)
				);
		}
	}

	function svgToImageURI(string memory svg) public pure returns (string memory) {
		string memory baseURL = "data:image/svg+xml;base64,";
		string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
		return string(abi.encodePacked(baseURL, svgBase64Encoded));
	}
}
