//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


// contract MyNFT is ERC721URIStorage, Ownable {
//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIds;

//     constructor() ERC721("MyNFT", "NFT") {}

//     function mintNFT(address recipient, string memory tokenURI)
//         public onlyOwner
//         returns (uint256)
//     {
//         _tokenIds.increment();

//         uint256 newItemId = _tokenIds.current();
//         _mint(recipient, newItemId);
//         _setTokenURI(newItemId, tokenURI);

//         return newItemId;
//     }
// // }
// pragma solidity ^0.8.0;
// import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFTMarketplace is ERC721, Ownable {
    using SafeMath for uint256;

    mapping (uint256 => address) private _tokenOwners;
    mapping (uint256 => uint256) private _tokenPrices;

    constructor() ERC721("MyNFTMarketplace", "NFTM") {}

    function mintNFT(address recipient, string memory tokenURI, uint256 price) public onlyOwner {
        require(price > 0, "Price must be greater than 0");

        uint256 newItemId = totalSupply().add(1);
        _mint(recipient, newItemId);
        _tokenOwners[newItemId] = recipient;
        _tokenPrices[newItemId] = price;
    }

    function buyNFT(uint256 tokenId) public payable {
        require(_tokenOwners[tokenId] != address(0), "Token does not exist");
        require(_tokenPrices[tokenId] <= msg.value, "Insufficient funds");

        address previousOwner = _tokenOwners[tokenId];
        _transfer(previousOwner, msg.sender, tokenId);
        _tokenOwners[tokenId] = msg.sender;

        previousOwner.transfer(_tokenPrices[tokenId]);
    }

    function sellNFT(uint256 tokenId, uint256 price) public {
        require(_tokenOwners[msg.sender] == msg.sender, "You do not own this token");
require(price > 0, "Price must be greater than 0");

        _tokenPrices[tokenId] = price;
    }
}