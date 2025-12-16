// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/*
1✅ 反转字符串 (Reverse String)
题目描述：反转一个字符串。输入 "abcde"，输出 "edcba"
2✅  用 solidity 实现整数转罗马数字
题目描述在 https://leetcode.cn/problems/roman-to-integer/description/3.
3✅  用 solidity 实现罗马数字转数整数
题目描述在 https://leetcode.cn/problems/integer-to-roman/description/
4✅  合并两个有序数组 (Merge Sorted Array)
题目描述：将两个有序数组合并为一个有序数组。
5✅  二分查找 (Binary Search)
题目描述：在一个有序数组中查找目标值。
 */
contract Task1{

    //反转字符串 (Reverse String)
    function reverseStr(string memory str) public pure returns (string memory){
        bytes memory s = bytes(str);
        bytes1 temp;
        for (uint256 i = 0; i < s.length/2; i++)
        {
            temp= s[i];
            s[i] = s[s.length-i-1];
            s[s.length-i-1] = temp;
        }
        return string(s);
    }

    // 用 solidity 实现整数转罗马数字
    function toRoman(uint256 num) public pure returns (string memory) {

        require(num >= 1 && num <= 3999, "Number between 1 and 3999");

        //整数映射关系
        uint256[] memory intNums = new uint256[](13);
        string[] memory symbols = new string[](13);
        intNums[0]=1000; symbols[0]="M";
        intNums[1]=900; symbols[1]="CM";
        intNums[2]=500; symbols[2]="D";
        intNums[3]=400; symbols[3]="CD";
        intNums[4]=100; symbols[4]="C";
        intNums[5]=90; symbols[5]="XC";
        intNums[6]=50; symbols[6]="L";
        intNums[7]=40; symbols[7]="XL";
        intNums[8]=10; symbols[8]="X";
        intNums[9]=9; symbols[9]="IX";
        intNums[10]=5; symbols[10]="V";
        intNums[11]=4; symbols[11]="IV";
        intNums[12]=1; symbols[12]="I";

        bytes memory reslut;
        for (uint256 i=0;i<intNums.length;i++){
            while(intNums[i] <= num){
                num -= intNums[i];
                reslut = abi.encodePacked(reslut, symbols[i]);
            }
        }
        return string(reslut);
    }

    // 罗马数字转整数
    mapping(string => uint256) private romanMap;
    constructor() {
        romanMap["I"] = 1;
        romanMap["V"] = 5;
        romanMap["X"] = 10;
        romanMap["L"] = 50;
        romanMap["C"] = 100;
        romanMap["D"] = 500;
        romanMap["M"] = 1000;
    }
    function toInteger(string memory str) public view returns (uint256) {
        bytes memory b = bytes(str);
        uint256 num = 0;
        uint256 prev = 0;
        for (uint256 i = b.length; i >= 1; i--)
        {
            string memory b1 = string(abi.encodePacked(b[i-1]));
            uint256 value = romanMap[b1];
            if(value<prev){
                num = num - value;
            }else{
                num =num + value;
            }
            prev = value;

        }
        return num;
    }

    //合并两个有序数组 (Merge Sorted Array)
    function mergeArray(uint256[] memory a, uint256[] memory b) public pure returns (uint256[] memory){
        uint256[] memory mergeArr = new uint256[](a.length+b.length);
        uint256 i = 0;
        uint256 j = 0;
        uint256 k = 0;
        for (; i<a.length && j<b.length; )
        {
            mergeArr[k++] = (a[i] <= b[j]) ? a[i++] : b[j++];
        }
        // 处理 a 中剩余元素
        while (i < a.length) {
            mergeArr[k++] = a[i++];
        }

        // 处理 b 中剩余元素
        while (j < b.length) {
            mergeArr[k++] = b[j++];
        }

        return mergeArr;
    }

    // 二分查找 (Binary Search)
    function binarySearch(uint256[] memory arr, uint256 point) public pure returns (int256){
        if(arr.length==0){
            return -1;
        }
        uint256 left =0;
        uint256 right = arr.length-1;
        while(left<=right){
            uint256 mid = (left+right)/2;
            if(arr[mid] == point){
                return int256(mid);
            }
            if(arr[mid] < point){
                left = mid+1;
            }else{
                right = mid-1;
            }
        }
        return -1;
    }
}