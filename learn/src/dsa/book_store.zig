const std = @import("std");
const testing = std.testing;

pub fn total(basket: []const u32) !u32 {
    var shelf = [_]u32{ 0, 0, 0, 0, 0 };

    for (basket) |book| {
        shelf[book - 1] += 1;
    }

    std.mem.sort(u32, &shelf, {}, comptime std.sort.desc(u32));

    var pos_five = shelf[4];
    var pos_four = shelf[3] - shelf[4];
    var pos_three = shelf[2] - shelf[3];
    const pos_two = shelf[1] - shelf[2];
    const pos_one = shelf[0] - shelf[1];

    const diff = @min(pos_three, pos_five);
    pos_five -= diff;
    pos_three -= diff;
    pos_four += 2 * diff;

    return (5 * pos_five * 600) + (4 * pos_four * 640) +
        (3 * pos_three * 720) + (2 * pos_two * 760) + (1 * pos_one * 800);
}

test "Only a single book" {
    const basket = &[_]u32{1};

    try testing.expectEqual(800, total(basket));
}

test "Two of the same book" {
    const basket = &[_]u32{ 2, 2 };

    try testing.expectEqual(1600, total(basket));
}

test "Empty basket" {
    const basket = &[_]u32{};

    try testing.expectEqual(0, total(basket));
}

test "Two different books" {
    const basket = &[_]u32{ 1, 2 };

    try testing.expectEqual(1520, total(basket));
}

test "Three different books" {
    const basket = &[_]u32{ 1, 2, 3 };

    try testing.expectEqual(2160, total(basket));
}

test "Four different books" {
    const basket = &[_]u32{ 1, 2, 3, 4 };

    try testing.expectEqual(2560, total(basket));
}

test "Five different books" {
    const basket = &[_]u32{ 1, 2, 3, 4, 5 };

    try testing.expectEqual(3000, total(basket));
}

test "Two groups of four is cheaper than group of five plus group of three" {
    const basket = &[_]u32{ 1, 1, 2, 2, 3, 3, 4, 5 };

    try testing.expectEqual(5120, total(basket));
}

test "Two groups of four is cheaper than groups of five and three" {
    const basket = &[_]u32{ 1, 1, 2, 3, 4, 4, 5, 5 };

    try testing.expectEqual(5120, total(basket));
}

test "Group of four plus group of two is cheaper than two groups of three" {
    const basket = &[_]u32{ 1, 1, 2, 2, 3, 4 };

    try testing.expectEqual(4080, total(basket));
}

test "Two each of first four books and one copy each of rest" {
    const basket = &[_]u32{ 1, 1, 2, 2, 3, 3, 4, 4, 5 };

    try testing.expectEqual(5560, total(basket));
}

test "Two copies of each book" {
    const basket = &[_]u32{ 1, 1, 2, 2, 3, 3, 4, 4, 5, 5 };

    try testing.expectEqual(6000, total(basket));
}

test "Three copies of first book and two each of remaining" {
    const basket = &[_]u32{ 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 1 };

    try testing.expectEqual(6800, total(basket));
}

test "Three each of first two books and two each of remaining books" {
    const basket = &[_]u32{ 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 1, 2 };

    try testing.expectEqual(7520, total(basket));
}

test "Four groups of four are cheaper than two groups each of five and three" {
    const basket = &[_]u32{ 1, 1, 2, 2, 3, 3, 4, 5, 1, 1, 2, 2, 3, 3, 4, 5 };

    try testing.expectEqual(10240, total(basket));
}

test "Check that groups of four are created properly even when there are more groups of three than groups of five" {
    const basket = &[_]u32{ 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5 };

    try testing.expectEqual(14560, total(basket));
}

test "One group of one and four is cheaper than one group of two and three" {
    const basket = &[_]u32{ 1, 1, 2, 3, 4 };

    try testing.expectEqual(3360, total(basket));
}

test "One group of one and two plus three groups of four is cheaper than one group of each size" {
    const basket = &[_]u32{ 1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5 };

    try testing.expectEqual(10000, total(basket));
}
