pragma solidity ^0.5.16;

contract UserContract {

    struct User {
        uint balance;
        string name ;
        bool registered ;
        address id ;  
    }

    User[] users ; 

    mapping (address => User) internal user ;

    modifier isRegistered () {
        require (user[msg.sender].registered == true ) ; 
        _; 
    }
    
    function getBalance () external view returns (uint) {
        return user[msg.sender].balance ; 
    }
    
    function getName () external view returns ( string memory) {
        return user[msg.sender].name ; 
    }
    

}