const std = @import("std");
const testing = std.testing;

const ColorBand = enum(u8) {
    black = '0',
    brown = '1',
    red = '2',
    orange = '3',
    yellow = '4',
    green = '5',
    blue = '6',
    violet = '7',
    grey = '8',
    white = '9',
};

pub fn colorCode(colors: [2]ColorBand) usize {
    var nums: [2]u8 = undefined;
    var nums_idx: usize = 0;

    for (colors) |color| {
        const elem: u8 = @intFromEnum(color);

        nums[nums_idx] = elem;
        nums_idx += 1;
    }

    return std.fmt.parseInt(usize, &nums, 10) catch 0;
}

test "brown and black" {
    const array = [_]ColorBand{ .brown, .black };
    const expected: usize = 10;
    const actual = colorCode(array);

    try testing.expectEqual(expected, actual);
}

test "blue and grey" {
    const array = [_]ColorBand{ .blue, .grey };
    const expected: usize = 68;
    const actual = colorCode(array);

    try testing.expectEqual(expected, actual);
}

test "yellow and violet" {
    const array = [_]ColorBand{ .yellow, .violet };
    const expected: usize = 47;
    const actual = colorCode(array);

    try testing.expectEqual(expected, actual);
}

test "white and red" {
    const array = [_]ColorBand{ .white, .red };
    const expected: usize = 92;
    const actual = colorCode(array);

    try testing.expectEqual(expected, actual);
}

test "orange and orange" {
    const array = [_]ColorBand{ .orange, .orange };
    const expected: usize = 33;
    const actual = colorCode(array);

    try testing.expectEqual(expected, actual);
}

test "black and brown, one-digit" {
    const array = [_]ColorBand{ .black, .brown };
    const expected: usize = 1;
    const actual = colorCode(array);

    try testing.expectEqual(expected, actual);
}
