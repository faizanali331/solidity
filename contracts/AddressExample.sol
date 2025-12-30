// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

contract AddressExample{
    address public someAddress;
    function setAddress (address _add) public{
        someAddress = _add;
    }
    function getAddressBalance()public view returns(uint){
        return someAddress.balance;
    }
}