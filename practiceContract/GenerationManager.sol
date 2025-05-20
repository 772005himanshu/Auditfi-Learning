pragma solidity ^0.8.0;

// Exercise: Implement a secure generation management system
contract GenerationManager {
    uint256 public currentGeneration;
    uint256 public constant MAX_GENERATION = 10;
    mapping(uint256 => uint256) public generationMintCount;
    uint256 public constant MAX_MINTS_PER_GENERATION = 10000;

    event GenerationIncreamented(uint256 newGeneration);
    event Minted(address indexed minter, uint256 generation, uint256 mintCount);
    
    // TODO: Implement incrementGeneration() function with proper checks
    function increamentGeneration() public {
        require(generationMintCount[currentGeneration] <= MAX_MINTS_PER_GENERATION, "Generation Limit Reached");
        currentGeneration++;
        require(currentGeneration <= MAX_GENERATION,"Maximum Generation Reached");
        emit GenerationIncreamented(currentGeneration);

    }
    // TODO: Implement mint() function with generation validation
    function mint() public {
        require(currentGeneration <= MAX_GENERATION, "Maximum Generation Reached");
        require(generationMintCount[currentGeneration] < MAX_MINTS_PER_GENERATION ,"Generation Limit Reached");
        generationMintCount[currentGeneration]++;
        _mint(msg.sender, generationMintCount[currentGeneration]);
        emit Minted(msg.sender, currentGeneration, generationMintCount[currentGeneration]);
    }
    // TODO: Add events for generation changes
    // TODO: Implement generation status checking function
    function generationStatus() public view returns(uint256 , uint256 ) {
        return (currentGeneration, generationMintCount[currentGeneration]);
    }
}