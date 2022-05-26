// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "base64-sol/base64.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../interfaces/IBERC20.sol";

contract Hardware is ERC721, Ownable {
	// This pricefeed will be for the ETH/USD so there is some variation in the price
	AggregatorV3Interface internal priceFeed;

	using Counters for Counters.Counter;
	Counters.Counter public idCount;
	uint256 public basePrice;
	uint256 public baseReward;
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
		uint256 _baseReward,
		address _upgradeToken,
		address _priceFeed,
		string[5] memory _rarityToImageMapping
	)
		// string _imageLegendaryURI etc...
		ERC721(string(abi.encodePacked(_brand, " ", _series, " ", _CPUname)), "gridCPU")
	{
		require(address(_priceFeed) != address(0) && address(_upgradeToken) != address(0), "Addresses cannot be 0");
		priceFeed = AggregatorV3Interface(_priceFeed);
		basePrice = _basePrice;
		baseReward = _baseReward;
		upgradeToken = _upgradeToken;

		for (uint256 i = 0; i < 5; i++) {
			rarityToImageMapping[Rarity(i)] = _rarityToImageMapping[i];
		}
	}

	function getBasePrice() public view returns (uint256) {
		return basePrice;
	}

	// changeBasePrice should only be executed once a governance vote has passed
	function changeBaseReward(uint256 _baseReward) public onlyOwner {
		baseReward = _baseReward;
	}

	function getBaseReward() public view returns (uint256) {
		return baseReward;
	}

	// changeBasePrice should only be executed once a governance vote has passed
	function changeBasePrice(uint256 _basePrice) public onlyOwner {
		basePrice = _basePrice;
	}

	function mint(address _address) public {
		IBERC20 _upgrade = IBERC20(upgradeToken);
		uint256 price = getMintPrice();
		idCount.increment();
		require(_upgrade.transfer(address(this), price), "Insufficient allowance");
		_upgrade.burn(price);
		tokenIDRarityMapping[idCount.current()] = Rarity.Common;

		// TODO: Implement logic for randomness with chainlink VRF v2 or something
		_safeMint(_address, idCount.current());
	}

	function getMintPrice() public view returns (uint256) {
		// kinda dumb the interface doesn't have getLastestAnswer()
		(, int256 price, , , ) = priceFeed.latestRoundData();
		uint256 uPrice = uint256(price) * 1e18;
		// pegged to ETH/USD
		return ((1000 * 1e18) * basePrice) / uPrice;
	}

	function _baseURI() internal pure override returns (string memory) {
		return "ipfs://";
	}

	function tokenURI(uint256 tokenId) public view override returns (string memory) {
		return rarityToImageMapping[getRarity(tokenId)];
	}

	function getRarity(uint256 tokenId) public view returns (Rarity) {
		return tokenIDRarityMapping[tokenId];
	}

	function burn(uint256 tokenId) public virtual {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "You are not authorized to send the token");
        _burn(tokenId);
    }
}
