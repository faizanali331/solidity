// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Ownable {
    address internal owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not owner, Allah hafiz");
        _;
    }
}

contract MyERC20 is Ownable {

    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;

    uint256 public totalSupply;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 _initialSupply) {
        // scale supply using decimals
        _mint(owner, _initialSupply * (10 ** decimals));
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowances[_owner][_spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(
            msg.sender,
            spender,
            allowances[msg.sender][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        uint256 currentAllowance = allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "decrease below zero");

        _approve(
            msg.sender,
            spender,
            currentAllowance - subtractedValue
        );
        return true;
    }

    function _approve(address _owner, address _spender, uint256 _amount) internal {
        require(_owner != address(0), "approve from zero");
        require(_spender != address(0), "approve to zero");

        allowances[_owner][_spender] = _amount;
        emit Approval(_owner, _spender, _amount);
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 currentAllowance = allowances[from][msg.sender];
        require(currentAllowance >= amount, "insufficient allowance");

        allowances[from][msg.sender] = currentAllowance - amount;
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "transfer from zero");
        require(to != address(0), "transfer to zero");
        require(amount > 0, "invalid amount");
        require(balances[from] >= amount, "insufficient balance");

        balances[from] -= amount;
        balances[to] += amount;

        emit Transfer(from, to, amount);
    }
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "mint to zero");

        totalSupply += amount;
        balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    function burn(uint256 amount) public {
        require(amount > 0, "invalid amount");
        require(balances[msg.sender] >= amount, "insufficient balance");

        balances[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }
}
