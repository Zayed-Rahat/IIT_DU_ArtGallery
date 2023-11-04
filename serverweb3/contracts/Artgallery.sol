// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract CommunityToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 10000 * (10**uint256(decimals())));
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    // function burn(address account, uint256 value) public {
    //     if (account == address(0)) {
    //         revert ERC20InvalidSender(address(0));
    //     }
    //     _update(account, address(0), value);
    // }
}

contract ArtBlock is ERC20 {
    uint256 public constant Y = 1; // Y amount of ABX tokens
    uint256 public id = 0;
    CommunityToken public communityToken;
    
    struct Community {
        string title;
        string description;
        uint256 tokenId;
        uint256 requiredTokens; 
    }

    struct Product {
        string title;
        string description;
        string image;
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
    mapping(address => bool) public isTokenBuyer;
    mapping(address => uint256) public buytoken;
    mapping(address => bool) public isCreator;
    mapping(address => bool) public boughtNativeToken;
    mapping(address => uint256) public boughtTokenAmount;

    //mapping(uint256 => uint256) public productTokens;

    constructor() ERC20("ArtBlock", "ABX") {}

    //Function to buy ABX token 

    function buyTokens(uint256 amount) public payable {
        require(msg.value == amount * 1 ether, "Incorrect Ether value");
        buytoken[msg.sender] = msg.value;
        isTokenBuyer[msg.sender] = true;
        _mint(msg.sender, amount);
    }

      //Function to bCreate community
    function createCommunity(
        string memory title,
        string memory description,
        uint256 requiredTokens
    ) public {
        require(
            isTokenBuyer[msg.sender],
            "Please Buy ABX token to create Community"
        );
        require(balanceOf(msg.sender) >= Y, "Not enough ABX tokens");
        _burn(msg.sender, Y);
        uint256 tokenId = totalSupply();
        _mint(msg.sender, tokenId);
        communities[msg.sender].push(
            Community(title, description, tokenId, requiredTokens)
        );
      
        isCreator[msg.sender] = true;
    }

        //Function to get the community list
    function getCommunities() public view returns (Community[] memory) {
        return communities[msg.sender];
    }

    //event Debug(string message, uint256 value);

     //function tp buy Native token for a community

    function buynativeToken(uint256 amount) public payable {
  
        require(msg.value == amount * 1 ether, "Incorrect Ether value");

        require(isTokenBuyer[msg.sender], "Buy first ABX token");
        communityToken.mint(msg.sender, amount);
        boughtTokenAmount[msg.sender] = amount;
        boughtNativeToken[msg.sender] = true;
    }
    //function to publish product
    function publishProduct(
        string memory title,
        string memory description,
        string memory image,
        bool isExclusive
    ) public {
        require(
            boughtNativeToken[msg.sender],
            "You have to buy Native Token First"
        );
        Community memory community = communities[msg.sender][0]; 
        require(
            communityToken.balanceOf(msg.sender) >= community.requiredTokens,
            "Not enough community native tokens"
        );
        // communityToken.burn(msg.sender, community.requiredTokens);
        uint256 tokenId = totalSupply();
        _mint(msg.sender, tokenId);
        products[msg.sender].push(
            Product(
                title,
                description,
                image,                
                tokenId,
                community.requiredTokens,
                isExclusive,
                false
            )
        );
        prod[id].push(
            Product(
                title,
                description,
                image,  
                tokenId,
                community.requiredTokens,
                isExclusive,
                false
            )
        );
        id++;
    }
     //functions to get products
    function getProducts() public view returns (Product[] memory) {
        return products[msg.sender];
    }
      //functions to vote on product 
    function voteOnProduct(
        address creator,
        uint256 productId,
        bool isUpvote
    ) public {
        require(
            !isCreator[msg.sender],
            "Creators can't vote on their own product"
        );
        require(
            boughtNativeToken[msg.sender],
            "You have to buy Community Token first"
        );
        Community memory community = communities[creator][productId]; // Get the community of the product
        require(
            communityToken.balanceOf(msg.sender) >= community.requiredTokens,
            "Not enough community native tokens to vote"
        );
        uint256 weight = communityToken.balanceOf(msg.sender);
        votes[creator][productId].push(Vote(isUpvote, weight));
    }
       //functions to get totalVote
    function getVotes(address creator, uint256 productId)
        public
        view
        returns (Vote[] memory)
    {
        return votes[creator][productId];
    }
     //functions to finalize vote
    function finalizeVotes(address creator, uint256 productId) public {
        require(isCreator[msg.sender], "only creators can finalize the vote ");
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
            // IERC20(stakedTokenAddress).transferFrom(staker, communityReserveAddress, amount);
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
     //funciton to start the auction
    function startAuction(
        uint256 productId,
        uint256 startPrice,
        uint256 priceDecrement,
        uint256 minPrice,
        uint256 duration
    ) public {
        require(isCreator[msg.sender], "Only creator can call this function");
        require(
            prod[productId][0].isExclusive,
            "Only exclusive products can be auctioned"
        );
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
          //function to get current price
    function getCurrentPrice(uint256 auctionId) public view returns (uint256) {
        Auction memory auction = auctions[auctionId];
        uint256 elapsedTime = block.timestamp - auction.startTime;
        uint256 priceDrop = (elapsedTime / 1 minutes) * auction.priceDecrement;
        uint256 currentPrice = auction.startPrice - priceDrop;
        return
            currentPrice >= auction.minPrice ? currentPrice : auction.minPrice;
    }
       
          //function to bid
    function bid(uint256 auctionId) public payable {
        Auction storage auction = auctions[auctionId];
        uint256 currentPrice = getCurrentPrice(auctionId);
        require(
            msg.value >= currentPrice,
            "Bid must be at least the current price"
        );
        require(
            block.timestamp <= auction.endTime,
            "Auction has already ended"
        );

        if (auction.highestBidder != address(0)) {
            payable(auction.highestBidder).transfer(auction.highestBid);
        }

        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
    }
    
       
          //function to endAuction

    function endAuction(uint256 auctionId) public view {
        Auction storage auction = auctions[auctionId];
        require(isCreator[msg.sender], "Only creator can call this function");
        require(block.timestamp > auction.endTime, "Auction has not yet ended");

        // Transfer the product to the highest bidder
        // address highestBidder = auction.highestBidder;
        // Product memory product = auction.product;
        // Transfer the highest bid to the product creator
    }


}