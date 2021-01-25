import Web3 from "web3";
import Casino from "./contracts/Casino.json";
import Ownable from "./contracts/Ownable.json";
import Token from "./contracts/Token.json";
import UserContract from "./contracts/UserContract.json";

const options = {
  web3: {
    block: false,
    customProvider: new Web3("ws://localhost:7545"),
  },
  contracts: [Casino, Ownable, Token, UserContract],
};

export default options;
