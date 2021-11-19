var chai = require('chai');
var assert = chai.assert;
//const { Item } = require('react-bootstrap/lib/Breadcrumb')

const KryptoBird = artifacts.require('./KryptoBird')

// check for chai
require('chai')
    .use(require('chai-as-promised'))
    .should()

contract('KryptoBird', (accounts) => {

    let contract;

    //before tells ourtest to run this first
    before(async () => {
        contract = await KryptoBird.deployed();
    }
    )

    //testing container - describe

    describe('deployment', async () => {
        //test samples with writing is
        it('deploys successfully', async () => {
            //contract = await KryptoBird.deployed();
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

    describe('minting', async () => {
        it('creates a new token', async () => {
            const result = await contract.mint('https...1');
            const totalSupply = await contract.totalSupply();

            //Success
            assert.equal(totalSupply, 1);
            const event = await result.logs[0].args;
            assert.equal(event._from, '0x0000000000000000000000000000000000000000', 'from the contract');
            assert.equal(event._to, accounts[0], 'to is msg.sender');

            //Failure
            await contract.mint('https...1').should.be.rejected;
        })
    })

    describe('indexing', async () => {
        it('list KryptoBirdz', async () => {
            //Mint three new tokens
            await contract.mint('https...2');
            await contract.mint('https...3');
            await contract.mint('https...4');
            const totalSupply = await contract.totalSupply();

            //Loop through lost and grab KBirdz from list
            let result = [];
            let KryptoBird;

            for (i = 1; i <= totalSupply; i++) {
                KryptoBird = await contract.kryptoBirdz(i - 1);
                await result.push(KryptoBird);
            }
            // assert that new array result == expected result
            let expected = ['https...1', 'https...2', 'https...3', 'https...4'];
            assert.equal(result.join(','), expected.join(','));
        })
    })
})