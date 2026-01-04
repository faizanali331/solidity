// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract Consumer{
    function getBalance() public view returns (uint){
        return address(this).balance;
    }
    function deposit() public payable{}
}

contract WalletProject{
    address payable public owner;
    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;
    mapping(address => bool) public guardians;

    address payable nextOwner;
    uint guardianResetCounter;
    uint public confirmationFromGuardiansForReset = 3;
    mapping(address => mapping(address => bool)) public nextOwnerGuardianVotedBool;

    constructor(){
        owner = payable(msg.sender);
    }

    function setGuardian(address _guardian, bool _isGuardian) public{
        require(msg.sender == owner, "You are not owner aborting");
        guardians[_guardian] = _isGuardian;
    }

    function proposingNewOwner(address payable _newOwner) public{
        require(guardians[msg.sender], "You are not a guardian aborting");
        require(nextOwnerGuardianVotedBool[nextOwner][msg.sender]==false, "you already voted, aborting");
        if(owner != _newOwner){
            nextOwner = _newOwner;
            guardianResetCounter=0;
        }
        guardianResetCounter++;
        if(guardianResetCounter>=confirmationFromGuardiansForReset){
            owner = nextOwner;
            nextOwner = payable(address(0));
        }

    }

    function setAllowance(address _user, uint _amount) public{
        if(msg.sender == owner){
            allowance[_user] = _amount;
            if(_amount>0){
                
                isAllowedToSend[_user] = true;
            }else isAllowedToSend[_user] = false;
        }else{
            revert("You are not owner");
        }
    }

    function transfer(address payable _to, uint _amount, bytes memory _payload) public payable returns(bytes memory){
        //require(msg.sender == owner, "You are not the owner");
        if(msg.sender != owner){
            require(isAllowedToSend[msg.sender], "You are not allowed to send money");
            require(allowance[msg.sender] >= _amount, "You don't have enough allowance");
            allowance[msg.sender] -= _amount;

        }
        
        (bool success, bytes memory data) = _to.call{value: _amount}(_payload);
        require(success, "Aborting");
        return data;
    }

    receive() external payable { }


}