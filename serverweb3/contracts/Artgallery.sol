// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ArtBlock is ERC20 {
    uint256 public constant Y = 1; // Y amount of ABX tokens
    uint256 public constant Z = 5; // Z amount of community native tokens

    struct Community {
        string title;
        string description;
        uint256 tokenId;
    }

    struct Product {
        string title;
        string description;
        uint256 tokenId;
        uint256 stakeAmount;
        bool isExclusive;
        bool isApproved;
    }

    struct Vote {
        bool isUpvote;
        uint256 weight;
    }

    mapping(address => Community[]) public communities;
    mapping(address => Product[]) public products;
    mapping(address => mapping(uint256 => Vote[])) public votes;

    constructor() ERC20("ArtBlock", "ABX") {}

    function buyTokens(uint256 amount) public payable {
        require(msg.value == amount * 1 ether, "Incorrect Ether value");
        _mint(msg.sender, amount);
    }

    function createCommunity(string memory title, string memory description)
        public
    {
        require(balanceOf(msg.sender) >= Y, "Not enough ABX tokens");
        _burn(msg.sender, Y);
        uint256 tokenId = totalSupply();
        _mint(msg.sender, tokenId);
        communities[msg.sender].push(Community(title, description, tokenId));
    }

    function publishProduct(
        string memory title,
        string memory description,
        bool isExclusive
    ) public {
        require(
            balanceOf(msg.sender) >= Z,
            "Not enough community native tokens"
        );
        _burn(msg.sender, Z);
        uint256 tokenId = totalSupply();
        _mint(msg.sender, tokenId);
        products[msg.sender].push(
            Product(title, description, tokenId, Z, isExclusive, false)
        );
    }

    function voteOnProduct(
        address creator,
        uint256 productId,
        bool isUpvote
    ) public {
        uint256 weight = balanceOf(msg.sender);
        votes[creator][productId].push(Vote(isUpvote, weight));
    }

    function finalizeVotes(address creator, uint256 productId) public {
        uint256 totalWeight = 0;
        uint256 upvoteWeight = 0;
        for (uint256 i = 0; i < votes[creator][productId].length; i++) {
            totalWeight += votes[creator][productId][i].weight;
            if (votes[creator][productId][i].isUpvote) {
                upvoteWeight += votes[creator][productId][i].weight;
            }
        }
        if (upvoteWeight > totalWeight / 2) {
            products[creator][productId].isApproved = true;
            // Mint NFT
        } else {
            // Transfer staked tokens to community reserve
        }
    }
}
