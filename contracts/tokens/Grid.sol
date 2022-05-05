// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Treasury.sol";

/// @title GRID is the main token/currency contract for CryptoGrid game.
/// @notice GRID will facilitate player based transactions like selling their GPUs/CPUs./ASICs and land on the marketplace. It'll also be used to buy/rent land from the game where the tokens will be burned to ensure it will be sustainable.
/// @dev 750 million hard cap for the GRID token / 25 million tokens minted on contract deployment
contract Grid is ERC20Capped, Ownable {
  uint256 private constant c_maximum_supply = 750000000;
  uint256 private constant c_initial_supply = 25000000;

  // token holders / spenders
  address public marketing; // initial 10% allocation to marketing to gather new players to the game (5 year based schedule)
  
  // initial supply 10% allocation to treasury multi-sig to fund our operation costs and hire staff
  Treasury public treasury;
  // address public treasury; 

  address public liquidityPool; // initial supply 30% allocation to liquidity pool on DEX like sushiswap
  address public developmentSpender; // initial supply 25% approval to developer multi-sig wallet to fund development of the game
  address public incentivesSpender; // initial supply 25% approval for incentives for players to stake their tokens into sushiswap farm and ensure stability of price

  /// @notice GRID contract startup
  /// @dev Name: CryptoGrid,  Symbol: GRID, Decimals: 18
  constructor(
    address _marketing,
    address _treasury,
    address _liquidityPool,
    address _devSpender,
    address _incentivesSpender
  ) ERC20("CryptoGrid", "GRID") ERC20Capped(c_maximum_supply**10*18) onlyOwner {
    // set initial supply creator/owner
    ERC20._mint(msg.sender, c_initial_supply**10*18);

    // allocate or delegate tokens to given parties on contract creation
    marketing = _marketing;
    transfer(_marketing, c_initial_supply**10*18/10);

    // new to provide approval instead of account transfer
    treasury.initialDepositToken(_treasury, (c_initial_supply**10*18/10));

    liquidityPool = _liquidityPool;
    transfer(_liquidityPool, c_initial_supply**10*18/10);

    developmentSpender = _devSpender;
    approve(_devSpender, c_initial_supply**10*18/4);

    incentivesSpender = _incentivesSpender;
    approve(_incentivesSpender, c_initial_supply**10*18/4);
  }

}
