pragma solidity ^0.4.23;

import "github.com/Arachnid/solidity-stringutils/strings.sol";
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract StarNotary is ERC721 {

    using strings for *;

    struct Star {
        string name;
        string story;
        string dec;
        string mag;
        string cent;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(string => bool) public starCoordinatorsInfo;
    mapping(uint256 => uint256) public starsForSale;

    function getCoordinatorsString(string _dec, string _mag, string _cent) returns (string){
        return _dec.toSlice().concat(_mag.toSlice()).concat(_cent.toSlice());
    }
    function checkIfStarExist(string _dec, string _mag, string _cent) returns (bool){
        string coordinatorsString = getCoordinatorsString(_dec, _mag, _cent);
        return starCoordinatorsInfo[_coordinatorsString] == 0;
    }

    function createStar(string _name, string _story, string _dec, string _mag, string _cent, uint256 _tokenId) public {
        // check coordinators uniqueness
        require(checkIfStarExist(_dec, _mag, _cent));

        // init star
        Star memory newStar = Star(_name, _story, _dec, _mag, _cent);

        tokenIdToStarInfo[_tokenId] = newStar;
        starCoordinatorsInfo[_coordinatorsString] = true;

        _mint(msg.sender, _tokenId);
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
