pragma solidity ^0.5.16;

import "./ownable.sol" ; 
import "./user.sol" ; 

contract Token is UserContract, Ownable {
    string public nameToken; // Nom du Token 
    string public symbolToken; // Symbol du Token 
    uint public totalSupply ; // Quantité de tokens total 
    uint public availableSupply ; // Quantité disponible à l'achat ou pour miser 
    uint public multiplyToken ; // Multiplicateur pour avoir une mise plus petite 

    // Modifier qui permet de vérifier que le casino dispose des fonds pour fournir des tokens ou payer un gain 
    modifier onlyHaveToken(uint _amount) {
        require(availableSupply >= _amount * multiplyToken, "Le casino n'a pas assez de fonds pour cette transaction");
        _;
    }

    // Fonction qui permet de mettre à jour la la quantité de tokens disponibles
    function updateAvailableSupply() internal {
        uint total = 0 ; 
        for (uint i = 0 ; i < users.length ; i ++){
            total += users[i].balance ; 
        }
        availableSupply = totalSupply - total ; 
    }

    
}
   
   
   
