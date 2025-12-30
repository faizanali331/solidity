// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract PureView{
    uint public myStorageVariable;
    function getMyStorageVariable() public view returns(uint){ // can not update variable;
        return myStorageVariable;
    }
    function getAddition(uint a, uint b) public pure returns(uint){ // neither update nor view
        return a+b;
    }
}