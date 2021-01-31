pragma solidity ^0.5.16;

contract UserContract {

    struct User {
        uint balance; // Balance de tokens 
        string name ; // Nom de l'utilisateur 
        bool registered ; // Enregistré ou non 
        address id ; // Identifiant correspondant à son addresse 
    }

    // Tableau d'utilisteur pour calculer les tokens disponibles
    User[] users ; 

    mapping (address => User) internal user ;

    // Modifier pour vérifier qu'un utilistaeur est inscrit avant de jouer 
    modifier isRegistered () {
        require (user[msg.sender].registered == true ) ; 
        _; 
    }

    // Fonctions pour récupérer la balance et le nom d'un utilisateur 
    function getBalance () external view returns (uint) {
        return user[msg.sender].balance ; 
    }
    
    function getName () external view returns ( string memory) {
        return user[msg.sender].name ; 
    }
    
    function getName () external view returns (bool) {
        return user[msg.sender].registered ; 
    }

}
