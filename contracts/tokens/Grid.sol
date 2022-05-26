// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20CappedUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../account/Administrator.sol";

/// @title GRID is the main token/currency contract for CryptoGrid game.
/// @notice GRID will facilitate player based transactions like selling their GPUs/CPUs./ASICs and land on the marketplace. It'll also be used to buy/rent land from the game where the tokens will be burned to ensure it will be sustainable.
/// @dev 750 million hard cap for the GRID token / 25 million tokens minted on contract deployment
contract Grid is Initializable, ERC20CappedUpgradeable {
	uint256 public constant MAXIMUM_SUPPLY = 750 * 1e24;
	uint256 public constant INITIAL_SUPPLY = 25 * 1e24;
	uint256 public constant INITIAL_TREASURY = 25 * 1e23;

	// token holders / spenders
	// address public marketing; // initial 10% allocation to marketing to gather new players to the game (5 year based schedule)

	// address public liquidityPool; // initial supply 30% allocation to liquidity pool on DEX like sushiswap
	// address public developmentSpender; // initial supply 25% approval to developer multi-sig wallet to fund development of the game
	// address public incentivesSpender; // initial supply 25% approval for incentives for players to stake their tokens into sushiswap farm and ensure stability of price

	/// @notice GRID contract startup
	/// @dev Name: CryptoGrid,  Symbol: GRID, Decimals: 18
	function initialize(address _admin2, address _admin3) external initializer {
		__ERC20_init("CryptoGrid", "GRID");
		__ERC20Capped_init_unchained(MAXIMUM_SUPPLY);

    // initial minting for developer multi-sig wallet
	_mint(msg.sender, INITIAL_SUPPLY);
	}
}
