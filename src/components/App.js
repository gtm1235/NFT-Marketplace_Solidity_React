import React, { Component } from "react";
import Web3 from 'web3';
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from '../abis/KryptoBird.json';
//import { ThemeProvider } from "react-bootstrap";

class App extends Component {

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }

    //detect metamask/ethereum provider
    async loadWeb3() {
        const provider = await detectEthereumProvider();


        // modern browsers
        if (provider) {
            console.log("Ethereum Wallet is connected");
            window.web3 = new Web3(provider);

        } else {
            console.log('no ethereum wallet detected');
        }
    }



    async loadBlockchainData() {
        const web3 = window.web3;
        const accounts = await web3.eth.getAccounts();
        this.setState({ account: accounts });

        const networkId = await web3.eth.net.getId();
        const networkData = await KryptoBird.networks[networkId]

        if (networkData) {
            const abi = await KryptoBird.abi;
            const address = await networkData.address;
            var contract = new web3.eth.Contract(abi, address);
            this.setState({ contract });
            if (this.state.contract) {
                console.log("Contract ABI is loaded");
            }

            //call total supply
            var totalSupply = await contract.methods.totalSupply().call()
            this.setState({ totalSupply: totalSupply.toNumber() })

            //set array to track tokens
            for (let i = 1; i <= this.state.totalSupply; i++) {
                var KryptoBirdElement = await contract.methods.kryptoBirdz(i - 1).call();
                this.setState({
                    kryptoBirds: [...this.state.kryptoBirds, KryptoBirdElement],
                })
            }
            //console.log(this.state.kryptoBirds)
        } else {
            window.alert('Smart contract is not deployed');
        }
    }

    // with minting we are sending information and we need to specify the account
    mint = (kryptoBird) => {
        
        this.state.contract.methods.mint(kryptoBird).send({ from: this.state.account[0] })
            .once('receipt', (receipt) => {
                this.setState({
                    kryptoBirds: [...this.state.kryptoBirds, kryptoBird],
                })
            })
    }



    constructor(props) {
        super(props);
        this.state = {
            account: '',
            contract: null,
            totalSupply: 0,
            kryptoBirds: [],
        }

    }

    render() {
        return (
            <div>
                {console.log(this.state.kryptoBirds)}
                <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
                    <div className='navbar-brand col-sm-3 col-md-3 mr-0'
                        style={{ color: 'white' }}>
                        KryptoBirdz NFTs (Non-fungible tokens)
                    </div>
                    <ul className="navbar-nav px-3">
                        <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
                            <small className="text-white">
                                {this.state.account}
                            </small>
                        </li>
                    </ul>
                </nav>

                <div className='container-fluid mt-1'>
                    <div className='row'>
                        <main role='main'
                            className='col-lg-12 d-flex text-center'>
                            <div className='content mr-auto ml-auto'
                                style={{ opacity: '0.8' }}>
                                <h1 style={{ color: 'white' }}>
                                    KryptoBirdz NFT Marketplace</h1>

                                <form onSubmit={(event) => {
                                    event.preventDefault();
                                    const kryptoBird = this.kryptoBird.input.value;
                                    this.mint(kryptoBird);
                                }}>

                                    <input
                                        type='text'
                                        placeholder='File Location'
                                        className='form-control mb-1'
                                        ref={(input) => this.kryptoBird = { input }} />

                                    <input
                                        style={{ margin: '6px' }}
                                        type="submit"
                                        className='btn btn-primary btn-black'
                                        defaultValue="Mint"
                                    />

                                </form>
                            </div>
                        </main>

                    </div>
                </div>


            </div >
        )
    }
}

export default App;