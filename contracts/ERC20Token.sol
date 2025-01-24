// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

interface ERC20 {
    function getSupply() external pure returns (uint256 supply);

    function getBalance(address addr) external view returns (uint256 balance);

    function send(address addrDst, uint256 sendValue) external returns (bool error);

    function transfer(address addrSrc, address addrDst, uint256 transferValue) external
        returns (bool error);

    function approve(address thirdParty, uint256 value) external returns (bool error);

    function limit(address addrSpender, address addrSrc) external view returns (uint256 limitValue);

    event Transfer(address indexed addrSrc, address indexed addrDst, uint256 transferValue);
    event Approval(address indexed addrSrc, address indexed thirdParty, uint256 value);
}

contract ERC20Token is ERC20 {
    // Tokens available
    uint256 private constant tokens = 8000000000000000000000000;

    // Each address has its own balance
    mapping(address => uint256) private addrBalance;

    // The limit of each address can spend
    mapping(address => mapping(address => uint256)) private limits;

    // Assign initial tokens to the address that connected with the contract
    constructor() {
        addrBalance[msg.sender] = tokens;
    }

    // The amount of tokens available
    function getTokens() public pure override returns (uint256) {
        return tokens;
    }

    // Get the balance that corresponds to an address
    function getBalance(address addr) public view override returns (uint256) {
        return addrBalance[addr];
    }

    // Send tokens from the address that is connected with the contract to
    // a specific address. The amount of tokens to send has to be positive,
    // and the address that is connected with the contract has the enough supply.
    // Trigger Transfer event upon successful transfer.
    function send(address addrDst, uint256 sendValue) public override returns (bool) {
        if (sendValue > 0 && sendValue <= getBalance(msg.sender)) {
            addrBalance[msg.sender] -= sendValue;
            addrBalance[addrDst] += sendValue;
            emit Transfer(msg.sender, addrDst, sendValue);
            return false;
        }
        return true;
    }

    // Transfer tokens with limited blance of thied-party from the available supply to
    // a specific address. The amount of tokens to send has to be positive, and the
    // blance has the enough supply. Trigger Transfer event upon successful transfer.
    function transfer(address addrSrc, address addrDst, uint256 transferValue) public override
    returns (bool) {
        if (transferValue > 0 && limits[addrSrc][msg.sender] > 0 &&
            limits[addrSrc][msg.sender] >= transferValue) {
            addrBalance[addrSrc] -= transferValue;
            addrBalance[addrDst] += transferValue;
            emit Transfer(addrSrc, addrDst, transferValue);
            return false;
        }
        return true;
    }

    // Approve a third party to send a certain amount of tokens
    function approve(address thirdParty, uint256 value) external override returns (bool) {
        limits[msg.sender][thirdParty] = value;
        emit Approval(msg.sender, thirdParty, value);
        return false;
    }

    // Return the limit of an address to send from the available blance
    function limit(address addrSpender, address addrSrc) external view returns (uint256 limitValue) {
        return limits[addrSpender][addrSrc];
    }
}
