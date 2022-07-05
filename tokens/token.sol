//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract WorkToken is IERC20{
    string public constant name = "WorkToken";
    string public constant symbol = "WTK";
    uint256 public decimals = 18;
    address private owner;
    uint256 private totalsupply;
    
    mapping(address=>uint256) addressToBalance;
    mapping(address => mapping(address=>uint256)) allowed;

    constructor(){
        totalsupply = 1000;
        addressToBalance[msg.sender] = totalsupply;
        owner = msg.sender;
    }

    function totalSupply() public override view returns(uint256){
        return totalsupply;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256){
         return addressToBalance[tokenOwner];
    }

    function transfer(address recipient, uint256 amount) public override returns(bool){
        require(addressToBalance[msg.sender] >= amount, "Balance insufficient");
        addressToBalance[msg.sender] -= amount;
        addressToBalance[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns(bool){
        require(amount <= addressToBalance[msg.sender], "Balance insufficient");
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender,spender,amount);
        return true;
    }

    function allowance(address ownerToken, address spender) public override view returns (uint256){
        return allowed[ownerToken][spender];
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool){
        require(amount <= addressToBalance[sender], "Sender balance insufficient");
        require(amount <= allowed[sender][msg.sender], "Allowed balance insufficient");
        allowed[sender][msg.sender] -= amount;
        addressToBalance[sender] -= amount;
        addressToBalance[recipient] += amount;
        emit Transfer(sender,recipient,amount);
        return true;
    }
}