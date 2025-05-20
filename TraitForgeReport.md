## Invalid Token Generation Validation in NFT Minting

Learn about proper generation tracking and validation in NFT smart contracts, focusing on a critical vulnerability where total token count was used instead of generation-specific counts

Severity - High

## Introduction

A critical vulnerability in NFT minting where the contract incorrectly uses total token count instead of generation-specific counts for validation,potentially preventing minting in subsequent generations.

## Key Concepts
- Token Generations - Different series or batches of NFTs released over time , each with its own maximum supply.
- Token Counters - Variable tracking the number of minted tokens , which can be total or generation-specific
- Mint Price Calculation - Dynamic pricing mechanism that may vary based on supply and demand
- Budget based Minting - allowing users to mint multiple tokens in a single transaction based on available funds.

## Reported Vulnerability Details 
THe vulnerability exists in the mintWithBudget function where _tokenIds (tracking total tokens ever minted ) is compared against maxTokenPerGen (maximum tokens per generation).This creates an issue where minting becomes impossible after the first generation since _tokenIds will exceed maxTokensPerGen , even though new generations should allow fresh minting up to their individual Limits

## Potential Impact
- Minting Becomes impossible for all generations after the first
- Loss of functionality for the entire NFT Collections
- Potential economic impact on the project and its participants

## How to Identify This Sort of Vulnerability 
- Review counter variables and their context
- Check if generation-specific logic uses appropriate generation-specific Variables
- Analyze loops and conditions involving counters
- Test multi-generation scenarios
- Verify counter reset mechanism between generations

## Recommended Mitigations Steps
Replace the total token counter with generation-specific counting:

```diff
- while (budgetLeft >= mintPrice && _tokenIds < maxTokensPerGen) {
+ while (budgetLeft >= mintPrice && generationMintCounts[currentGeneration] <= maxTokensPerGen) {
```
## Code Comparison
```solidity
// Vulnerable Code
/// NOTE - We also not increasing the _tokenIds
while (budgetLeft >= mintPrice && _tokenIds < maxTokensPerGen) {  /// NOTE - must use the generation specific TokensIDs
    _mintInternal(msg.sender, mintPrice);
    amountMinted++;
    budgetLeft -= mintPrice;
}

// Fixed Code
while (budgetLeft >= mintPrice && generationMintCounts[currentGeneration] <= maxTokensPerGen) {
    _mintInternal(msg.sender, mintPrice);
    generationMintCounts[currentGeneration]++;
    amountMinted++;
    budgetLeft -= mintPrice;
}
```

## Learning Summary 
This vulnerability highlights the importance of proper state variable management in NFT contracts, especially when dealing with multiple generations
The Key learning points are :
1> Always use the generations-specific counters for generations-specifc logic
2> Carefully review the counter variable/mechanism in minting functions
3> Test edge cases across multiple generations 
4> Ensure proper seperatiosn of concerns between total and generation-specific state variables.

## Partical Exercise

Implementing the secure multi-genration NFT Contract

```solidity 


pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MultiGenNFT is ERC721 , Ownable {

    address public owner;
    mapping(uint256 => uint256) public generationMintCount;
    uint256 public currentGeneration;
    uint256 public maxPerGeneration;
    uint256 public mintAmount;

    event NewGenerationStarted(uint256 generation);
    event TokenMinted(address indexed to, uint256 tokenId, uint256 generation);

    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxPerGeneration,
        uint256 _mintPrice
    ) ERC721(name, symbol) Ownable(msg.sender) {
        maxPerGeneration = _maxPerGeneration;
        mintAmount = _mintPrice;
        currentGeneration = 1;
    }
    
    // TODO: Implement the following functions:

    // 1. mintToken() - Should track generation-specific counts

    function mintToken(uint256 _budgetAmount) external {
        require(_budgetAmount > 0 , "InvalidAmount");

        While(_budgetAmount >= mintAmount && generationMintCount[currentGeneration] <= maxPerGeneration) {
            _mintInternal(msg.sender,mintAmount);
            generationMintCount[currentGeneration]++;
            _budgetAmount -= mintAmount;

            emit TokenMinted(msg.sender,generationMintCount[currentGeneration],currentGeneration);
        }

    }

    function _mintInternal(address _minterAddress, uint256 _mintAmount) internal {
        uint256 tokenId = generationMintCount[currentGeneration];
        _safeMint(_minterAddress,tokenId);
    }

    // 2. startNewGeneration() - Should handle generation transitions
    function startNewGeneration() external onlyOwner {
        currentGeneration++;
        generationMintCount[currentGeneration] = 0;
        emit NewGenerationStarted(currentGeneration);
    }
    // 3. getAvailableSupply() - Should return remaining supply for current generation
    function getAvailableSupply() public returns(uint256 availableSupply) {
        availableSupply = maxPerGeneration - generationMintCount[currentGeneration];
    }
}
```