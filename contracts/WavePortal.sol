// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {

    uint totalWaves;
    uint private seed;

    event NewWave(
        address waver,
        string link,
        string message,
        uint256 timestamp
    );

    struct Wave {
        address waver;
        string link;
        string message;
        uint256 timestamp;
    }

    mapping(address => uint) public lastWavedAt;

    Wave[] waves;

    constructor() payable{ 
        console.log("Aye this is my first project contract");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message, string memory _link) public {
        totalWaves ++;

        require(lastWavedAt[msg.sender] + 30 seconds < block.timestamp, 
            "Wait 15 minutes"
        );

        
        lastWavedAt[msg.sender] = block.timestamp;

        waves.push(Wave(msg.sender,_link, _message, block.timestamp));

        seed = (block.timestamp + block.difficulty) % 100;
        
        if(seed <= 50){
            // arr.push(payable(msg.sender));

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
            emit NewWave(msg.sender,_link, _message, block.timestamp);
    }

    function getAllWaves() public view returns(Wave[] memory){
        return waves;
    }

    function getTotalWaves() public view returns(uint){
        // console.log("Number of waves %d", totalWaves);
        return totalWaves;
    }

}