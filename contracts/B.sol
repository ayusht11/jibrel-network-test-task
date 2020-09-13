// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./C.sol";

/**
 * @title B
 */
contract B {
    using SafeERC20 for IERC20;

    // Compatible address
    address public compatibleToken;
    address public compatibleC;

    // Contract B events
    event TokensReceivedAndForwarded(
        address indexed _payee,
        address _to,
        uint256 _amount
    );

    /**
     * @dev Contract B constructor to set value of token address
     * @param _compatibleToken address ERC20 token compatible to Contract B
     * @param _compatibleC address Contract C
     */
    constructor(address _compatibleToken, address _compatibleC) public {
        compatibleToken = _compatibleToken;
        compatibleC = _compatibleC;
    }

    /**
     * @dev Used to receive tokens for contract B and then transfer them to C
     * @param _amount uint256 Token amount to be received and forwarded
     */
    function receiveAndForwardTokens(uint256 _amount) external returns (bool) {
        IERC20 token = IERC20(compatibleToken);
        token.safeTransferFrom(msg.sender, address(this), _amount);
        token.safeApprove(compatibleC, 0);
        token.safeApprove(compatibleC, _amount);

        require(
            C(compatibleC).receiveToken(_amount),
            "B: Failed to forward tokens to C"
        );

        emit TokensReceivedAndForwarded(msg.sender, compatibleC, _amount);

        return true;
    }
}
