pragma solidity ^0.8.20;

contract AccessControlProper {
    address public allowedCaller;
    address public owner;

    event AllowedCallerUpdated(address indexed oldCaller , address indexed newCaller);
    event RestrictedFunctionCalled(uint256 slotIndexSelection, uint256 numberIndexSelection);

    constructor() {
        owner = msg.sender;
        allowedCaller = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner , "Only Owner ca call this function");
        _;
    }
    
    modifier onlyAllowedCaller() {
        // TODO: Implement modifier
        require(msg.sender == allowedCaller, "Caller is not allowed");
        _;
    }
    
    function setAllowedCaller(address _caller) external onlyOwner {
        // TODO: Implement setter with proper access control
        require(_caller != address(0), "Invalid caller address");
        address oldCaller = allowedCaller;
        allowedCaller = _caller;
        emit AllowedCallerUpdated(oldCaller, allowedCaller);
    }
    
    function restrictedFunction() external onlyAllowedCaller {
        // TODO: Implement restricted functionality
        uint256 hashValue = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));

        uint256 slotIndexSelection = (hashValue % 258) + 512;
        uint256 numberIndexSelection = hashValue % 13 ;

        emit RestrictedFunctionCalled(slotIndexSelection, numberIndexSelection);

    }
}