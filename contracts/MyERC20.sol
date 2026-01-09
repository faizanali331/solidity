//SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.16;

contract Ownable{
    address internal owner;
    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner(){
        require(owner==msg.sender, "Your are not owner Allah hafiz");
        _;
    }
}

contract MyERC20 is Ownable{

    uint256 public totalSupply;
    mapping(address=>uint256) balances;
    mapping(address=>mapping(address=> uint256) ) allowances;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(uint _initialSupply){
        //owner = msg.sender;
        _mint(owner, _initialSupply);
    }
    function _mint(address _to, uint256 _amount) internal onlyOwner{
        require(_to!=address(0), "Address invalid cannot mint");
        totalSupply += _amount;
        balances[_to] += _amount;
        emit Transfer(address(0), _to, _amount);
    }
    function balanceOf(address _address) view public returns(uint256){
        return balances[_address];
    }
    function allowance(address _from, address _to) view public returns(uint256){
        return allowances[_from][_to];
    }
    function approve(address _spender, uint256 _amount) public returns(bool){
        address _owner = msg.sender;
        _approve(_owner, _spender, _amount);
        emit Approval(_owner, _spender, _amount);
        return true;
        
    }
    function _approve(address _owner, address _spender, uint256 _amount) internal {
        require(_owner != address(0), "undefined ownder aborting");
        require(_spender != address(0), "undefined spender aborting");
        allowances[_owner][_spender] = _amount;
    }
    function transferFrom(address _from, address _to, uint256 _amount) public returns(bool){
        address _spender = msg.sender;
        require(allowances[_from][_spender] >= _amount, "insufficient allowance aborting");
        allowances[_from][_spender] = allowances[_from][_spender] - _amount;
        _transfer(_from, _to, _amount);
        return true;
    }
    function transfer(address _to, uint256 _amount) public returns(bool) {
        address _owner = msg.sender;
        _transfer(_owner, _to, _amount);
        return true;
    }
    function _transfer(address _from, address _to, uint256 _amount) internal {
        require(_to != address(0), "undefined to aborting");
        require(_amount > 0, "invalid amount aborting");
        require(_amount <= balances[_from], "insufficient balance aborting");
        balances[_from] = balances[_from] - _amount;
        balances[_to] = balances[_to] + _amount;
        emit Transfer(_from, _to, _amount);
    }
    function _burn(uint256 _amount) internal{
        address _owner = msg.sender;
        require(_amount > 0, "invalid amount aborting");
        require(balances[_owner]>=_amount, "insufficient balance aborting");
        balances[_owner] = balances[_owner] - _amount;
        totalSupply = totalSupply-_amount;
        emit Transfer(_owner, address(0), _amount);
    }
}