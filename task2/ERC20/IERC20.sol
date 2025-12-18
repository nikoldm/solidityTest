// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface IERC20{

    // 两个事件： 转账和授权是释放
    event Transfer(address indexed from, address indexed to ,uint256 amount);

    event Approval(address indexed, address indexed, uint256);

    // 6个函数
    // 返回总供给
    function totalSupply() external view returns (uint256);

    // 账号余额
    function balanceOf() external view returns (uint256);

    //转账
    function transfer(address to ,uint256 amount) external returns (bool);

    //返回授权额度9
    function allowance(address owner,address spender) external view returns (uint256);

    //授权
    function approve(address spender, uint256 amount) external returns (bool);

    //授权转账
    function transferFrom(address from, address to, uint256 amount) external returns (bool);

}