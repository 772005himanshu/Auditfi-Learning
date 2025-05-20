pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract FeeDistributor is Ownable{
    uint256 private constant BPS = 10_000;
    uint256 public feePercentage;

    event FeeDistributed(uiint256 amount);
    
    // TODO: Implement setFeePercentage function with proper validation
    function setFeePercentage(uint256 _feePercenatge) public onlyOwner {
        feePercentage = _feePercenatge;
    }
    // TODO: Implement calculateFee function that correctly uses BPS
    function calculateFee() public payable returns(uint256 fee){
        fee = (msg.value * feePercentage) / BPS;
    }
    // TODO: Add receive function that distributes fees accurately
    receive() external payable {
        uint256 fee = calculateFee();
        payable(owner()).transfer(fee);
        emit FeeDistributed(fee);
    }
}