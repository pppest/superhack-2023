// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Faucet is Ownable {
    IERC20 public token;
    uint256 public totalTokens;
    uint256 public dripAmount = 100 ether;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function depositTokens(uint256 amount) external {
        token.transferFrom(owner(), address(this), amount);
        totalTokens += amount;
    }

    function drip() external {
        require(totalTokens >= dripAmount, "Insufficient balance in faucet");

        totalTokens -= dripAmount;
        token.transfer(msg.sender, dripAmount);
    }

    function getRemainingTokens() external view returns (uint256) {
        return totalTokens;
    }
}
