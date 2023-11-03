// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ArtblockToken is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }

    function buyTokens(uint256 etherAmount) public payable {
        // Check that the correct amount of ether has been sent
        require(msg.value == etherAmount, "Incorrect amount of ether sent");

        // Calculate the amount of tokens to be minted
        uint256 tokenAmount = etherAmount * 100; // Assuming 1 ether = 100 tokens

        // Mint the tokens and assign them to the sender
        _mint(msg.sender, tokenAmount);
    }
}

contract Community {
    ERC20 public artblockToken;
    string public title;
    string public description;
    address public creator;
    uint256 public tokenAmount;

    constructor(
        ERC20 _artblockToken,
        string memory _title,
        string memory _description,
        uint256 _tokenAmount
    ) {
        artblockToken = _artblockToken;
        title = _title;
        description = _description;
        creator = msg.sender;
        tokenAmount = _tokenAmount;

        // Approve the Community contract to transfer the ArtblockToken
        artblockToken.approve(address(this), tokenAmount);

        // Transfer the tokens from the creator to this contract and burn them
        //artblockToken.transferFrom(msg.sender, address(this), tokenAmount);
    }

}

contract CommunityToken is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }
}

contract TokenExchange {
    ERC20 public communityToken;
    ERC20 public abxToken;
    uint256 public exchangeRate;

    constructor(
        ERC20 _communityToken,
        ERC20 _abxToken,
        uint256 _exchangeRate
    ) {
        communityToken = _communityToken;
        abxToken = _abxToken;
        exchangeRate = _exchangeRate;
    }

    function exchangeTokens(uint256 tokenAmount) public {
        // Transfer the community tokens from the sender to this contract
        communityToken.transferFrom(msg.sender, address(this), tokenAmount);

        // Calculate the amount of ABX tokens to be transferred
        uint256 abxAmount = tokenAmount * exchangeRate;

        // Transfer the ABX tokens from this contract to the sender
        abxToken.transfer(msg.sender, abxAmount);
    }
}
