// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Mine is a factory that allows users to mine with their hardware.
// there will be 3 coins at the start, gridBTC, gridETH and gridXMR all of them will have the same price to the real world data from
// chainlinks agregatorv3interface. This contract does not need to be upgraded.
contract MineFactory {
    address[] public tokens;

    constructor() {
        MineToken btc = new MineToken("gridBTC", "gridBTC", msg.sender);
        MineToken eth = new MineToken("gridETH", "gridETH", msg.sender);
        MineToken xmr = new MineToken("gridXMR", "gridXMR", msg.sender);
        tokens.push(address(btc));
        tokens.push(address(eth));
        tokens.push(address(xmr));
    }

    function getTokens() public view returns (address[] memory) {
        return tokens;
    }
}

contract MineToken is ERC20 {
    address public owner;
    mapping(address => bool) allowed;
    
    constructor(string memory _name, string memory _symbol, address _owner) ERC20(_name, _symbol) {
        owner = _owner;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Call not allowed");
        _;
    }

    modifier onlyAllowed {
        require(allowed[msg.sender], "Call not allowed");
        _;
    }

    function mint(address _to, uint256 _amount) public onlyAllowed {
        _mint(_to, _amount);
    }

    function allowMint(address _address) public onlyOwner {
        allowed[_address] = true;
    }

    function burn(uint256 _amount) public {
        _burn(msg.sender, _amount);
    }
} 
