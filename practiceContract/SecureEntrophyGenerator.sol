// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SecureEntropyGenerator {
    // Constants
    uint256 public constant MAX_SLOTS = 100;
    uint256 public constant SLOT_SIZE = 32; // bytes
    
    // State variables
    uint256 public lastInitializedIndex;
    uint256 public currentSlotIndex;
    mapping(uint256 => bytes32) private entropySlots;
    mapping(uint256 => bool) private isSlotInitialized;
    
    // Events
    event EntropyInitialized(uint256 indexed slotIndex, bytes32 entropy);
    event EntropyGenerated(uint256 indexed slotIndex, bytes32 entropy);
    
    // Errors
    error NotInitialized();
    error InvalidSlotIndex();
    error AllSlotsInitialized();
    error SlotAlreadyInitialized();
    
    constructor() {
        lastInitializedIndex = 0;
        currentSlotIndex = 0;
    }
    
    /**
     * @dev Initialize a new entropy slot with a random value
     * @param _entropy The entropy value to initialize the slot with
     */
    function initialize(bytes32 _entropy) external {
        if (lastInitializedIndex >= MAX_SLOTS) {
            revert AllSlotsInitialized();
        }
        
        if (isSlotInitialized[lastInitializedIndex]) {
            revert SlotAlreadyInitialized();
        }
        
        entropySlots[lastInitializedIndex] = _entropy;
        isSlotInitialized[lastInitializedIndex] = true;
        
        emit EntropyInitialized(lastInitializedIndex, _entropy);
        
        lastInitializedIndex++;
    }
    
    /**
     * @dev Get the next entropy value from the initialized slots
     * @return The next entropy value
     */
    function getNextEntropy() external returns (bytes32) {
        if (currentSlotIndex > MAX_SLOTS) {
            revert AllSlotsInitialized();
        }
        if (currentSlotIndex >= lastInitializedIndex) {
            revert NotInitialized();
        }
        
        if (!isSlotInitialized[currentSlotIndex]) {
            revert NotInitialized();
        }
        
        bytes32 entropy = entropySlots[currentSlotIndex];
        
        // Generate new entropy for the current slot
        bytes32 newEntropy = keccak256(abi.encodePacked(
            entropy,
            block.timestamp,
            block.prevrandao,
            blockhash(block.number - 1)
        ));
        
        entropySlots[currentSlotIndex] = newEntropy;
        
        emit EntropyGenerated(currentSlotIndex, newEntropy);
        
        // Move to next slot
        currentSlotIndex = (currentSlotIndex + 1) % lastInitializedIndex;
        
        return entropy;
    }
    
    /**
     * @dev Check if a specific slot is initialized
     * @param _slotIndex The index of the slot to check
     * @return bool indicating if the slot is initialized
     */
    function isInitialized(uint256 _slotIndex) external view returns (bool) {
        if (_slotIndex >= MAX_SLOTS) {
            revert InvalidSlotIndex();
        }
        return isSlotInitialized[_slotIndex];
    }
    
    /**
     * @dev Get the current entropy value for a specific slot
     * @param _slotIndex The index of the slot to get entropy from
     * @return The entropy value for the specified slot
     */
    function getSlotEntropy(uint256 _slotIndex) external view returns (bytes32) {
        if (_slotIndex >= MAX_SLOTS) {
            revert InvalidSlotIndex();
        }
        if (!isSlotInitialized[_slotIndex]) {
            revert NotInitialized();
        }
        return entropySlots[_slotIndex];
    }
    
    /**
     * @dev Get the total number of initialized slots
     * @return The number of initialized slots
     */
    function getInitializedSlotCount() external view returns (uint256) {
        return lastInitializedIndex;
    }
}