// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Staking is IERC721Receiver, ERC721Holder{

    IERC20 immutable token ;
    using SafeERC20 for IERC20;
    IERC721 immutable nft ;

    mapping(address => mapping(uint256 => uint256)) public stakes;

    constructor(address _token , address _nft){
        token = IERC20(_token);
        nft = IERC721(_nft);
    }

    function stakeNFt(uint256 _tokenId) public {
        require(nft.ownerOf(_tokenId) == msg.sender,"You dont own the NFT");
        nft.safeTransferFrom(msg.sender, address(this), _tokenId, "");
        stakes[msg.sender][_tokenId] = block.timestamp;

    } 

    function calculateRate(uint256 _tokenId) private view returns(uint8) {
        uint256 time = stakes[msg.sender][_tokenId];
        if(block.timestamp - time < 1 minutes) {
            return 0;
        } else if(block.timestamp - time <  4 minutes) {
            return 5;
        } else if(block.timestamp - time < 8 minutes) {
            return 10;
        } else {
            return 15;
        }
    }

    function calculateReward(uint256 _tokenId) public view returns (uint256 totalReward) {
        uint256 time = block.timestamp - stakes[msg.sender][_tokenId];
        uint256 reward =  calculateRate(_tokenId) * time  * 10 ** 18/ 1 minutes;
        return reward;
    }

    function unstakeNft(uint256 _tokenId) public {
        uint256 reward = calculateReward(_tokenId);
        token.safeTransfer(msg.sender, reward);
        nft.safeTransferFrom(address(this), msg.sender, _tokenId, "");
        delete stakes[msg.sender][_tokenId];
    }
}
