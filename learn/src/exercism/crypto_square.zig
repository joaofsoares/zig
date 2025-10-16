const std = @import("std");
const mem = std.mem;
const testing = std.testing;

/// Encodes `plaintext` using the square code. Caller owns the returned memory.
pub fn ciphertext(allocator: mem.Allocator, plaintext: []const u8) mem.Allocator.Error![]u8 {
    var letters: std.ArrayList(u8) = .empty;

    for (plaintext) |c| {
        if (std.ascii.isAlphanumeric(c)) {
            try letters.append(allocator, std.ascii.toLower(c));
        }
    }

    const str = try letters.toOwnedSlice(allocator);
    defer allocator.free(str);

    const str_size = str.len;
    const str_size_sqrt: f32 = @floatFromInt(std.math.sqrt(str_size));
    var col: usize = @intFromFloat(std.math.ceil(str_size_sqrt));
    var row: usize = @intFromFloat(std.math.floor(str_size_sqrt));

    if (col * col < str_size) {
        col += 1;
        if (col * row < str_size) {
            row += 1;
        }
    }

    var answer: std.ArrayList(u8) = .empty;

    for (0..col) |j| {
        var k: usize = j;

        for (0..row) |_| {
            if (k >= str_size) {
                try answer.append(allocator, ' ');
            } else {
                try answer.append(allocator, str[k]);
            }
            k += col;
        }

        if (j < (col - 1)) {
            try answer.append(allocator, ' ');
        }
    }

    return answer.toOwnedSlice(allocator);
}

test "empty plaintext results in an empty ciphertext" {
    const expected: []const u8 = "";

    const actual = try ciphertext(testing.allocator, "");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "normalization results in empty plaintext" {
    const expected: []const u8 = "";

    const actual = try ciphertext(testing.allocator, "... --- ...");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "Lowercase" {
    const expected: []const u8 = "a";

    const actual = try ciphertext(testing.allocator, "A");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "Remove spaces" {
    const expected: []const u8 = "b";

    const actual = try ciphertext(testing.allocator, "  b ");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "Remove punctuation" {
    const expected: []const u8 = "1";

    const actual = try ciphertext(testing.allocator, "@1,%!");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "9 character plaintext results in 3 chunks of 3 characters" {
    const expected: []const u8 = "tsf hiu isn";

    const actual = try ciphertext(testing.allocator, "This is fun!");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "8 character plaintext results in 3 chunks, the last one with a trailing space" {
    const expected: []const u8 = "clu hlt io ";

    const actual = try ciphertext(testing.allocator, "Chill out.");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "54 character plaintext results in 8 chunks, the last two with trailing spaces" {
    const expected: []const u8 = "imtgdvs fearwer mayoogo anouuio ntnnlvt wttddes aohghn  sseoau ";

    const actual = try ciphertext(testing.allocator, "If man was meant to stay on the ground, god would have given us roots.");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}
