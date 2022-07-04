// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";


contract sagitaPortal is Ownable, Pausable {
    uint256 edgeCount;
    uint256 validatorCount;

    event NewEdge(
        address indexed indexer, 
        uint256 timestamp, 
        string parentname,
        string parenturl,
        string parentcontract,
        string childname,
        string childurl,
        string childcontract,
        address[] approvers
    );

    struct EdgeIndex {
        address indexer;
        uint256 timestamp; 
        string parentname;
        string parenturl;
        string parentcontract;
        string childname;
        string childurl;
        string childcontract;
        address[] approvers;
    }

    struct User {
        address account;    
    }

    EdgeIndex[] public edges;
    User[] public users;
    mapping(address => bool) public isIndexer;
    mapping(address => bool) public isValidator;

    constructor() payable {
        console.log("We have been constructed!");
    }    

    event Received(address, uint);
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
//Edgeの追加を定義
    function addEdge(
            string memory _parentname,
            string memory _parenturl, 
            string memory _parentcontract, 
            string memory _childname,
            string memory _childurl, 
            string memory _childcontract,
            address[] memory _approvers
        ) public  {
        edgeCount += 1;
        console.log("%s added edge w/  %s to %s", msg.sender, _parenturl, _childurl);
        //TODO：既存であるかどうかチェックする分岐を入れる
        //なぜ二重に追加されるんだ、、、
        edges.push(EdgeIndex(msg.sender, block.timestamp,_parentname,  _parenturl, _parentcontract, _childname, _childurl, _childcontract, _approvers));
        
        emit NewEdge(msg.sender, block.timestamp, _parentname,  _parenturl, _parentcontract, _childname, _childurl, _childcontract, _approvers);

        // // 「index」を送ってくれたユーザーに0.001 ETHを送る
        // uint256 prizeAmount = 0.001 ether;
        // require(
        //     prizeAmount <= address(this).balance,
        //     "Trying to withdraw more money than the contract has."
        // );
        // (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        // require(success, "Failed to withdraw money from contract.");
    }

    function upsertValidator(address _account) external onlyOwner {
        isValidator[_account] = true;
        validatorCount++;
        for (uint256 i = 0; i < users.length; i++) {
            if (users[i].account == _account) {
                return;
            }
        }
        users.push(User(_account));
    }

    function deleteValidator(address _account) external onlyOwner {
        isValidator[_account] = false;
        validatorCount--;
    }

    modifier onlyValidator() {
        require(isValidator[msg.sender], 'You are not validator');
        _;                                                                                                                                                                                                                                         
    }

    function approve(uint _indexId) external onlyValidator {
        //TODO：ホルダーかどうかを判定する部分を作る
        for (uint j = 0; j < edges[_indexId].approvers.length; j++) {
            if (edges[_indexId].approvers[j] == msg.sender) {
                return;
            }
        }    
        edges[_indexId].approvers.push(msg.sender);
        console.log("added");
       
    }

  

    function getAllEdges() public view returns (EdgeIndex[] memory) {
        console.log("get all edges");
        return edges;
    }


    function checkValidator() public view returns (bool) {
        return isValidator[msg.sender];
    }

    function getValidatorCount() public view returns (uint256) {
        return validatorCount;
    }

    function getAllUsers() public view returns (User[] memory) {
        return users;
    }


    function getAllValidators() public view returns (address[] memory) {
        address[] memory _validators = new address[](users.length);
        uint counter = 0;
        for (uint256 i = 0; i < users.length; i++) {
            if (isValidator[users[i].account]) {
                _validators[counter] = users[i].account;
                counter++;
            }
        }    
        return _validators;
    }

    function getEdgeCount() public view returns (uint256) {
        console.log("We have %d indexes!", edgeCount);
        return edgeCount;
    }
}