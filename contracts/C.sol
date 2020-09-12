// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title C
 */
contract C is Ownable {
    using SafeERC20 for IERC20;

    // Compatible token address
    address public compatibleToken;

    // Contract C events
    event TokensClaimed(address indexed _to, uint256 _amount);
    event TokensReceived(address indexed _payee, uint256 _amount);

    /**
     * @dev Contract C constructor to set value of token address
     * @param _compatibleToken address ERC20 token compatible to Contract C
     */
    constructor(address _compatibleToken) public {
        compatibleToken = _compatibleToken;
    }

    /**
     * @dev Used to receive tokens for contract C
     * @param _amount uint256 Token amount to be received
     */
    function receiveToken(uint256 _amount) external returns (bool) {
        IERC20(compatibleToken).safeTransferFrom(
            msg.sender,
            address(this),
            _amount
        );
        emit TokensReceived(msg.sender, _amount);

        return true;
    }

    /**
     * @dev Used to claim tokens accumulated by the Contract C
     * @param _to address The address to transfer the fee
     */
    function claimFee(address _to) external onlyOwner {
        IERC20 token = IERC20(compatibleToken);
        uint256 currentBalance = token.balanceOf(address(this));

        token.safeTransfer(_to, currentBalance);
        emit TokensClaimed(_to, currentBalance);
    }
}
