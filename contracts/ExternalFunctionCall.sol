// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
 
contract ContractOne {
 
    mapping(address => uint) public addressBalances;
 
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
 
    function deposit() public payable {
        addressBalances[msg.sender] += msg.value;
    }
}
 // one way of calling
contract ContractTwo {
 
    function deposit() public payable {}
 
    function depositOnContractOne(address _contractOne) public { 
        ContractOne one = ContractOne(_contractOne);
        one.deposit{value: 10, gas: 100000}(); 
    }
}


// Second way of calling
// contract ContractTwo {
 
//     function deposit() public payable {}
 
//     function depositOnContractOne(address _contractOne) public { 
//         bytes memory payload = abi.encodeWithSignature("deposit()");
//         (bool success, ) = _contractOne.call{value: 10, gas: 100000}(payload);
//         require(success);
//     }
// }


// Third Way of calling

// contract ContractTwo {
 
//     function deposit() public payable {}
 
//     function depositOnContractOne(address _contractOne) public { 
//         (bool success, ) = _contractOne.call{value: 10, gas: 100000}("");
//         require(success);
//     }
// }