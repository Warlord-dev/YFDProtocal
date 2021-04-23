pragma solidity 0.5.7;
pragma experimental ABIEncoderV2;

import { Require } from "./Require.sol";
import { IErc20 } from "../interfaces/IErc20.sol";

library Token {

    // ============ Constants ============

    bytes32 constant FILE = "Token";

    // ============ Library Functions ============

    function balanceOf(
        address token,
        address owner
    )
        internal
        view
        returns (uint256)
    {
        return IErc20(token).balanceOf(owner);
    }

    function allowance(
        address token,
        address owner,
        address spender
    )
        internal
        view
        returns (uint256)
    {
        return IErc20(token).allowance(owner, spender);
    }

    function approve(
        address token,
        address spender,
        uint256 amount
    )
        internal
    {
        IErc20(token).approve(spender, amount);

        Require.that(
            checkSuccess(),
            FILE,
            "Approve failed"
        );
    }

    function approveMax(
        address token,
        address spender
    )
        internal
    {
        approve(
            token,
            spender,
            uint256(-1)
        );
    }

    function transfer(
        address token,
        address to,
        uint256 amount
    )
        internal
    {
        if (amount == 0 || to == address(this)) {
            return;
        }

        IErc20(token).transfer(to, amount);

        Require.that(
            checkSuccess(),
            FILE,
            "Transfer failed"
        );
    }

    function transferFrom(
        address token,
        address from,
        address to,
        uint256 amount
    )
        internal
    {
        if (amount == 0 || to == from) {
            return;
        }

        IErc20(token).transferFrom(from, to, amount);

        Require.that(
            checkSuccess(),
            FILE,
            "TransferFrom failed"
        );
    }

    // ============ Private Functions ============

    /**
     * Check the return value of the previous function up to 32 bytes. Return true if the previous
     * function returned 0 bytes or 32 bytes that are not all-zero.
     */
    function checkSuccess(
    )
        private
        pure
        returns (bool)
    {
        uint256 returnValue = 0;

        /* solium-disable-next-line security/no-inline-assembly */
        assembly {
            // check number of bytes returned from last function call
            switch returndatasize

            // no bytes returned: assume success
            case 0x0 {
                returnValue := 1
            }

            // 32 bytes returned: check if non-zero
            case 0x20 {
                // copy 32 bytes into scratch space
                returndatacopy(0x0, 0x0, 0x20)

                // load those bytes into returnValue
                returnValue := mload(0x0)
            }

            // not sure what was returned: don't mark as success
            default { }
        }

        return returnValue != 0;
    }
}
