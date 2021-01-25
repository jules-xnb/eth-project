import Web3 from "web3";
import Casino from "./contracts/Casino.json";

const options = {
  web3: {
    block: false,
    customProvider: new Web3("ws://localhost:7545"),
  },
  contracts: [Casino],
};

export default options;
