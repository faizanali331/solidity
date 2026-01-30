//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
interface IERC721Receiver{
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)external returns(bytes4);
}
contract MyERC721{

    string public name;
    string public symbol;
    string private _baseURI = "https://myapi.com/metadata/";

    mapping(uint256=>address)private _owners;
    mapping(address=>uint256)private _balances;
    mapping(uint256=>address)private _tokenApprovals;
    mapping(address=>mapping(address=>bool)) private _operatorApprovals;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed from, address indexed to, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
    }
    
    function balanceOf(address owner)public view returns(uint256){
        require(owner!=address(0), "address zero");
        return _balances[owner];
    }
    function ownerOf(uint256 tokenId)public view returns(address){
        address owner = _owners[tokenId];
        require(owner != address(0), "not ad id");
        return owner;
    }
    function _mint(address to, uint256 tokenId)internal{
        require(to!=address(0), "address zero");
        require(_owners[tokenId]==address(0), "already minted");
        _owners[tokenId] = to;
        _balances[to]+=1;
        emit Transfer(address(0), to, tokenId);
    }
    function mint(uint256 tokenId)external{
        _mint(msg.sender, tokenId);
    }
    function approve(address to, uint256 tokenId)public{
        require(_owners[tokenId]==msg.sender, "not owner");
        _tokenApprovals[tokenId]=to;
        emit Approval(msg.sender, to, tokenId);
    }
    function setApprovalForAll(address operator, bool approved)public{
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (
            spender == owner ||
            _tokenApprovals[tokenId] == spender ||
            _operatorApprovals[owner][spender]
        );
    }
    function _transfer(address from, address to, uint256 tokenId) internal {
        require(from != address(0), "Not address");
        require(to != address(0), "not address");
        require(ownerOf(tokenId)==from, "not owner");
        delete _tokenApprovals[tokenId];
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not allowed");
        _transfer(from, to, tokenId);
    }
    function safeTransferFrom(address from, address to, uint256 tokenId)public{
        safeTransferFrom(from, to, tokenId, "");
    }
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)public{
        require(_isApprovedOrOwner(msg.sender, tokenId), "cant spend") ;
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "revert");
    }
    function burn(uint256 tokenId)external{
        require(_isApprovedOrOwner(msg.sender, tokenId));
        _burn(tokenId);
    }
    function _burn(uint256 tokenId)internal{
        address owner = ownerOf(tokenId);
        delete _owners[tokenId];
        delete _tokenApprovals[tokenId];
        _balances[owner]-=1;
        emit Transfer(owner, address(0), tokenId);
    }
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_owners[tokenId] != address(0), "Not exist");
        return string(abi.encodePacked(_baseURI, _toString(tokenId)));
    }
    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer); 
    }
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private  returns(bool){
        if(_isContract(to)){
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data)returns (bytes4 retval){
                return retval == IERC721Receiver.onERC721Received.selector;
            }catch{
                revert("not erc compatible");
            }
        }
        return true;
    }

    function _isContract(address account) internal view returns(bool){
        return account.code.length>0;
    }
}