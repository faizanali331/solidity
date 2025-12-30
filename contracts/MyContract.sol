
// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;
contract MyContract{
    string public str = "Hello World";
    function updateString (string memory _updatedString) public{
        str = _updatedString;
    }
}