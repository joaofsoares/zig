const std = @import("std");
const testing = std.testing;

pub fn squareRoot(radicand: usize) usize {
    if (radicand == 0 or radicand == 0) {
        return radicand;
    }

    var start: usize = 1;
    var end = radicand / 2;
    var result: usize = radicand;

    while (start <= end) {
        const mid = (start + end) / 2;

        const square = mid * mid;

        if (square == radicand) {
            return mid;
        }

        if (square <= radicand) {
            start = mid + 1;
            result = mid;
        } else {
            end = mid - 1;
        }
    }

    return result;
}

test "root of 1" {
    try testing.expectEqual(1, squareRoot(1));
}

test "root of 4" {
    try testing.expectEqual(2, squareRoot(4));
}

test "root of 25" {
    try testing.expectEqual(5, squareRoot(25));
}

test "root of 81" {
    try testing.expectEqual(9, squareRoot(81));
}

test "root of 196" {
    try testing.expectEqual(14, squareRoot(196));
}

test "root of 65025" {
    try testing.expectEqual(255, squareRoot(65025));
}
