// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IERC20.sol";
/*
✅ 作业 1：ERC20 代币
任务：参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
合约包含以下标准 ERC20 功能：
    balanceOf：查询账户余额。
    transfer：转账。
    approve 和 transferFrom：授权和代扣转账。
    使用 event 记录转账和授权操作。
    提供 mint 函数，允许合约所有者增发代币。
提示：
    使用 mapping 存储账户余额和授权信息。
    使用 event 定义 Transfer 和 Approval 事件。
    部署到sepolia 测试网，导入到自己的钱包
 */
contract ERC20 is IERC20 {

    mapping(address => uint256) public override balanceOf;

    mapping (address=> mapping (address => uint256)) public override allowance;

    uint256 public override totalSupply;

    string public name;

    string public symbol;

    uint256 public decimals = 18;

    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
    }

    //实现6个函数 转账逻辑
    function transfer(address recipient, uint256 amount) public override returns (bool){
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // 授权
    function approve(address spender, uint256 amount) public override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    //授权uniswap,去转账逻辑，则msg.send就是uniswap。
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    //铸造代币
    function mint(uint256 amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender,amount);
    }

    function burn (uint256 amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}