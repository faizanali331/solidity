// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

contract Const{
    
    string public name;
    uint public supply;
    address public owner;

    constructor(string memory _name, uint _supply) {
        name = _name;
        supply = _supply;
        owner = msg.sender;
    }
}

