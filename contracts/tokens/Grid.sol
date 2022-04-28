// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title GRID is the main token/currency contract for CryptoGrid game.
/// @notice GRID will facilitate player based transactions like selling their GPUs/CPUs./ASICs and land on the marketplace. It'll also be used to buy/rent land from the game where the tokens will be burned to ensure it will be sustainable.
/// @dev 750 million hard cap for the GRID token / 25 million tokens minted on contract deployment
contract Grid is ERC20Capped, Ownable {
    uint256 private immutable MAXIMUM_SUPPLY = 750000000*1e18;
    uint256 private immutable INITIAL_SUPPLY = 25000000*1e18;

    // token holders
    address public marketing;
    address public treasury;
    address public liquidityPool;
    mapping(address => uint256) public balance;

    /// @notice GRID contract startup
    /// @dev Name: CryptoGrid,  Symbol: GRID, Decimals: 18 
    constructor(address _marketing, address _treasury, address _liquidityPool) ERC20("CryptoGrid", "GRID") ERC20Capped(MAXIMUM_SUPPLY) onlyOwner {
        // set initial supply creator/owner
        balance[msg.sender] = INITIAL_SUPPLY;
        _mint(msg.sender, INITIAL_SUPPLY);

        // allocate to given parties on contract creation

        // 10% to marketing
        marketing = _marketing;
        balance[msg.sender] = balance[msg.sender] - INITIAL_SUPPLY/10;
        balance[_marketing] = INITIAL_SUPPLY/10;
        emit Transfer(msg.sender, _marketing, INITIAL_SUPPLY/10);

        // 10% to treasury
        treasury = _treasury;
        balance[msg.sender] = balance[msg.sender] - INITIAL_SUPPLY/10;
        balance[_treasury] = INITIAL_SUPPLY/10;
        emit Transfer(msg.sender, _treasury, INITIAL_SUPPLY/10);

        // 30% to liquidity pool
        liquidityPool = _liquidityPool;
        balance[msg.sender] = balance[msg.sender] - INITIAL_SUPPLY*3/10;
        balance[_liquidityPool] = INITIAL_SUPPLY*3/10;
        emit Transfer(msg.sender, _liquidityPool, INITIAL_SUPPLY*3/10);
    }
}
