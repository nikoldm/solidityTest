// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/*
创建一个名为Voting的合约，包含以下功能：
一个mapping来存储候选人的得票数
一个vote函数，允许用户投票给某个候选人
一个getVotes函数，返回某个候选人的得票数
一个resetVotes函数，重置所有候选人的得票数
*/
contract Voting{

    // 存储候选人得票数
    mapping(address => uint256) public voteMap;

    // 存储候选人，用于重置
    address[] private voteCandidateAddr;

    // 记录已投票，防止重复投
    mapping(address => bool) public hasVotedAddr;


    // 投票
    function vote(address _addr) public {
        //地址是否无效
        require(_addr != address(0), "Invalid candidate");
        // 是否已投票
        require(!hasVotedAddr[msg.sender], "you have already voted1");

        // 是否 新候选人
        bool exists = false;
        for (uint256 i=0; i<voteCandidateAddr.length; i++)
        {
            if(voteCandidateAddr[i] == _addr) {
                exists = true;
                break;
            }
        }
        if(!exists){
            voteCandidateAddr.push(_addr);
        }

        // 投票
        voteMap[_addr] ++ ;
        hasVotedAddr[msg.sender] = true;
    }

    // 获取某个候选人的的票数
    function getVotes(address _addr) public view returns (uint256){
        return voteMap[_addr];
    }

    // 重置所有人的得票
    function resetVotes() public {
        for (uint256 i = 0; i<voteCandidateAddr.length;i++){
            voteMap[voteCandidateAddr[i]] = 0;
        }
    }

}