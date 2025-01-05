const std = @import("std");
const testing = std.testing;
const mem = std.mem;
const ascii = std.ascii;

pub fn rotate(allocator: mem.Allocator, text: []const u8, shiftKey: u5) mem.Allocator.Error![]u8 {
    const result = try allocator.alloc(u8, text.len);
    errdefer allocator.free(result);

    @memcpy(result, text);

    if (shiftKey == 0 or shiftKey == 26) {
        return result;
    } else {
        const minorStart = 'a';
        const minorLimit = 'z';
        const majorStart = 'A';
        const majorLimit = 'Z';

        for (0.., text) |idx, c| {
            if (ascii.isAlphabetic(c)) {
                if (ascii.isLower(c) and (c + shiftKey > minorLimit)) {
                    result[idx] = minorStart + (shiftKey - (minorLimit - c + 1));
                } else if (ascii.isUpper(c) and (c + shiftKey > majorLimit)) {
                    result[idx] = majorStart + (shiftKey - (majorLimit - c + 1));
                } else {
                    result[idx] = c + shiftKey;
                }
            } else {
                result[idx] = c;
            }
        }
    }

    return result;
}

test "rotate by 0" {
    const actual = try rotate(testing.allocator, "a", 0);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("a", actual);
}

test "rotate by 1" {
    const actual = try rotate(testing.allocator, "a", 1);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("b", actual);
}

test "rotate by 26" {
    const actual = try rotate(testing.allocator, "a", 26);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("a", actual);
}

test "rotate m by 13" {
    const actual = try rotate(testing.allocator, "m", 13);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("z", actual);
}

test "rotate n by 13" {
    const actual = try rotate(testing.allocator, "n", 13);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("a", actual);
}

test "rotate capital letters" {
    const actual = try rotate(testing.allocator, "OMG", 5);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("TRL", actual);
}

test "rotate spaces" {
    const actual = try rotate(testing.allocator, "O M G", 5);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("T R L", actual);
}

test "rotate numbers" {
    const actual = try rotate(testing.allocator, "Testing 1 2 3 testing", 4);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("Xiwxmrk 1 2 3 xiwxmrk", actual);
}

test "rotate punctuation" {
    const actual = try rotate(testing.allocator, "Let's eat, Grandma!", 21);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("Gzo'n zvo, Bmviyhv!", actual);
}

test "rotate all letters" {
    const actual = try rotate(testing.allocator, "The quick brown fox jumps over the lazy dog.", 13);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("Gur dhvpx oebja sbk whzcf bire gur ynml qbt.", actual);
}
