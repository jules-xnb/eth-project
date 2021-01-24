const Casino = artifacts.require("Casino");
const Ownable = artifacts.require("Ownable");
const Token = artifacts.require("Token");
const UserContract = artifacts.require("UserContract");
const SafeMath = artifacts.require("SafeMath");

module.exports = function (deployer) {
  deployer.deploy(Casino, "Mon Casino", 100, "CasinoToken", "CT", 1000);
  deployer.deploy(Ownable);
  deployer.deploy(Token);
  deployer.deploy(UserContract); 
};








