import React, { Component } from 'react'
import Web3 from 'web3'
import Casino from '../abis/Casino.json'
import Ownable from '../abis/Ownable.json'
import Token from '../abis/Token.json'
import UserContract from '../abis/UserContract.json'
import Navbar from './Navbar'
import Main from './Main'
import './App.css'

class App extends Component {

  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  async loadBlockchainData() {
    const web3 = window.web3

    const accounts = await web3.eth.getAccounts()
    this.setState({ account: accounts[0] })

    const networkId = await web3.eth.net.getId()

    // Load DaiToken
    // const daiTokenData = DaiToken.networks[networkId]
    // if(daiTokenData) {
    //   const daiToken = new web3.eth.Contract(DaiToken.abi, daiTokenData.address)
    //   this.setState({ daiToken })
    //   let daiTokenBalance = await daiToken.methods.balanceOf(this.state.account).call()
    //   this.setState({ daiTokenBalance: daiTokenBalance.toString() })
    // } else {
    //   window.alert('DaiToken contract not deployed to detected network.')
    // }

    //Load User
    const userData = UserContract.networks[networkId]
    if (userData) {
      const user = new web3.eth.UserContract(UserContract.abi, userData.address)
      this.setState({user})
      const userRegistered = await user.methods.getrIsRegistered().call()
      this.setState({ userRegistered: userRegistered })
      // On récupère la balance de la personne connectée
      let userBalance = await user.eth.getBalance(this.account)
      userBalance = web3.utils.fromWei(userBalance, 'ether')
      this.setState({ userBalance: userBalance })
      let userName = await user.methods.getName().call()
      this.setState({ userName: userName })
    } else {
      window.alert('User contract not deployed to detected network.')
    }



    this.setState({ loading: false })
  }

  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  }

  // stakeTokens = (amount) => {
  //   this.setState({ loading: true })
  //   this.state.daiToken.methods.approve(this.state.tokenFarm._address, amount).send({ from: this.state.account }).on('transactionHash', (hash) => {
  //     this.state.tokenFarm.methods.stakeTokens(amount).send({ from: this.state.account }).on('transactionHash', (hash) => {
  //       this.setState({ loading: false })
  //     })
  //   })
  // }

  // unstakeTokens = (amount) => {
  //   this.setState({ loading: true })
  //   this.state.tokenFarm.methods.unstakeTokens().send({ from: this.state.account }).on('transactionHash', (hash) => {
  //     this.setState({ loading: false })
  //   })
  // }

  constructor(props) {
    super(props)
    this.state = {
      account: '0x0',
      userRegistered: {},
      userBalance: '0',
      loading: true
      // daiToken: {},
      // daiTokenBalance: '0',
      // stakingBalance: '0',
    }
  }

  render() {
    let content
    
    if(this.state.loading) {
      content = <p id="loader" className="text-center">Loading...</p>
    } else {
      content = <Main
        userRegistered={this.state.userRegistered}
        userBalance={this.state.userBalance}
        userName={this.state.userName}
        // daiTokenBalance={this.state.daiTokenBalance}
        // stakingBalance={this.state.stakingBalance}
        // stakeTokens={this.stakeTokens}
        // unstakeTokens={this.unstakeTokens}
      />
    }

    return (
      <div>
        <Navbar account={this.state.account} />
        <div className="container-fluid mt-5">
          <div className="row">
            <main role="main" className="col-lg-12 ml-auto mr-auto" style={{ maxWidth: '600px' }}>
              <div className="content mr-auto ml-auto">
                <a
                  target="_blank"
                  rel="noopener noreferrer"
                >
                </a>

                {content}

              </div>
            </main>
          </div>
        </div>
      </div>
    );
  }
}

export default App;