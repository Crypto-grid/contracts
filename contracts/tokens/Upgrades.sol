// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./MineFactory.sol";
import "../interfaces/IBERC20.sol";

contract Upgrades is Initializable, ERC20BurnableUpgradeable, OwnableUpgradeable {
	// map address for token transfer allowance (default is false)
	mapping(address => bool) public isAllowed;

	// store addresses for gridX to upgrade conversion
	address public mineFactory;
	
	// store price feeds
	address internal btcPriceFeed;
	address internal ethPriceFeed;

	function initialize(
		address _btcPriceFeed, 
		address _ethPriceFeed, 
		address _mineFactory
	) external initializer {
		__ERC20_init("Upgrades", "UPGRADES");
		__Ownable_init();
		isAllowed[msg.sender] = true;

		// store all initializers
		btcPriceFeed = _btcPriceFeed;
		ethPriceFeed = _ethPriceFeed;
		mineFactory = _mineFactory;
	}

	// prevent transfer of tokens to prevent users from transfering to themselves
	// and transfering to other players to progress faster.
	function _beforeTokenTransfer(
		address _from,
		address _to,
		uint256 _amount
	) internal virtual override {
		require(isAllowed[msg.sender], "Not in transfer whitelist");
	}

	// Allows UPGRADES token to be sent to our other contacts but not to other players
	function addAllowedAddress(address _address) public onlyOwner {
		isAllowed[_address] = true;
	}

	function exchangeForUpgrades(address _address, uint256 _amount) public {
		IBERC20 token = IBERC20(_address);
		_mint(msg.sender, exchangeRate(_address, _amount));
		require(token.transfer(address(this), _amount), "Transfer failed");
		token.burn(_amount);
	}

	function exchangeRate(address _address, uint256 _amount) public view returns (uint256) {
		MineFactory mf = MineFactory(mineFactory);
		address[] memory tokens = mf.getTokens();
		if (tokens[0] == _address) {
			AggregatorV3Interface btc = AggregatorV3Interface(btcPriceFeed);
			(, int256 price, , , ) = btc.latestRoundData();
			uint256 uPrice = uint256(price) * 10e18;
			return (_amount / uPrice) * 3;
		}else if (tokens[1] == _address) {
			AggregatorV3Interface btc = AggregatorV3Interface(ethPriceFeed);
			(, int256 price, , , ) = btc.latestRoundData();
			uint256 uPrice = uint256(price) * 10e18;
			return (_amount / uPrice) * 3;
		}else if (tokens[2] == _address) {
			AggregatorV3Interface btc = AggregatorV3Interface(ethPriceFeed);
			(, int256 price, , , ) = btc.latestRoundData();
			uint256 uPrice = uint256(price) * 10e18 / 10;
			return (_amount / uPrice) * 2;
		}else {
			revert("Unsuported token");
		}
	}
}
