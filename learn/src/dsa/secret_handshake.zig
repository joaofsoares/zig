const std = @import("std");
const mem = std.mem;
const testing = std.testing;

const Signal = enum {
    wink,
    double_blink,
    close_your_eyes,
    jump,
};

pub fn calculateHandshake(allocator: mem.Allocator, number: u5) mem.Allocator.Error![]const Signal {
    var arr = std.ArrayList(Signal).init(allocator);
    defer arr.deinit();

    const binary_string = try std.fmt.allocPrint(allocator, "{b}", .{number});
    defer allocator.free(binary_string);

    var decimal: u32 = 1;
    var cnt = binary_string.len;

    while (cnt > 0) {
        if (binary_string[cnt - 1] == '1') {
            switch (decimal) {
                1 => try arr.append(.wink),
                10 => try arr.append(.double_blink),
                100 => try arr.append(.close_your_eyes),
                1000 => try arr.append(.jump),
                else => std.mem.reverse(Signal, arr.items),
            }
        }

        decimal *= 10;
        cnt -= 1;
    }

    return arr.toOwnedSlice();
}

test "wink for 1" {
    const expected = &[_]Signal{.wink};

    const actual = try calculateHandshake(testing.allocator, 1);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "double blink for 10" {
    const expected = &[_]Signal{.double_blink};

    const actual = try calculateHandshake(testing.allocator, 2);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "close your eyes for 100" {
    const expected = &[_]Signal{.close_your_eyes};

    const actual = try calculateHandshake(testing.allocator, 4);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "jump for 1000" {
    const expected = &[_]Signal{.jump};

    const actual = try calculateHandshake(testing.allocator, 8);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "combine two actions" {
    const expected = &[_]Signal{ .wink, .double_blink };

    const actual = try calculateHandshake(testing.allocator, 3);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "reverse two actions" {
    const expected = &[_]Signal{ .double_blink, .wink };

    const actual = try calculateHandshake(testing.allocator, 19);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "reversing one action gives the same action" {
    const expected = &[_]Signal{.jump};

    const actual = try calculateHandshake(testing.allocator, 24);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "reversing no actions still gives no actions" {
    const expected = &[_]Signal{};

    const actual = try calculateHandshake(testing.allocator, 16);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "all possible actions" {
    const expected = &[_]Signal{ .wink, .double_blink, .close_your_eyes, .jump };

    const actual = try calculateHandshake(testing.allocator, 15);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "reverse all possible actions" {
    const expected = &[_]Signal{ .jump, .close_your_eyes, .double_blink, .wink };

    const actual = try calculateHandshake(testing.allocator, 31);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}

test "do nothing for zero" {
    const expected = &[_]Signal{};

    const actual = try calculateHandshake(testing.allocator, 0);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Signal, expected, actual);
}
