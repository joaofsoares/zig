const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub const AffineCipherError = error{
    NotCoprime,
};

const alphabet_size: u8 = 26;

pub fn encode(allocator: mem.Allocator, phrase: []const u8, a: u8, b: u8) (mem.Allocator.Error || AffineCipherError)![]u8 {
    if (a % 2 == 0 or a % 13 == 0) {
        return AffineCipherError.NotCoprime;
    }

    var result = std.ArrayList(u8).empty;
    errdefer result.deinit(allocator);

    var cnt: usize = 0;
    for (phrase) |c| {
        if (std.ascii.isAlphanumeric(c)) {
            if (std.ascii.isDigit(c)) {
                try result.append(allocator, c);
            } else if (std.ascii.isAlphabetic(c)) {
                const i: u16 = std.ascii.toLower(c) - 'a';
                try result.append(allocator, @intCast((a * i + b) % alphabet_size + 'a'));
            }

            if (cnt == 4) {
                try result.append(allocator, ' ');
                cnt = 0;
            } else {
                cnt += 1;
            }
        }
    }

    if (result.getLastOrNull().? == ' ') {
        _ = result.pop();
    }

    return result.toOwnedSlice(allocator);
}

/// Decodes `phrase` using the affine cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, phrase: []const u8, a: u8, b: u8) (mem.Allocator.Error || AffineCipherError)![]u8 {
    if (a % 2 == 0 or a % 13 == 0) {
        return AffineCipherError.NotCoprime;
    }

    var result = std.ArrayList(u8).empty;
    errdefer result.deinit(allocator);

    var mni: u16 = 0;
    while (a * mni % 26 != 1) {
        mni += 1;
    }

    for (phrase) |c| {
        if (std.ascii.isAlphanumeric(c)) {
            if (std.ascii.isDigit(c)) {
                try result.append(allocator, c);
            } else if (std.ascii.isAlphabetic(c)) {
                const i: i32 = std.ascii.toLower(c) - 'a';
                try result.append(allocator, @intCast(@mod(mni * (i - b), alphabet_size) + 'a'));
            }
        }
    }

    if (result.getLastOrNull().? == ' ') {
        _ = result.pop();
    }

    return result.toOwnedSlice(allocator);
}

test "encode yes" {
    const expected: []const u8 = "xbt";
    const actual = try encode(testing.allocator, "yes", 5, 7);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "encode no" {
    const expected: []const u8 = "fu";
    const actual = try encode(testing.allocator, "no", 15, 18);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "encode OMG" {
    const expected: []const u8 = "lvz";
    const actual = try encode(testing.allocator, "OMG", 21, 3);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "encode O M G" {
    const expected: []const u8 = "hjp";
    const actual = try encode(testing.allocator, "O M G", 25, 47);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "encode mindblowingly" {
    const expected: []const u8 = "rzcwa gnxzc dgt";
    const actual = try encode(testing.allocator, "mindblowingly", 11, 15);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "encode numbers" {
    const expected: []const u8 = "jqgjc rw123 jqgjc rw";
    const actual = try encode(testing.allocator, "Testing,1 2 3, testing.", 3, 4);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "encode deep thought" {
    const expected: []const u8 = "iynia fdqfb ifje";
    const actual = try encode(testing.allocator, "Truth is fiction.", 5, 17);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "encode all the letters" {
    const expected: []const u8 = "swxtj npvyk lruol iejdc blaxk swxmh qzglf";
    const actual = try encode(testing.allocator, "The quick brown fox jumps over the lazy dog.", 17, 33);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "encode with a not coprime to m" {
    const actual = encode(testing.allocator, "This is a test.", 6, 17);
    try testing.expectError(AffineCipherError.NotCoprime, actual);
}

test "decode exercism" {
    const expected: []const u8 = "exercism";
    const actual = try decode(testing.allocator, "tytgn fjr", 3, 7);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "decode a sentence" {
    const expected: []const u8 = "anobstacleisoftenasteppingstone";
    const actual = try decode(testing.allocator, "qdwju nqcro muwhn odqun oppmd aunwd o", 19, 16);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "decode numbers" {
    const expected: []const u8 = "testing123testing";
    const actual = try decode(testing.allocator, "odpoz ub123 odpoz ub", 25, 7);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "decode all the letters" {
    const expected: []const u8 = "thequickbrownfoxjumpsoverthelazydog";
    const actual = try decode(testing.allocator, "swxtj npvyk lruol iejdc blaxk swxmh qzglf", 17, 33);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "decode with no spaces in input" {
    const expected: []const u8 = "thequickbrownfoxjumpsoverthelazydog";
    const actual = try decode(testing.allocator, "swxtjnpvyklruoliejdcblaxkswxmhqzglf", 17, 33);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "decode with too many spaces" {
    const expected: []const u8 = "jollygreengiant";
    const actual = try decode(testing.allocator, "vszzm    cly   yd cg    qdp", 15, 16);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

test "decode with a not coprime to m" {
    const actual = decode(testing.allocator, "Test", 13, 5);
    try testing.expectError(AffineCipherError.NotCoprime, actual);
}

test "encode boundary characters" {
    const expected: []const u8 = "09maz nmazn";
    const actual = try encode(testing.allocator, "/09:@AMNZ[`amnz{", 25, 12);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}
