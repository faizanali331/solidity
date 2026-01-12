// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;


contract Ownable {
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner can access this function");
        _;
    }
}

contract SharedWallet is Ownable {

    
    mapping(address => mapping(address => uint256)) public allowance;

    
    event Sent(address indexed _from, address indexed _to, uint256 _amount);
    event Allowed(address indexed _owner, address indexed _spender, uint256 _amount);

    
    constructor() payable {
        
    }
    function deposit() public payable {
        require(msg.value > 0, "Send ETH to deposit");
    }
    fallback() external payable {
        
    }
    receive() external payable {
       
    }

    function approve(address _spender, uint256 _amount) public onlyOwner {
        require(_spender != address(0), "Invalid address");
        allowance[owner][_spender] = _amount; // Overwrite previous allowance
        emit Allowed(owner, _spender, _amount);
    }
    function increaseAllowance(address _spender, uint256 _amount) public onlyOwner {
        require(_spender != address(0), "Invalid address");
        allowance[owner][_spender] += _amount;
        emit Allowed(owner, _spender, allowance[owner][_spender]);
    }
    function reduceAllowance(address _spender, uint256 _amount) public onlyOwner {
        require(_spender != address(0), "Invalid address");
        require(_amount <= allowance[owner][_spender], "Reduce amount exceeds current allowance");
        allowance[owner][_spender] -= _amount;
        emit Allowed(owner, _spender, allowance[owner][_spender]);
    }


    function withdraw(uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than zero");
        require(_amount <= address(this).balance, "Not enough ETH in wallet");

        if (msg.sender == owner) {
            payable(owner).transfer(_amount);
        } else {
            require(_amount <= allowance[owner][msg.sender], "Amount exceeds your allowance");
            allowance[owner][msg.sender] -= _amount;
            payable(msg.sender).transfer(_amount);
        }
        emit Sent(address(this), msg.sender, _amount);
    }
}
