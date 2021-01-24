pragma solidity ^0.5.16;

import "./casino.sol" ;

contract Game is Casino {

    uint private nonce = 1 ; 

    event newWin(uint _amount);
    event newLoose(uint _amount); 

    function random(uint _n) private returns (uint) {
        uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce, _n))) % _n;
        nonce += randomnumber;        
        return randomnumber;
    }

    function headsTails (uint _amount, uint _choice) external isRegistered() onlyHaveToken(_amount/Token.multiplyToken){
        require(_amount <= user[msg.sender].balance, "Veuillez acheter plus de tokens");
        require (_choice < 2 && _choice >= 0, "nombre non compris entre 0 et 1"); 
        if (random(2) == _choice){
            user[msg.sender].balance += _amount ;
            increaseBalances(_amount) ; 
            Token.updateAvailableSupply();
            emit newWin(_amount); 
        } else {
            user[msg.sender].balance -= _amount ;
            decreaseBalances(_amount) ;
            Token.updateAvailableSupply();
            emit newLoose(_amount); 
        }
        payFees(); 
    }

    function wheel (uint _amount, uint _choice) public isRegistered() onlyHaveToken(_amount/Token.multiplyToken*36){
        require(_amount <= user[msg.sender].balance, "Veuillez acheter plus de tokens");
        require (_choice < 36 && _choice >= 0, "nombre non compris entre 0 et 36"); 
        uint r = random(36) ; 
        
        if (r == 0 && _choice == 0){
            user[msg.sender].balance += _amount * 36;
            increaseBalances(_amount) ; 
            Token.updateAvailableSupply();
            emit newWin(_amount); 
        } else if (_choice % 2 == r % 2){
            user[msg.sender].balance += _amount ;
            increaseBalances(_amount) ; 
            Token.updateAvailableSupply();
            emit newWin(_amount);
        } else {
            user[msg.sender].balance -= _amount ;
            decreaseBalances(_amount) ; 
            Token.updateAvailableSupply();
            emit newLoose(_amount);
        }
        payFees(); 
    }


    function increaseBalances(uint _amount) private {
        for (uint i = 0 ; i < users.length ; i ++){
            if (users[i].id == msg.sender){
                users[i].balance += _amount ; 
            }
        }
    }

    function decreaseBalances(uint _amount) private {
        for (uint i = 0 ; i < users.length ; i ++){
            if (users[i].id == msg.sender){
                users[i].balance -= _amount ; 
            }
        }
    }
}