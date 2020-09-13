// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./B.sol";

/**
 * @title A
 */
contract A {
    using SafeERC20 for IERC20;

    // Compatible address
    address public compatibleToken;
    address public compatibleB;

    // Contract A events
    event TokensReceivedAndForwarded(
        address indexed _payee,
        address _to,
        uint256 _amount
    );

    /**
     * @dev Contract A constructor to set value of token address
     * @param _compatibleToken address ERC20 token compatible to Contract A
     * @param _compatibleB address Contract B
     */
    constructor(address _compatibleToken, address _compatibleB) public {
        compatibleToken = _compatibleToken;
        compatibleB = _compatibleB;
    }

    /**
     * @dev Used to receive tokens for contract A and then transfer them to B
     * @param _amount uint256 Token amount to be received and forwarded
     */
    function receiveAndForwardTokens(uint256 _amount) external {
        IERC20 token = IERC20(compatibleToken);
        token.safeTransferFrom(msg.sender, address(this), _amount);
        token.safeApprove(compatibleB, 0);
        token.safeApprove(compatibleB, _amount);

        require(
            B(compatibleB).receiveAndForwardTokens(_amount),
            "A: Failed to forward tokens to B"
        );

        emit TokensReceivedAndForwarded(msg.sender, compatibleB, _amount);
    }
}
