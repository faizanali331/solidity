// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;
contract Sendermsg{
    address public someaddress;
    function updateAddress() public{
        someaddress = msg.sender;
    }
}