// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IERC165.sol";
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./IERC721Metadata.sol";
import "./Strings.sol";

contract ERC721 is IERC721, IERC721Metadata{

    using Strings for uint256; // 使用Strings库，
    // 4个状态变量 token名称/代号
    string public override name;
    string public override symbol;

    // tokenId 到 owner address 的持有人
    mapping(uint256 => address) private _owners;

    // address的持仓数量 映射
    mapping (address => uint) private _balances;

    // tokenId到 授权地址 的映射
    mapping (uint => address) private  _tokenApprovals;

    //owner地址 到 operator地址 的 授权映射
    mapping(address => mapping (address => bool)) private _operatorApprovals;

    error ERC721InvalidReceiver(address receiver);

    constructor(string memory name_, string memory symbol_){
        name = name_;
        symbol = symbol_;
    }

    function supportsInterface(bytes4 interfaceId) external pure override returns (bool){
        return interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId;
    }


    function balanceOf(address owner) external view override returns (uint){
        require(owner != address(0),"adress is null");
        return _balances[owner];
    }

    function ownerOf(uint tokenId) public view override returns (address owner){
        owner = _owners[tokenId];
        require(owner != address(0),"token does't exist!!");
    }

    function isApprovedForAll(address owner, address operator) external view override returns (bool){
        return _operatorApprovals[owner][operator];
    }

    function setApprovalForAll(address operator, bool _operated) external override {
        _operatorApprovals[msg.sender][operator] = _operated;
        emit ApprovalForAll(msg.sender, operator, _operated);
    }

    function getApproved(uint tokenId) external view override returns (address) {
        require(_owners[tokenId] != address(0),"token not exist");
        return _tokenApprovals[tokenId];
    }

    // 授权函数。
    function _approve(address owner, address to , uint tokenId) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function approve(address to, uint tokenId) external override {
        address owner = _owners[tokenId];
        require(owner == msg.sender || _operatorApprovals[owner][msg.sender]); //todo 本人已授权，登录钱包.用to？
        _approve(owner, to, tokenId);
    }

    //查询 spender地址(发送者or钱包) 是否可以使用tokenId（需要是owner或被授权地址）
    function _isApprovedOrOwner(address owner, address spender,uint tokenId) private view returns (bool){
        return owner == spender|| _tokenApprovals[tokenId] == spender|| _operatorApprovals[owner][spender];
    }

    function _transfer(address owner, address from, address to, uint tokenId) private {
        require(from == owner,"not owner");
        require(to != address(0), "to is zero !!");

        _approve(owner, address(0), tokenId); // 授权0地址 操作 tokenId ?? todo

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from,to,tokenId);

    }

    function transferFrom(address from, address to, uint tokenId) external override {
        address owner = ownerOf(tokenId);
        require(_isApprovedOrOwner(owner, msg.sender, tokenId), "not owner or approved !!");
        _transfer(owner, from, to, tokenId);
    }

    // 安全转账
    function _safeTransfer(address owner, address from, address to, uint tokenId, bytes memory _data) private {
        _transfer(owner, from, to, tokenId);
        _checkOnERC721Received(from, to, tokenId, _data);
    }

    function _checkOnERC721Received(address from, address to, uint tokenId, bytes memory _data) private {
        if(to.code.length>0){
            try IERC721Receiver(to).onERC721Received(msg.sender,from, tokenId, _data) returns (bytes4 retval){
                if(retval != IERC721Receiver.onERC721Received.selector){
                    revert ERC721InvalidReceiver(to);
                }
            } catch (bytes memory reason) {
                if(reason.length == 0){
                    revert ERC721InvalidReceiver(to);
                }else{
                    assembly{
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
    }

    function safeTransferFrom(address from, address to, uint tokenId, bytes memory data_) public override {
        address owner = AS;
        require(_isApprovedOrOwner(owner, msg.sender, tokenId), "not owner or approved !!");
        _safeTransfer(owner, from, to, tokenId , data_);
    }

    function safeTransferFrom(address from, address to, uint tokenId) external override {
        safeTransferFrom(from, to,tokenId,"");
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_owners[tokenId] != address(0), "token not exist!!");
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())):"";
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }


    // 铸币：通过调整_balances和_owners变量来铸造tokenId并转账给 to，同时释放Transfer事件
    function _mint(address to, uint tokenId) internal virtual{
        require(to!=address(0),"mint zero address!!");
        require(_owners[tokenId] == address(0), "token alread minted !!");

        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }


    // 销毁：通过调整_balances和_owners变量来销毁tokenId，同时释放Transfer事件。条件：tokenId存在
    function _burn(uint tokenId) internal virtual {
        address owner = ownerOf(tokenId);
        require(owner == msg.sender,"not owner of token!!");
        _approve(owner, address(0), tokenId);
        _balances[owner] -=1;
        delete _owners[tokenId];
        emit Transfer(owner, address(0), tokenId);
    }


}