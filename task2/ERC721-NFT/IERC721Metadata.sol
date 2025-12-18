// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IERC721.sol";

// 实现了3个查询metadata元数据的常用函数
interface IERC721Metadata is IERC721{

    // 代币名称
    function name() external view returns (string memory);

    // 代币符号
    function symbol() external view returns (string memory);

    // 查询metadata的链接
    function tokenURI(uint256 tokenId) external view returns (string memory);
}