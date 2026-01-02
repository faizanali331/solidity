// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract ExceptionRequire{

    mapping(address => uint) public balances;

    function deposit() public payable {
        
       balances[msg.sender]+=msg.value;
    }
    function withdraw(uint amount) public{
        require(balances[msg.sender]>=amount,"Insufficient Balance");
        balances[msg.sender]-=amount;
        payable(msg.sender).transfer(amount);

        // if(balances[msg.sender]<=amount){
        //     revert("Not enough balance");
        // }else{
        //     balances[msg.sender]-=amount;
        //     payable(msg.sender).transfer(amount);
        // }
    }
}
