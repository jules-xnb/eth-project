pragma solidity ^0.5.16;

import "./token.sol" ; 

// SPDX-License-Identifier: MIT

contract Casino is Token {
    string public nameCasino ; // Nom du casino
    uint public fees ; // frais prélevés lors d'un jeu 
    uint private nonce = 1 ; // nonce pour la fonction random 

    // Constructeur 
    constructor (string memory _nameCasino, uint _fees, string memory _nameToken, string memory _symbolToken, uint _multiplyToken ) public {
        nameCasino = _nameCasino ; 
        fees = _fees ; 
        Token.nameToken = _nameToken ; 
        Token.symbolToken = _symbolToken ;  
        Token.multiplyToken = _multiplyToken ; 
    }

    // Event 
    event newWin(uint _amount);
    event newLoose(uint _amount); 
    event newAddLiquidity(uint _totalSupply, uint _availableSupply) ; 
    event newWithdrawLiquidity(uint _totalSupply, uint _availableSupply) ;
    event newRegistered(string _name); 
    event newBuy(uint _amount);
    event newSell(uint _amount); 
    event newWithdrawBenefit(uint _amount); 

    // Appellable uniquement par le créateur du casino 
    // Fonction pour ajouter de la liquidité au casino (ajouter des jetons au casino) 
    // Chaque token est backé par de l'ether
    // Application d'un coefficient multiplicateur défini par la créateur du casino pour avoir une mise plus petite
    function addLiquidity() payable external onlyOwner(){
        Token.totalSupply += msg.value * Token.multiplyToken;
        Token.availableSupply += msg.value * Token.multiplyToken; 
        emit newAddLiquidity(Token.totalSupply, Token.availableSupply);
    }

    // Fonction pour retirer de la liquidité (retirer des jetons du casino et récupérer de l'ether)
    function withdrawLiquidity(uint _amount) external onlyOwner(){
        require (_amount <= availableSupply, "Il n'y a pas assez de tokens disponibles") ; 
        Token.totalSupply -= _amount ; 
        Token.availableSupply -= _amount ;
        msg.sender.transfer(_amount/Token.multiplyToken );
        Token.updateAvailableSupply();
        emit newWithdrawLiquidity( Token.totalSupply, Token.availableSupply) ;
    }

    // Fonction pour retirer les bénéfices, c'est à dire les eth en trop sur le smart contract par rapport aux jetons en circulation
    function withdrawBenefit() external onlyOwner(){
        msg.sender.transfer(address(this).balance - Token.totalSupply / Token.multiplyToken);
        emit newWithdrawBenefit(address(this).balance - Token.totalSupply / Token.multiplyToken);
    }


    // Fonction pour s'enregistrer en tant que joueur dans le casino
    // Obligatoire avant de procéder avant tout autre opération 
    function register(string memory _name) public {
        require (user[msg.sender].registered == false, "Vous etes deja connu du Casino"); 
        user[msg.sender].name = _name ; 
        user[msg.sender].registered = true ; 
        users.push(User(0, _name, true, msg.sender)); 
        emit newRegistered(_name);
    }

    // Fonction pour modifier son nom en cas d'erreur
    function modifyMyName(string memory _name) public {
        require (user[msg.sender].registered == true, "Enregistrez vous d abord"); 
        user[msg.sender].name = _name ; 
        emit newRegistered(_name);
    }

    // Fonction pour acheter des tokens
    // Maximum défini par le nombre de tokens en circulation
    function buyToken() payable external isRegistered() onlyHaveToken(msg.value){
        user[msg.sender].balance += msg.value * Token.multiplyToken ; 
        increaseBalances(msg.value * Token.multiplyToken);
        Token.updateAvailableSupply();
        emit newBuy(user[msg.sender].balance);
    }

    // Fonction pour vendre ses tokens 
    // Vérificattion de la balance de l'utilisateur avant la vente 
    // Les tokens vendus sont de nouveau disponible en circulation 
    function sellToken(uint _amount) external isRegistered() {
        require (user[msg.sender].balance >= _amount, "pas assez de token pour le retrait"); 
        user[msg.sender].balance -= _amount ; 
        decreaseBalances(_amount);
        msg.sender.transfer(_amount/Token.multiplyToken ); 
        Token.updateAvailableSupply(); 
        emit newSell(user[msg.sender].balance);
    }

    // Fonction pour payer les frais de transaction lors d'un jeu 
    function payFees() internal {
        user[msg.sender].balance -= fees ;
        decreaseBalances(fees); 
        availableSupply += fees; 
        Token.updateAvailableSupply();
    }

    // Fonction pour générer un nombre aléatoire 
    function random(uint _n) private returns (uint) {
        uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce, _n))) % _n;
        nonce += randomnumber;        
        return randomnumber;
    }

    // Jeu pile ou face 
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
        if (user[msg.sender].balance != 0){
            payFees();
        }
         
    }

    // Jeu roulette 
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
        if (user[msg.sender].balance != 0){
            payFees();
        } 
    }


    // Fonctions pour mettre à jour le tableau utilisateurs
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