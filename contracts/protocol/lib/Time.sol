pragma solidity 0.5.7;
pragma experimental ABIEncoderV2;

import { Math } from "./Math.sol";

library Time {

    // ============ Library Functions ============

    function currentTime()
        internal
        view
        returns (uint32)
    {
        return Math.to32(block.timestamp);
    }
}
