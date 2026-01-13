const std = @import("std");
const testing = std.testing;

pub const ChessboardError = error{
    IndexOutOfBounds,
};

pub fn square(index: usize) ChessboardError!u64 {
    if (index > 0 and index < 65) {
        var grains: u64 = 1;
        for (1..index) |_| {
            grains = grains * 2;
        }
        return grains;
    }

    return ChessboardError.IndexOutOfBounds;
}

pub fn total() u64 {
    return (1 << 64) - 1;
}

test "testing square 1" {
    try testing.expect(try square(1) == 1);
}

test "testing square 2" {
    try testing.expect(try square(2) == 2);
}

test "testing square 3" {
    try testing.expect(try square(3) == 4);
}

test "testing square 4" {
    try testing.expect(try square(4) == 8);
}

test "testing square 16" {
    try testing.expect(try square(16) == 32_768);
}

test "testing square 32" {
    try testing.expect(try square(32) == 2_147_483_648);
}

test "testing square 64" {
    try testing.expect(try square(64) == 9_223_372_036_854_775_808);
}

test "testing square 0" {
    const expected = ChessboardError.IndexOutOfBounds;
    const actual = square(0);
    try testing.expectError(expected, actual);
}

test "testing square 65" {
    const expected = ChessboardError.IndexOutOfBounds;
    const actual = square(65);
    try testing.expectError(expected, actual);
}

test "testing get total" {
    const expected: u64 = 18_446_744_073_709_551_615;
    const actual = total();
    try testing.expectEqual(expected, actual);
}
