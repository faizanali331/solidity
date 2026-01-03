// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract Sender{
    receive() external payable {}

    function withdrawTranser(address payable _to) public{
        _to.transfer(10);
    }
    function withdrawSend(address payable _to) public{
        bool success = _to.send(10);
        require(success, "Send transection is failled");
    }
}
contract ReceiverNoAction{
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    receive() external payable{}

}
contract ReceiverAction{
    uint public receivedBalance;
    function getBalance() public view returns(uint){
        //return receivedBalance;
        return address(this).balance;
    }
    receive() external payable{
        receivedBalance = msg.value;
    }
}