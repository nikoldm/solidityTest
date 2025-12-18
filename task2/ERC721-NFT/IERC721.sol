// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IERC165.sol";

interface IERC721 is IERC165{

    // function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
    //     return interfaceId == type(IERC721).interfaceId;
    // }

    // 3个事件
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed own, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // 9个函数
    // 返回某个地址的NFT持有量
    function balanceOf(address owner) external view returns (uint256 balance);

    // 返回某tokenId的主人地址
    function ownerOf(uint256 tokenId) external view returns (address owner);

    // 安全转账（如果接收方是合约地址，会要求实现ERC721Receiver接口）。参数为转出地址from，接收地址to和tokenId。
    function safeTransferFrom(address from, address to ,uint256 tokenId, bytes calldata data) external ;
    function safeTransferFrom(address from, address to , uint256 tokenId) external ;
    // 普通转账
    function transferFrom(address from, address to, uint256 tokenId) external ;

    // 授权to地址使用你的NFT
    function approve(address to , uint256 tokenId) external ;

    // 把自己持有的NFT批量授权给operator地址。
    function setApprovalForAll(address operator, bool _approved) external ;

    // 查询tokenId被批准给了那个地址
    function getApproved(uint256 tokenId) external view returns (address operator);

    // 查询owner地址是否批量授权给了operator地址。
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}