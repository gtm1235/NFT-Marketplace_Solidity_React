var chai = require('chai'); 
var assert = chai.assert;
//const { Item } = require('react-bootstrap/lib/Breadcrumb')

const KryptoBird = artifacts.require('./Kryptobird')

// check for chai
require('chai')
    .use(require('chai-as-promised'))
    .should()

contract('KryptoBird',  (accounts) => {
    let contract = KryptoBird.deployed();

    //testing container - describe

    describe('deployment', async () => {
        //test samples with writing is
        it('deploys successfully', async () => {
            contract = await KryptoBird.deployed();
            const address = contract.address;
            assert.notEqual(address, '');
            assert.isNotNull(address);
            assert.notEqual(address, undefined);
            assert.notEqual(address, 0x0);
        })
        
        it('Name is Correct', async () => {
            //contract = await KryptoBird.deployed();
            const name = await contract.name();
            assert.equal(name, 'KryptoBird');
            
        })

        it('Symbol is Correct', async () => {
            //contract = await KryptoBird.deployed();
            const symbol = await contract.symbol();
            assert.equal(symbol, 'KBIRDZ');
            
        })
        
    })
})