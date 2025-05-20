pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MultiGenNFT is ERC721 , Ownable {

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

        while(_budgetAmount >= mintAmount && generationMintCount[currentGeneration] <= maxPerGeneration){
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
        emit NewGenerationStarted(currentGeneration);
    }
    // 3. getAvailableSupply() - Should return remaining supply for current generation
    function getAvailableSupply() public view returns(uint256 availableSupply) {
        availableSupply = maxPerGeneration - generationMintCount[currentGeneration];
    }
}