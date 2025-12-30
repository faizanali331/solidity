
// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

contract MessageSender{
    uint public counter;
    string public theMessage;
    address public owner;

    constructor(){
        owner = msg.sender;
    }
    function updateTheMessage(string memory _message) public{
        if(msg.sender==owner){
            theMessage = _message;
            counter++;
        }
    }
}