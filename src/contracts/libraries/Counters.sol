// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './Safemath.sol';

/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 */

library Counter {
    using Safemath for uint256;
 
 //build own variable type woth the keyword 'struct'

 struct Counter {
     uint256 _value;
 }

//note that storage keeps valie persistantly un;ike memory
function current(Counter storage counter) internal view returns(uint256) {
    return counter._value;
}

function increment(Counter storage counter) internal {
    counter._value += 1;
}

function decrement(Counter storage counter) internal {
    counter._value = counter._value.subtract(1);
}

}