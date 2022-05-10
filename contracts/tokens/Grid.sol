// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20CappedUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../treasury/Treasury.sol";

/// @title GRID is the main token/currency contract for CryptoGrid game.
/// @notice GRID will facilitate player based transactions like selling their GPUs/CPUs./ASICs and land on the marketplace. It'll also be used to buy/rent land from the game where the tokens will be burned to ensure it will be sustainable.
/// @dev 750 million hard cap for the GRID token / 25 million tokens minted on contract deployment
contract Grid is Initializable, ERC20CappedUpgradeable{
	uint256 public constant MAXIMUM_SUPPLY = 750000000 * 1e18;
	uint256 public constant INITIAL_SUPPLY = 25000000 * 1e18;

	// token holders / spenders
	address public marketing; // initial 10% allocation to marketing to gather new players to the game (5 year based schedule)

	// initial supply 10% allocation to treasury multi-sig to fund our operation costs and hire staff
	Treasury public treasury;
	// address public treasury;

	address public liquidityPool; // initial supply 30% allocation to liquidity pool on DEX like sushiswap
	address public developmentSpender; // initial supply 25% approval to developer multi-sig wallet to fund development of the game
	address public incentivesSpender; // initial supply 25% approval for incentives for players to stake their tokens into sushiswap farm and ensure stability of price

	// constructor()
	// 	// address _treasuryAddress
	// 	//    address _marketing,
	// 	//    address _liquidityPool,
	// 	//    address _devSpender,
	// 	//    address _incentivesSpender
	// 	ERC20("CryptoGrid", "GRID")
	// 	ERC20Capped(MAXIMUM_SUPPLY)
	// {
	// 	// set initial supply to creator/owner
	// 	ERC20._mint(msg.sender, INITIAL_SUPPLY);

	// 	// 10% is sent to treasury
	// 	// treasury.depositToken(address(this), INITIAL_SUPPLY/10);

	// 	// allocate or delegate tokens to given parties on contract creation
	// 	//    marketing = _marketing;
	// 	//    transfer(_marketing, c_initial_supply*10**18/10);
	// 	//
	// 	//
	// 	//    liquidityPool = _liquidityPool;
	// 	//    transfer(_liquidityPool, c_initial_supply*10**18/10);
	// 	//
	// 	//    developmentSpender = _devSpender;
	// 	//    approve(_devSpender, c_initial_supply*10**18/4);
	// 	//
	// 	//    incentivesSpender = _incentivesSpender;
	// 	//    approve(_incentivesSpender, c_initial_supply*10**18/4);
	// }

	/// @notice GRID contract startup
	/// @dev Name: CryptoGrid,  Symbol: GRID, Decimals: 18
    function initialize() external initializer{
        __ERC20_init("CryptoGrid", "GRID");
        __ERC20Capped_init_unchained(MAXIMUM_SUPPLY);
		_mint(msg.sender, INITIAL_SUPPLY);
    }
}
