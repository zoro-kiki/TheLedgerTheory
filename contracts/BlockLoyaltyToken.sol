// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract BlockLoyaltyToken is IERC20 {
    string public name = "BlockLoyalty Token";
    string public symbol = "BLT";
    uint8 public decimals = 0; 
    
    uint256 private _totalSupply;
    address public shopOwner;

    mapping(address => uint256) private _balances;

    modifier onlyShopOwner() {
        require(msg.sender == shopOwner, "Error: Access restricted to the shop owner.");
        _;
    }

    constructor() {
        shopOwner = msg.sender;
        _totalSupply = 0;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function rewardCustomer(address _customer, uint256 _points) public onlyShopOwner returns (bool) {
        require(_customer != address(0), "Error: Invalid target client address.");
        _totalSupply += _points;
        _balances[_customer] += _points;
        emit Transfer(address(0), _customer, _points);
        return true;
    }

    function transfer(address _recipient, uint256 _amount) public override returns (bool) {
        require(_recipient != address(0), "Error: Invalid recipient address.");
        require(_balances[msg.sender] >= _amount, "Error: Insufficient loyalty token balances.");

        _balances[msg.sender] -= _amount;
        _balances[_recipient] += _amount;
        emit Transfer(msg.sender, _recipient, _amount);
        return true;
    }

    function redeemPoints(uint256 _amount) public returns (bool) {
        require(_balances[msg.sender] >= _amount, "Error: Insufficient points available for redemption.");

        _balances[msg.sender] -= _amount;
        _totalSupply -= _amount;
        emit Transfer(msg.sender, address(0), _amount);
        return true;
    }
}