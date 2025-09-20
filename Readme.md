# 🎉 NFT Staking DApp  

This project shows a simple **NFT Staking mechanism** built with Solidity.  
Users can stake their **NFTs (ERC721)** to earn rewards in an **ERC20 token**.  

---

## 🏗️ Tech Stack  
- ⚡ Solidity  
- 📦 OpenZeppelin Contracts  
- 🔗 Ethereum / EVM chains  

---

## 📂 Files in this repo  

### 📌 `staking.sol`  
🛠️ Main smart contract.  
- ✅ **Stake NFT** → lock NFT in contract.  
- 💰 **Accumulate rewards** → earn ERC20 tokens based on time.  
- 🔓 **Unstake NFT** → withdraw NFT + claim rewards.  
- 📈 Rewards grow depending on how long the NFT stays staked.  

---

### 💎 `coin.sol`  
- 💵 An **ERC20 token** (reward token).  
- 🎁 Used to pay staking rewards.  
- 🔒 Based on OpenZeppelin’s ERC20 standard.  

---

### 🎨 `nft.sol`  
- 🖼️ An **ERC721 NFT contract**.  
- 👤 Users mint NFTs and later stake them in `staking.sol`.  
- 🔒 Based on OpenZeppelin’s ERC721 standard.  

---

## ⚙️ How it works  

1. 🚀 **Deploy `coin.sol`** → creates fungible reward token.  
2. 🎨 **Deploy `nft.sol`** → lets users mint NFTs.  
3. 🔗 **Deploy `staking.sol`** → pass the addresses of the deployed ERC20 + ERC721 contracts.  

👥 **User flow:**  
- 🏦 `stakeNft(tokenId)` → NFT moves into staking contract.  
- ⏳ Rewards accumulate (rate increases the longer you stake).  
- 🎁 `unstakeNft(tokenId)` → claim ERC20 rewards + get NFT back.  

---

## 🧮 Reward Logic  

| Time Staked ⏳ | Reward Rate 💰 |
|---------------|----------------|
| 0–1 min       | 0 tokens/min   |
| 1–4 min       | 5 tokens/min   |
| 4–8 min       | 10 tokens/min  |
| 8+ min        | 15 tokens/min  |

⚖️ All rewards are scaled with `10^18` to follow ERC20 decimals.  

---

## 📖 Summary  

- 🪙 `coin.sol` = reward token (ERC20)  
- 🖼️ `nft.sol` = NFT collection (ERC721)  
- 📦 `staking.sol` = staking system to earn rewards by locking NFTs  
