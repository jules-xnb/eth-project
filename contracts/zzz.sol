pragma solidity ^0.5.16;

// SPDX-License-Identifier: MIT

contract zzzz {
    string name ;
    uint capital;
    uint nonce = 1 ; 
    uint fees ; 
    
    constructor(string memory _name, uint _capital, uint _fees) public {
        name = _name ;
        capital = _capital; 
        fees = _fees ; 
    }
    
    struct User {
        uint balance;
        string name ; 
        bool registered ; 
    }
    
    mapping (address => User) user;
    
    function register(string memory _name) public {
        require (user[msg.sender].registered == false, "Vous etes deja connu de la banque"); 
        user[msg.sender].name = _name ; 
        user[msg.sender].registered = true ; 
        welcomeBonus(); 
    }
    
    function checkRegistered(address _address) private view returns(bool){
        if (user[_address].registered == true){
            return true ; 
        } else {
            return false ; 
        }
    }
    
    function payFees() private {
        user[msg.sender].balance -= fees ; 
        capital += fees ; 
    }
    
    function myBalance() public view returns(uint) {
        require(checkRegistered(msg.sender) == true, "Utilisateur inconnu de la banque");
        return user[msg.sender].balance;
    }
    
    function getBalanceOfCasino() public view returns (uint){
        return capital ; 
    }
    
    function balanceOf(address _address) public view returns (uint) {
        require(checkRegistered(_address) == true, "Utilisateur inconnu de la banque");
        return user[_address].balance;
    }
    
    function welcomeBonus() private {
        user[msg.sender].balance += 100;
        capital -= 100 ; 
    }
      
    function transfer(address _address, uint _amount) public {
        require(user[msg.sender].balance >= _amount, "Pas assez d'argent'");
        user[msg.sender].balance -= _amount;
        user[_address].balance += _amount;
    }
    
    function depositMoney() external payable {
        require(checkRegistered(msg.sender) == true, "Utilisateur inconnu de la banque");
        user[msg.sender].balance += msg.value ; 
    }
    
    function withdrawMoney(uint _amount) external {
        require(checkRegistered(msg.sender) == true, "Utilisateur inconnu de la banque");
        require(_amount <= user[msg.sender].balance, "Pas assez d'argent sur votre compte");
        user[msg.sender].balance -= _amount ; 
        msg.sender.transfer(_amount); 
    }
    
    function random(uint _n) private returns (uint) {
        uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % _n;
        randomnumber = randomnumber ;
        nonce += randomnumber;        
        return randomnumber;
    }
    
    function headsTails (uint _amount, uint _choice) public {
        require(checkRegistered(msg.sender) == true, "Utilisateur inconnu de la banque");
        require(_amount <= user[msg.sender].balance, "Pas assez d'argent sur votre compte");
        require (_choice < 2 && _choice >= 0, "nombre non compris entre 0 et 1"); 
        if (random(2) == _choice){
            user[msg.sender].balance += _amount ; 
            capital -= _amount ; 
        } else {
            user[msg.sender].balance -= _amount ;
            capital += _amount ;
        }
        payFees(); 
    }
    
    function wheel (uint _amount, uint _choice) public {
        require(checkRegistered(msg.sender) == true, "Utilisateur inconnu de la banque");
        require(_amount <= user[msg.sender].balance, "Pas assez d'argent sur votre compte");
        require (_choice < 36 && _choice >= 0, "nombre non compris entre 0 et 1"); 
        uint r = random(36) ; 
        
        if (_choice == r){
            if (r == 0) {
                user[msg.sender].balance += _amount * 36;
                capital -= _amount * 36;
            } else {
                user[msg.sender].balance += _amount ;
                capital -= _amount ;
            }
        } else {
            user[msg.sender].balance -= _amount ;
            capital += _amount ;
        }
        payFees(); 
    }
    
    
    
}







