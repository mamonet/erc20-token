# ERC20 Token

`ERC20 Token` is a contract example that follows the ERC-20 standard.

ERC-20 Token offers functionality for
- Check the amount of tokens available
- Get the balance of a specific address
- Send tokens from the address that is connected with the contract to a specific address
- Transfer tokens with limited blance of thied-party from the available supply to a specific address
- Approve a third party to send a certain amount of tokens
- Check the limit of an address to send from the available blance

The contract also provides events for specific functionalities
- Transfer event (Triggered when transfering tokens)
- Approval event (Triggered when allowing others to transfer tokens on behalf of the token holder)

## Testing

The test module checks the following operations
- Checking the initial tokens
- Checking the blance of owener, initially it is supposed to be equal to the initial tokens
- Checking the result of transfer from the available balance
- Checking the result of transfer from the available balance using a third party limit

To run the test module, first install the package dependencies by running

```sh
$ npm install
```

Then, run the test by the following command

```sh
$ npx hardhat test
```

## License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
