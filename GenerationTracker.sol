pragma solidity ^0.8.0;

contract GenerationTracker {
    mapping(uint256 => uint256) public genCount;
    uint256 public currentGeneration;
    uint256 public constant MAX_PER_GEN = 10000;

    function createToken(uint256 generation) public { // We can select any generation to create a token
        require(generation <= currentGeneration, "Invalid generation");
        require(genCount[generation] < MAX_PER_GEN, "Generation full");
        genCount[generation]++;
        // Implement additional logic
    }

    // TODO: Implement incrementGeneration() function

    function incrementGeneration() public {
        require(genCount[currentGeneration] == MAX_PER_GEN, "Generation not full");
        currentGeneration++;
    }
    // TODO: Implement getGenerationCount() function
    function getGenerationCount() public view returns(uint256 ) {
        return currentGeneration;
    }
}