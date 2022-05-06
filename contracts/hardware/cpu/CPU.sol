// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract CPU is ERC721, Ownable {
    AggregatorV3Interface internal priceFeed;
    uint256 public basePrice_;

	constructor(string memory _brand, string memory _series, string memory _name, uint256 _basePrice, address _priceFeed) ERC721(string(abi.encodePacked(_brand, _series, _name)), "gridCPU") {
		priceFeed = AggregatorV3Interface(_priceFeed);
		basePrice_ = _basePrice;
	}

    function getBasePrice() public view returns (uint256) {
        return basePrice_;
    }

	// changeBasePrice should only be executed once a governance vote has passed
    function changeBasePrice(uint256 _basePrice) public onlyOwner {
		basePrice_ = _basePrice;
	}
}
