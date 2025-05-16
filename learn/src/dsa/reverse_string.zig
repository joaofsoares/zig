const std = @import("std");
const testing = std.testing;

pub fn reverse(buffer: []u8, s: []const u8) []u8 {
    if (s.len == 0) {
        return "";
    }

    var s_size: usize = s.len - 1;
    var idx: usize = 0;

    while (s_size >= 0) : (idx += 1) {
        buffer[idx] = s[s_size];

        if (s_size == 0) {
            break;
        }

        s_size -= 1;
    }

    return buffer;
}

fn testReverse(comptime s: []const u8, expected: []const u8) !void {
    var buffer: [s.len]u8 = undefined;

    const actual = reverse(&buffer, s);

    try testing.expectEqualStrings(expected, actual);
}

test "an empty string" {
    try testReverse("", "");
}

test "a word" {
    try testReverse("robot", "tobor");
}

test "a capitalized word" {
    try testReverse("Ramen", "nemaR");
}

test "a sentence with punctuation" {
    try testReverse("I'm hungry!", "!yrgnuh m'I");
}

test "a palindrome" {
    try testReverse("racecar", "racecar");
}

test "an even-sized word" {
    try testReverse("drawer", "reward");
}
