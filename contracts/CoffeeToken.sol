// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CoffeeToken is ERC20, Ownable {

    event CoffeePurchased(address indexed receiver, address indexed buyer);

    constructor(uint256 initialSupply)
        ERC20("Coffee", "CFE")
        Ownable(msg.sender)
    {
        _mint(msg.sender, initialSupply*10**decimals());
    }

    // 🔹 Only owner can mint new tokens
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount*10**decimals());
    }

    // 🔹 Anyone can burn their own tokens
    
    function buyOneCoffee() public {
        _burn(_msgSender(), 1*10**decimals());
        emit CoffeePurchased(_msgSender(), _msgSender());
    }
 
    function buyOneCoffeeFrom(address account) public {
        _spendAllowance(account, _msgSender(), 1*10**decimals());
        _burn(account, 1*10**decimals());
        emit CoffeePurchased(_msgSender(), account);
    }
}
