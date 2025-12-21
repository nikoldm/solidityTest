// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

/**
 * 任务目标
    使用 Solidity 编写一个合约，允许用户向合约地址发送以太币。
    记录每个捐赠者的地址和捐赠金额。
    允许合约所有者提取所有捐赠的资金。

任务步骤
编写合约
    创建一个名为 BeggingContract 的合约。
    合约应包含以下功能：
        一个 mapping 来记录每个捐赠者的捐赠金额。
        一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
        一个 withdraw 函数，允许合约所有者提取所有资金。
        一个 getDonation 函数，允许查询某个地址的捐赠金额。
        使用 payable 修饰符和 address.transfer 实现支付和提款。
部署合约
    在 Remix IDE 中编译合约。
    部署合约到 Goerli 或 Sepolia 测试网。
测试合约
    使用 MetaMask 向合约发送以太币，测试 donate 功能。
    调用 withdraw 函数，测试合约所有者是否可以提取资金。
    调用 getDonation 函数，查询某个地址的捐赠金额。

任务要求
    合约代码：
    使用 mapping 记录捐赠者的地址和金额。
    使用 payable 修饰符实现 donate 和 withdraw 函数。
    使用 onlyOwner 修饰符限制 withdraw 函数只能由合约所有者调用。
    测试网部署：
    合约必须部署到 Goerli 或 Sepolia 测试网。
    功能测试：
    确保 donate、withdraw 和 getDonation 函数正常工作。

提交内容
    合约代码：提交 Solidity 合约文件（如 BeggingContract.sol）。
    合约地址：提交部署到测试网的合约地址。
    测试截图：提交在 Remix 或 Etherscan 上测试合约的截图。

额外挑战（可选）
    捐赠事件：添加 Donation 事件，记录每次捐赠的地址和金额。
    捐赠排行榜：实现一个功能，显示捐赠金额最多的前 3 个地址。
    时间限制：添加一个时间限制，只有在特定时间段内才能捐赠。
 */
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract BeggingContract {
    address private owner;
    mapping (address => uint256) private donationAddrAndAmt;
    uint256 private totalAmount=0;

    //top3
    address[3] addrs3;
    uint256[3] amounts3;

    bool private locked;
    // 线程安全锁
    modifier noReentrant(){
        require(!locked,"locked!!");
        locked = true;
        _;
        locked= false;
    }
    //添加一个时间限制，只有在特定时间段内才能捐赠
    uint256 timeLimitSecond;
    constructor(uint256 timeLimitSecond_){
        owner = msg.sender;
        timeLimitSecond =  block.timestamp + timeLimitSecond_ * 1 seconds; // 天 days
    }
    function delayTime(uint256 timeLimitSecond_) external {
        timeLimitSecond =  block.timestamp + timeLimitSecond_ * 1 seconds;
    }

    event Donation(address from, address to, uint256 amount);
    event Withdraw(address from, address to, uint256 amount);

    modifier onlyOwner {
        require(msg.sender==owner, " it is owner can call.. ");
        _;
    }

    // 接受捐赠
    function donate() external payable {
        require(block.timestamp <= timeLimitSecond, "Donation period has ended!");
        require(msg.value > 0," Donation amount must be greater than 0. ");
        donationAddrAndAmt[msg.sender] += msg.value;
        updateTop3(msg.sender, donationAddrAndAmt[msg.sender]);
        emit Donation(msg.sender, owner, msg.value);
    }

    receive() external payable {
        this.donate();
    }


    // 提取资金
    function withdraw() external payable onlyOwner {
        require(msg.sender == owner,"it is owner can call.!!!! ");
        totalAmount = address(this).balance;
        require(totalAmount > 0, " no funds !!! ");
        (bool success, ) = msg.sender.call{value:totalAmount}("");
        if(success){
            emit Withdraw(address(this), msg.sender, totalAmount);
        }
    }

    // 查询捐赠金额
    function getDonation(address addr) external view returns (uint256){
        return donationAddrAndAmt[addr];
    }
    // 更新前3名
    function updateTop3(address addr, uint256 amount) internal noReentrant{
        // 快速检查：是否可能进入前三
        if (amount <= amounts3[2]) {
            return;
        }
        // 检查是否已存在前3
        for (uint256 i = 0; i < 3; i++) {
            if (addrs3[i] == addr) {
                amounts3[i] = amount;
                // 重新排序
                bubbleSort();
                return ;
            }
        }
        for(uint256 i=0; i<amounts3.length; i++){
            if(amount>amounts3[i]){
                for(uint256 j=amounts3.length-1; j > i; j--){
                    amounts3[j] = amounts3[j-1];
                    addrs3[j] = addrs3[j-1];
                }
                amounts3[i] = amount;
                addrs3[i] = addr;
                break ;
            }
        }
    }
    // 冒泡排序
    function bubbleSort() public {
        uint256 n = amounts3.length;
        for (uint256 i = 0; i < n - 1; i++) {
            for (uint256 j = 0; j < n - i - 1; j++) {
                if (amounts3[j] < amounts3[j + 1]) {
                    // 交换
                    (amounts3[j], amounts3[j + 1]) = (amounts3[j + 1], amounts3[j]);
                    (addrs3[j], addrs3[j + 1]) = (addrs3[j + 1], addrs3[j]);
                }
            }
        }
    }

    // 查询金额前三的地址和金额；
    function getDonationTop3() external view returns (address[3] memory,uint256[3] memory) {
        return (addrs3, amounts3);
    }

    // 获取当前钱包金额
    function getBalance()external view returns (uint256) {
        return msg.sender.balance;
    }

    // 查询当前合约金额
    function getAddr()external view returns (uint256) {
        return address(this).balance;
    }

}