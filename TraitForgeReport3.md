## Percentage Calculation Vulnerabilities in Smart Contracts

Topics - Percentage Calculations , Fee Distribution , Math OPerations , BPS System , Protocol Economics

## Introduction

This lesson covers a critical Vulnerability in percentage-based calculation within smart contract.The issue arises when simple division is used for percentage calculations instead of proper basis point (BPS) calculations, leading to incorrect fee distributions and potential financial losses.

## Key Concepts

- Percentage Calculations in Smart Contracts: How to properly implement percentage-based operations in smart contracts
- Basis Points (BPS): A standard unit for expressing percentages in financial calculations, where 1 BPS = 0.01%
- Fee Distribution: Methods for fairly and accurately distributing fees between different parties in a protocol
- Protocol Economics: How mathematical errors can impact the overall economic model of a protocol


## Reported Vulnerability 
The vulnerability stems from using direct division for percentage calculations. For example:
```solidity
uint256 devShare = msg.value / taxCut;
```
This leads to incorrect calculations when taxCut is changed from its default value of 10. For instance:
 - When taxCut = 5, intended 5% becomes 20% (1/5 = 0.2)
 - When taxCut = 20, intended 20% becomes 5% (1/20 = 0.05)



## Potential Impact

- Incorrect distribution of funds between developers and users
- Significant financial losses or unintended gains
- Undermining of the protocol's economic model
- Loss of user trust when discrepancies are discovered

## How to identify This Sort of Vulnerability

- Look for direct division operations in percentage calculations
- Check for percentage-based fee distributions
- Review variable names containing `tax`, `fee` and `percentage`
- Analyze mathematical operations that should result in percentage-based outputs
- Test edge cases with different percentage values

## Recommended Mitigation Steps

- Implement a BPS system with a constant:
```solidity
uint256 private constant BPS = 10_000;
```
- Update percentage calculations:
```solidity
uint256 devShare = (msg.value * taxCut) / BPS;
```
- Add boundary checks:
```solidity
require(_taxCut <= BPS, "Tax cut cannot exceed 100%");
```

## Code Comparison

Before:
```solidity
uint256 public taxCut = 10;
uint256 devShare = msg.value / taxCut;
```

After:
```solidity
uint256 private constant BPS = 10_000;
uint256 public taxCut = 1000; // 10%
uint256 devShare = (msg.value * taxCut) / BPS;  // msg.value * 0.1 > represent 10%
```

## Lesson Summary
- Highlight Importance of proper Calculations in Smart Contract
- Using simple division for percentages can lead to severe mathematical errors and financial losses. 
- The solution involves implementing a basis point system for accurate percentage calculations and adding proper boundary checks. Always use standardized approaches like BPS for financial calculations in smart contracts.