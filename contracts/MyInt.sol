// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;
contract MyInt{
    uint8 public myUint8  = 54;
    uint256 public myUint256;
    int public myInt = 0;
    function setUint8() public{
        myUint8++;
    }
    function setUint256() public{
        myUint256--;
    }
    function myint() public{
        myInt = myInt + 5;
    }
}