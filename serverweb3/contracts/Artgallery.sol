// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ArtBlock is ERC20 {
    uint256 public constant Y = 1; // Y amount of ABX tokens
    uint256 public constant Z = 5; // Z amount of community native tokens
    uint256 public id=0;
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
    mapping(uint256 => Product[]) public prod;
    mapping(address => mapping(uint256 => Vote[])) public votes;
    
    //mapping(uint256 => uint256) public productTokens;

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
        prod[id].push( 
            Product(title, description, tokenId, Z, isExclusive, false)
            );
           id++; 
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
             uint256 tokenId = totalSupply() + 1;
            _mint(msg.sender, tokenId);
        

        } else {
            // Transfer staked tokens to community reserve
        }
        


    }
     struct Auction {
        uint256 startPrice;
        uint256 priceDecrement;
        uint256 minPrice;
        uint256 startTime;
        uint256 endTime;
        Product product;
        address highestBidder;
        uint256 highestBid;
    }
     mapping(uint256 => Auction) public auctions;
     

       function startAuction(uint256 productId, uint256 startPrice, uint256 priceDecrement, uint256 minPrice, uint256 duration)
        public
    {
        require(prod[productId][0].isExclusive, "Only exclusive products can be auctioned");
        require(prod[productId][0].isApproved, "Product must be approved");

        auctions[productId] = Auction(
            startPrice,
            priceDecrement,
            minPrice,
            block.timestamp,
            block.timestamp + duration,
            prod[productId][0],
            address(0),
            0
        );
    }
    
    function getCurrentPrice(uint256 auctionId) public view returns (uint256) {
        Auction memory auction = auctions[auctionId];
        uint256 elapsedTime = block.timestamp - auction.startTime;
        uint256 priceDrop = (elapsedTime / 1 minutes) * auction.priceDecrement;
        uint256 currentPrice = auction.startPrice - priceDrop;
        return currentPrice >= auction.minPrice ? currentPrice : auction.minPrice;
    }
     function bid(uint256 auctionId) public payable {
        Auction storage auction = auctions[auctionId];
        uint256 currentPrice = getCurrentPrice(auctionId);
        require(msg.value >= currentPrice, "Bid must be at least the current price");
        require(block.timestamp <= auction.endTime, "Auction has already ended");

        if (auction.highestBidder != address(0)) {
            payable(auction.highestBidder).transfer(auction.highestBid);
        }

        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
    }
     function endAuction(uint256 auctionId) public view {
        Auction storage auction = auctions[auctionId];
        require(block.timestamp > auction.endTime, "Auction has not yet ended");

        // Transfer the product to the highest bidder
        // Transfer the highest bid to the product creator
    }


}