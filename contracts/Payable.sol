// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract Payable{
    string public str = "hello";

    function updateStr(string memory _str) public payable{
        if(msg.value == 1 ether){
            str = _str;
        }else{
            payable(msg.sender).transfer(msg.value);
        }
    }
}