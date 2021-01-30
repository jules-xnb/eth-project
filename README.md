# TP ESGI DEFI

Documentation :  
Solidity : https://solidity.readthedocs.io/en/v0.5.15/  
Truffle & Ganache : https://www.trufflesuite.com/

## About

In this TP, you are going to build a staking farm that will allows users to stake a stable coin like DAI and get rewarded with your own farm token.

## Part 1 : Create and compile the farm

1- To simplify the development process, we are going to create our own tokens instead of using existing tokens. The tokens have already been create for you as you have already created such token in last year's ESGI TP about creating an ERC20 token. Checkout `/src/contracts/DaiToken.sol` representing a mock stable coin such as DAI, and `/src/contracts/DappToken.sol` representing your farm token. These implements a simplified ERC20 standard with transfer and approval functions.

2- Create a new contract `TokenFarm.sol` contract. For now, just implement a state variable `name` to `Dapp Token Farm`.

3- You first task is to compile `TokenFarm.sol` with [Truffle](https://www.trufflesuite.com/truffle) and deploy it on [Ganache](https://www.trufflesuite.com/ganache). Don't hesitate to check last year's ESGI TP if you forgot how to do that. Compile and deploy this contract.

4- In Ganache, make sure the smart contract appear under the `CONTRACTS` tab. If not, you must link Ganache to your Truffle contracts folder.

## Part 2 : Deploy the tokens and link them to your farm

1- Compile and deploy the Dai token and the Dapp token. How many tokens are created? Who owns them?

2- In `TokenFarm.sol`, import and instanciate your Dai token and your Dapp token in the farm constructor.

3- In your migrations, transfer all Dapp tokens to the TokenFarm contract, as we want the farm to mane the Dapp tokens and be able te reward stakers.

4- Transfer 100 Dai tokens to an investor at address `accounts[1]`

5- Create `TokenFarm.test.js` in the `test` folder in order to test our smart contracts. Import the smart contracts

6- In the `before` section, instanciate the contracts then

- Transfer all Dapp tokens to the farm
- Send 100 tokens to an investor

7- Write a test that checks that our Dai token instance has a `name`.

8- Write a test that checks that our Dapp token instance has a `name`.

9- Write a test that checks that our Token Farm instance has a `name`.

10- Check our Token Farm has a balance of 1 millions Dapp tokens.

## Part 3 : Stake tokens

1- In `TokenFarm.sol`, create a array `stakers` that will hold the public addresses of all you stakers. In addition, create 3 mappings :

- `stakingBalance` which links the staker address to his Dai tokens balance
- `hasStaked` which links the staker address to a boolean representing if the staker has staked
- `isStaking` which links the staker address to a boolean representing if the staker is currently staking

2- Implement a `stakeTokens` function which will receive an certain amount of Dai tokens and stake them in our farm contract. For this :

- Transfer the amount of Dai tokens sent to the function to farm contract
- Update the staking balance of that user
- Add user to stakers array _only_ if they haven't staked already
- Update staking status

3- In `TokenFarm.test.js` add new test that :

- Check investor balance before staking
- Check investor balance after staking, and his stake in the farm

## Part 4 : Issue tokens

1- In `TokenFarm.sol` create the function `issueTokens` that for each stakers in our farm will reward/send them an amount of Dapp tokens equivalent to their current Dai staking balance.

2- Create the function `unstakeTokens` that allow a user to withdraw his Dai tokens. To do this :

- Fetch user staking balance
- Require amount greater than 0
- Transfer Dai tokens from the contract to the user
- Reset user staking balance
- Update user staking status

3- In `TokenFarm.test.js` complete your tests with :

- Check balances after calling `issueTokens`
- Ensure that only onwer can issue tokens
- Check investor Dai and Dapp balance after unstaking, and his stake in the farm

4- Issuing tokens is not a function that we want expose to the frontend, so to call this function, we can create a [custom truffle script](https://www.trufflesuite.com/docs/truffle/getting-started/writing-external-scripts). In `scripts`, create `issue-token.js` that will calls `issueTokens`. Execute the script. Check balances on Ganache.

## Part 5 : Frontend

1- In `App.js` import web3 and the abis of all 3 smart contracts

2- Create and implement the react `constructor` that will store the variables in the react state :

```js
account: '0x0', // Public address of the user
daiToken: {}, // Web3 instance of the Dai smart contract
dappToken: {}, // Web3 instance of the Dapp smart contract
tokenFarm: {}, // Web3 instance of the Token Farm
daiTokenBalance: '0', // Your Dai token balance
dappTokenBalance: '0', // Your Dapp token balance
stakingBalance: '0', // Your staking balance
loading: true // Show loader while we wait
```

3- Create and implement the react `componentWillMount` that will :

- load web3
- fetch and set up all the state variables from point 2.

## Part 6 : Finishing project

1- In `App.js` render function, display `daiTokenBalance`, `dappTokenBalance` and `stakingBalance`.


2- Implement a function `stakeTokens` that will call the `stakeTokens` fonction from the smart contract.Notice that you will first need to all the farm contract to manage the user's Dai tokens.

2- Do the same for `unstakeTokens`.

3- Display buttons to call `stakeTokens` and `unstakeTokens`. Notice that your balances should change.

# Congratulation. You have now coded your own yield farm!

Bonus questions :

1- Deploy your smart contracts to the Rinkeby or Ropsten testnet. 

2- How much gas does it cost to stake and unstake tokens ?