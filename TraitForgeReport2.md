## NFT Airdrop Griefing Attack via Token Burning

Learning How NFT burning mechanics can be exploited to grief initial token owner by reducing their airdrop benefits after token transfer

Topics - Access Control,Griefing Attack , Airdrop Mechanics , NFT Burning

## Introduction 
This lesson explores a vulnerability in the TraitForge NFT system where transferred token can be burned or nuked by new owner, resulting in the reduction of airdrop benefits for the initial token minter

## Key Concepts 
1. Initial Owner Tracking - the system track the first owner(minter) of each NFT token using a mapping
2. Airdrop Benefits - Initial owner receive airdrop benefits based on their minted token's entropy values
3. Token Burning - The ability to permanently destroy tokens , affecting associated benefits
4. Token Transfer - The process of changing token ownership while maintaing initial owner records


## Reported Vulnerability Detail

The vulnerability stems from three key mechanisms:

- When tokens are minted, the minter is recorded as the initial owner and receives airdrop benefits based on the token's entropy.
- These benefits remain linked to the initial owner even after token transfer.
- Any subsequent owner can burn or nuke the token, which reduces the initial owner's airdrop benefits, despite no longer owning the token.

## Potential Impact

The vulnerability enables malicious actors to:

- Purchase or receive tokens and intentionally burn them to reduce the seller's airdrop benefits
- Create a griefing attack vector where buyers can harm sellers after purchase
- Potentially manipulate the airdrop distribution system

## How to Identify This Sort of Vulnerability

- System tracking Initial Ownership seperately from current Ownership
- Benefits systems tied to initial ownership rather than current ownership
- Burning Mechanism that affet Historical Benefits 
- Lack of validation in burning functions regarding benefits reduction(Benefits only reduces when initial owner burn token)

## Recommended Mitigation Steps 
Implement the following safeguards:

- Add checks in burn functions to verify if the caller is the initial owner
- Consider implementing a benefit transfer mechanism during token transfers
- Add protection mechanisms for initial owner benefits
- Implement a time lock for burning after transfer

## Code Comparison

Before:
```solidity
function burn(uint256 tokenId) external whenNotPaused nonReentrant {
    if (!airdropContract.airdropStarted()) {
        uint256 entropy = getTokenEntropy(tokenId);
        airdropContract.subUserAmount(initialOwners[tokenId], entropy);
    }
}
```
After:

```solidity
function burn(uint256 tokenId) external whenNotPaused nonReentrant {
    if (!airdropContract.airdropStarted()) {
        if (msg.sender == initialOwners[tokenId]) {
            uint256 entropy = getTokenEntropy(tokenId);
            airdropContract.subUserAmount(initialOwners[tokenId], entropy);
        }
    }
}
```

## Lesson Summary 
This vulnerability highlights the importance of carefully considering the implications of token burning mechanics in NFT systems, especially when combined with benefit distribution systems. The key takeaway is that benefit reduction mechanisms should be properly aligned with ownership status and include appropriate access controls to prevent griefing attacks.


## Learning About the Griefing Attack
