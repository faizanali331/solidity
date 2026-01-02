// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract Asser{
    mapping (address => uint) public balances;
    function deposit(uint amount) public  {
        uint oldAmount = balances[msg.sender];
        balances[msg.sender]+=amount;
        assert(oldAmount<=balances[msg.sender]); //checks if the old amount is less than or equal to the new amount)
    }
    
}