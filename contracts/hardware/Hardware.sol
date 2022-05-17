// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "base64-sol/base64.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../interfaces/IBERC20.sol";

contract Hardware is ERC721, Ownable {
	// This pricefeed will be for the ETH/USD so there is some variation in the price
	AggregatorV3Interface internal priceFeed;
	uint256 public idCount = 0;
	uint256 public basePrice;
	address public upgradeToken;
	uint256 mintStatus;

	enum Rarity {
		Common,
		Uncommon,
		Rare,
		Epic,
		Legendary
	}

	// Rarity of the CPU assigned to the token id of the cpu.
	// This is determinded at the time of minting of the token.
	mapping(uint256 => Rarity) public tokenIDRarityMapping;
	// Rarity to image svg mapping.
	mapping(Rarity => string) public rarityToImageMapping;

	constructor(
		string memory _brand,
		string memory _series,
		string memory _CPUname,
		uint256 _basePrice,
		address _upgradeToken,
		address _priceFeed,
		string memory _imageURI
	)
		// string _imageLegendaryURI etc...
		ERC721(string(abi.encodePacked(_brand, " ", _series, " ", _CPUname)), "gridCPU")
	{
		require(address(_priceFeed) != address(0) && address(_upgradeToken) != address(0), "Addresses cannot be 0");
		priceFeed = AggregatorV3Interface(_priceFeed);
		basePrice = _basePrice;
		upgradeToken = _upgradeToken;
		rarityToImageMapping[Rarity.Common] = _imageURI;
	}

	function getBasePrice() public view returns (uint256) {
		return basePrice;
	}

	// changeBasePrice should only be executed once a governance vote has passed
	function changeBasePrice(uint256 _basePrice) public onlyOwner {
		basePrice = _basePrice;
	}

	function mint() public {
		IBERC20 _upgrade = IBERC20(upgradeToken);
		uint256 price = getMintPrice();
		idCount++;
		require(_upgrade.transfer(address(this), price), "Insufficient allowance");
		_upgrade.burn(price);
		tokenIDRarityMapping[idCount] = Rarity.Common;

		// TODO: Implement logic for randomness with chainlink VRF v2 or something
		_safeMint(msg.sender, idCount);
	}

	function getMintPrice() public view returns (uint256) {
		// kinda dumb the interface doesn't have getLastestAnswer()
		(, int256 price, , , ) = priceFeed.latestRoundData();
		uint256 uPrice = uint256(price) * 1e18;
		// pegged to ETH/USD
		return ((1000 * 1e18) * basePrice) / uPrice;
	}

	function _baseURI() internal pure override returns (string memory) {
		return "data:application/json;base64,";
	}

	function tokenURI(uint256 tokenId) public view override returns (string memory) {
		Rarity _rarity = tokenIDRarityMapping[tokenId];
		if (_rarity == Rarity.Common) {
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
									rarityToImageMapping[_rarity],
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
