pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract StarNotary is ERC721 {

    struct Star {
        string name;
        string story;
        string cent;
        string dec;
        string mag;
        bool isNotEmpty;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(bytes32 => bool) public starHashMap;
    mapping(uint256 => uint256) public starsForSale;
    uint256 lastStarIndex = 0;


    function getCoordinatorsHash(string _cent, string _dec, string _mag) public pure returns (bytes32){
        return keccak256(abi.encodePacked(_cent, _dec, _mag));
    }
    function checkIfStarExist(bytes32 _coordinatorsHash) public view returns (bool){
        return starHashMap[_coordinatorsHash];
    }
    function nextStarIndex() public view returns (uint256){
        uint256 nextIndex = lastStarIndex + 1;
        require(!tokenIdToStarInfo[nextIndex].isNotEmpty);
        return nextIndex;
    }

    function createStar(string _name, string _story, string _cent, string _dec, string _mag) public {

        uint256 tokenId = nextStarIndex();
        bytes32 coordinatorsHash = getCoordinatorsHash(_cent, _dec, _mag);
        // check coordinators uniqueness
        require(!checkIfStarExist(coordinatorsHash));
        // init star
        Star memory newStar = Star(_name, _story, _cent, _dec, _mag, true);
        // save star
        tokenIdToStarInfo[tokenId] = newStar;
        starHashMap[coordinatorsHash] = true;
        lastStarIndex = tokenId;

        _mint(msg.sender, tokenId);
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(this.ownerOf(_tokenId) == msg.sender);

        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0);

        uint256 starCost = starsForSale[_tokenId];
        address starOwner = this.ownerOf(_tokenId);
        require(msg.value >= starCost);

        _removeTokenFrom(starOwner, _tokenId);
        _addTokenTo(msg.sender, _tokenId);

        starOwner.transfer(starCost);

        if(msg.value > starCost) {
            msg.sender.transfer(msg.value - starCost);
        }
    }
}
