// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Lottery{
    address payable[] public players;
    address manager;
    address payable public winner;

    constructor(){
        manager = msg.sender;
    }

    receive() external payable{
        require(msg.value == 1 ether);
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require( msg.sender== manager,"only manager can access");
        return address(this).balance;
    }

    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function pickWinner() public{
        require(msg.sender == manager, "only manager can access");
        require(players.length > 2, "players must be more than 2");
        uint r= random();
        uint index = r%players.length;
        // address payable winner;
        winner = players[index];

        winner.transfer(getBalance());
        players = new address payable[](0);
    }

    function allPlayers() public view returns(address payable[] memory){
        return players;
    }
}