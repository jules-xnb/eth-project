pragma solidity ^0.5.16;

import "./ownable.sol" ; 
import "./user.sol" ; 

contract Token is UserContract, Ownable, SafeMath {
    string public nameToken;
    string public symbolToken;
    uint public totalSupply ;
    uint public availableSupply ; 
    uint public multiplyToken ; 

    modifier onlyHaveToken(uint _amount) {
        require(availableSupply >= _amount * multiplyToken, "Le casino n'a pas assez de fonds pour cette transaction");
        _;
    }

    function updateAvailableSupply() internal {
        uint total = 0 ; 
        for (uint i = 0 ; i < users.length ; i ++){
            total += users[i].balance ; 
        }
        availableSupply = totalSupply - total ; 
    }

    
}
   
   
   