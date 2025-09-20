// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721Pausable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Professor is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    uint256 maxSupply = 1000 ;
    mapping (address => bool) public allowList ;

    bool publicMintOpen = false ;
    bool allowListMintOpen = false ;

    constructor(address initialOwner)
        ERC721("Professor", "PF")
        Ownable(initialOwner)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmY5rPqGTN1rZxMQg2ApiSZc7JiBNs1ryDzXPZpQhC1ibm/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function withdraw (address _address)external onlyOwner{
        uint256 amount = address(this).balance;
        payable(_address).transfer(amount);
    }

    function editMintOpen(bool _publicMint , bool _allowListMint)external onlyOwner{
        publicMintOpen = _publicMint ;
        allowListMintOpen = _allowListMint ;
    }

    function allowListMint() public payable returns (uint256){
        require(allowListMintOpen,"allowList mint is closed");
        require(allowList[msg.sender],"You are not allowed");
        require(msg.value == 0.001 ether, "Not Enough Funds");
        require(totalSupply() < maxSupply, "All Sold Out !");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        return tokenId;
    }

    function publicMint() public payable returns (uint256) {
        require(publicMintOpen,"public mint is closed");
        require(msg.value == 0.01 ether, "Not Enough Funds");
        require(totalSupply() < maxSupply, "All Sold Out !");
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        return tokenId;
    }

    function setAllowList(address[] calldata addresses)external onlyOwner {
        for(uint256 i=0 ; i < addresses.length ; i++){
            allowList[addresses[i]] = true ;
        }
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
