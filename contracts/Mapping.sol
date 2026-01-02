// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Mapping{
    mapping(uint => bool) public myMapping;
    mapping(address => bool) public addressMapping;
    mapping(uint => mapping(uint => bool)) mapIntInt;

    function setmyMapping(uint k) public{
        myMapping[k] = true;
    }
    function setAddressMapping(address k) public{
        addressMapping[k] = true;
    }
    function setMapIntInt(uint k1, uint k2, bool value)public{
        mapIntInt[k1][k2] = value;
    }
}