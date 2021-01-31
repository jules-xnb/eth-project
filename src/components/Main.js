import React, { Component } from 'react'
import CT from '../token.png'

class Main extends Component {

  render() {
    return (
      <div id="content" className="mt-3">

        <form className="mb-3" onSubmit={(event) => {
            event.newRegistered()
            let name
            name = this.input.value.toString()
            this.props.register(name)
          }}>
          <div className="input-group mb-4">
            <input
              type="text"
              ref={(input) => { this.input = input }}
              className="form-control form-control-lg"
              placeholder="Your name"
              required />
            <div className="input-group-append">
              <button type="submit" className="btn btn-primary btn-block btn-lg">Register</button>
            </div>
          </div>
        </form>

        <b><p className="text-muted">User name: {this.props.userName}</p></b>
        <b><p className="text-muted">User Balance: {window.web3.utils.fromWei(this.props.userBalance, 'Ether')} CT</p></b>
        <b><p className="text-muted">User Address: {(this.props.account)}</p></b>


        <p><b>Buy Token: </b></p>
        <div className="input-group mb-4">
          <input
            type="text"
            ref={(input) => { this.input = input }}
            className="form-control form-control-lg"
            placeholder="How many do you want ?"
            required />
            <div className="input-group-append">
              <button
                type="submit"
                className="btn btn-primary btn-block btn-lg"
                onClick={(event) => {
                  event.newBuy()
                  this.props.buyToken()
                }}>
                  BUY
              </button>
            </div>
          </div>

          <p><b>Sell Token: </b></p>
        <div className="input-group mb-4">
          <input
            type="text"
            ref={(input) => { this.input = input }}
            className="form-control form-control-lg"
            placeholder="How many do you want ?"
            required />
            <div className="input-group-append">
              <button
                type="submit"
                className="btn btn-primary btn-block btn-lg"
                onClick={(event) => {
                  event.newSell()
                  this.props.sellToken()
                }}>
                  Sell
              </button>
            </div>
          </div>

        {/* <table className="table table-borderless text-muted text-center">
          <thead>
            <tr>
              <th scope="col">User Balance</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>{window.web3.utils.fromWei(this.props.userBalance, 'Ether')} CT</td>
            </tr>
          </tbody>
        </table> */}

        <div className="card mb-4" >

          <div className="card-body">

            <form className="mb-3" onSubmit={(event) => {
                event.preventDefault()
                let amount
                amount = this.input.value.toString()
                amount = window.web3.utils.toWei(amount, 'Ether')
                this.props.stakeTokens(amount)
              }}>
              <div>
                <label className="float-left"><b>Stake Tokens</b></label>
                <span className="float-right text-muted">
                  Balance: {window.web3.utils.fromWei(this.props.userBalance, 'Ether')}
                </span>
              </div>
              <div className="input-group mb-4">
                <input
                  type="text"
                  ref={(input) => { this.input = input }}
                  className="form-control form-control-lg"
                  placeholder="0"
                  required />
                <div className="input-group-append">
                  <div className="input-group-text">
                    <img src={CT} height='32' alt=""/>
                    &nbsp;&nbsp;&nbsp; CT
                  </div>
                </div>
              </div>
              <button type="submit" className="btn btn-primary btn-block btn-lg">STAKE!</button>
            </form>
            <button
              type="submit"
              className="btn btn-link btn-block btn-sm"
              onClick={(event) => {
                event.preventDefault()
                this.props.unstakeTokens()
              }}>
                UN-STAKE...
              </button>
          </div>
        </div>

      </div>
    );
  }
}

export default Main;
