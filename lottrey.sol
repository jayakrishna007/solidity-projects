pragma solidity >=0.5.0 <0.9.0;


/** 
 * @title Lottery
*/  
contract Lottery {
    
    //list of players registered in lotery
    address payable[] public players;
    address public admin;
    
    
    constructor() {
        admin = msg.sender;
        players.push(payable(admin));
    }
    
    modifier onlyOwner() {
        require(admin == msg.sender, "You are not the owner");
        _;
    }
    
    
    
    receive() external payable {
    
        require(msg.value == 0.1 ether , "Must send 0.1 ether amount");
        
       
        require(msg.sender != admin);
        
       
        players.push(payable(msg.sender));
    }
    
     
    function getBalance() public view onlyOwner returns(uint){
        // returns the contract balance 
        return address(this).balance;
    }
    
   
    function random() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    
    function pickWinner() public onlyOwner {

        
        require(players.length >= 3 , "Not enough players in the lottery");
        
        address payable winner;
        
        
        winner = players[random() % players.length];
        
        
        winner.transfer( (getBalance() * 90) / 100); 
        payable(admin).transfer( (getBalance() * 10) / 100); 
        
        
       resetLottery(); 
        
    }
    
    
    function resetLottery() internal {
        players = new address payable[](0);
    }

}