pragma solidity ^0.8.0;

import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/Pausable.sol';


contract SafeNFT is ERC721, Ownable,Pausable,ReentrancyGuard{
    mapping(uint256 => address) public initialOwners;
    mapping(uint256 => uint256) public benefitLocks;
    
    function burn(uint256 tokenId) external nonReentrant whenNotPaused {
        // TODO: Implement checks for:
        // 1. Is caller the current owner?
        if(msg.sender == initialOwners[tokenId]) {
            uint256 benefits = getBenefitsLocks(tokenId);
            benefitsLocks[tokenId] -= benefits;
        }
        _burn(tokenId);
    }

    function getBenefitsLocks(uint256 tokenId) public view returns(uint256 benefits) {
        return benefitLocks[tokenId];
    }
}