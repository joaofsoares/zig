const std = @import("std");
const testing = std.testing;

const err = error{NotFound};

pub fn bsearch(arr: []const u8, number: u8) err!usize {
    return try bsearch_recurr(arr, 0, arr.len - 1, number);
}

fn bsearch_recurr(arr: []const u8, low: usize, high: usize, n: u8) err!usize {
    while (high >= low) {
        const mid: usize = low + (high - low) / 2;

        if (arr[mid] == n) {
            return mid;
        }

        if (n < arr[mid]) {
            if (mid == 0) {
                return err.NotFound;
            }

            return bsearch_recurr(arr, low, mid - 1, n);
        }

        return bsearch_recurr(arr, mid + 1, high, n);
    }

    return err.NotFound;
}

test "find 1" {
    const input = [_]u8{ 1, 2, 3, 4, 5 };
    const actual = try bsearch(&input, 1);
    try testing.expectEqual(0, actual);
    try testing.expectEqual(1, input[actual]);
}

test "find 2" {
    const input = [_]u8{ 1, 2, 3, 4, 5 };
    const actual = try bsearch(&input, 2);
    try testing.expectEqual(1, actual);
    try testing.expectEqual(2, input[actual]);
}

test "find 3" {
    const input = [_]u8{ 1, 2, 3, 4, 5 };
    const actual = try bsearch(&input, 3);
    try testing.expectEqual(2, actual);
    try testing.expectEqual(3, input[actual]);
}

test "find 4" {
    const input = [_]u8{ 1, 2, 3, 4, 5 };
    const actual = try bsearch(&input, 4);
    try testing.expectEqual(3, actual);
    try testing.expectEqual(4, input[actual]);
}

test "find 5" {
    const input = [_]u8{ 1, 2, 3, 4, 5 };
    const actual = try bsearch(&input, 5);
    try testing.expectEqual(4, actual);
    try testing.expectEqual(5, input[actual]);
}

test "find 7 not found" {
    const input = [_]u8{ 1, 2, 3, 4, 5 };
    const actual = bsearch(&input, 7);
    try testing.expectEqual(err.NotFound, actual);
}

test "find 2 not found" {
    const input = [_]u8{ 3, 4, 5, 6, 7 };
    const actual = bsearch(&input, 2);
    try testing.expectEqual(err.NotFound, actual);
}
