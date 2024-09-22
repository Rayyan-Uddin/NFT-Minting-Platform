//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//import openzepplin contracts
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Collection is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _totalMinted;

    uint256 public pricePerToken = 0.0001 ether;
    uint public limitPerAddress = 3;
    uint256 public maximumSupply = 1000;

    mapping(address => uint8) private mintedAddress;
    mapping(string => uint8) private mintedURI;

    constructor() ERC721("NFT-marketplace", "NFT") {}

    function setPrice(uint256 price) external onlyOwner {
        pricePerToken = price;
    }

    function setLimit(uint256 limit) external onlyOwner {
        limitPerAddress = limit;
    }

    function setMaxSupply(uint256 maxSupply) external onlyOwner {
        maximumSupply = maxSupply;
    }

    function mintNft(
        string memory tokenURI
    ) external payable returns (uint256) {
        require(
            pricePerToken <= msg.value,
            "Required amount for minting must be paid"
        );
        require(
            mintedAddress[msg.sender] < limitPerAddress,
            "You have exceeded the limit for minting NFT."
        );
        require(
            _totalMinted.current() + 1 <= maximumSupply,
            "You have exceeded supply limit."
        );
        require(mintedURI[tokenURI] == 0, "This NFT has been minted.");

        mintedURI[tokenURI] += 1;
        mintedAddress[msg.sender] += 1;
        _tokenIds.increment();
        _totalMinted.increment();

        uint256 newItemId = _tokenIds.current();
        mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function withDrawMoney() external onlyOwner {
        address payable to = payable(msg.sender);
        to.transfer(address(this).balance);
    }
}
