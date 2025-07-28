const std = @import("std");
const testing = std.testing;

pub fn encode(buffer: []u8, string: []const u8) []u8 {
    if (string.len == 0) {
        return "";
    }

    var buffer_idx: usize = 0;
    var cnt: usize = 1;

    for (0..string.len) |i| {
        if (i < (string.len - 1) and string[i] == string[i + 1]) {
            cnt += 1;
        } else {
            if (cnt > 1) {
                var buffer_cnt: [3]u8 = undefined;
                const buffer_str = std.fmt.bufPrint(&buffer_cnt, "{d}", .{cnt}) catch unreachable;
                for (buffer_str) |bs| {
                    buffer[buffer_idx] = bs;
                    buffer_idx += 1;
                }
            }

            buffer[buffer_idx] = string[i];
            buffer_idx += 1;

            cnt = 1;
        }
    }

    return buffer[0..buffer_idx];
}

pub fn decode(buffer: []u8, string: []const u8) []u8 {
    if (string.len == 0) {
        return "";
    }

    var buffer_idx: usize = 0;
    var digit_size: usize = 0;
    var letter: u8 = undefined;

    for (0..string.len) |i| {
        if (std.ascii.isDigit(string[i])) {
            digit_size += 1;
            continue;
        } else {
            letter = string[i];
        }

        if (digit_size > 0) {
            const digit = string[(i - digit_size)..i];

            const number = std.fmt.parseInt(usize, digit, 10) catch 0;

            for (0..number) |_| {
                buffer[buffer_idx] = letter;
                buffer_idx += 1;
            }

            digit_size = 0;
        } else {
            buffer[buffer_idx] = letter;
            buffer_idx += 1;
        }
    }

    return buffer[0..buffer_idx];
}

test "encoder empty string" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "";
    const actual: []u8 = encode(&buffer, "");

    try testing.expectEqualStrings(expected, actual);
}

test "encode AAB" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "2AB";
    const actual: []u8 = encode(&buffer, "AAB");

    try testing.expectEqualStrings(expected, actual);
}

test "encode AABCCCDEEEE" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "2AB3CD4E";
    const actual: []u8 = encode(&buffer, "AABCCCDEEEE");

    try testing.expectEqualStrings(expected, actual);
}

test "encode XYZ" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "XYZ";
    const actual: []u8 = encode(&buffer, "XYZ");

    try testing.expectEqualStrings(expected, actual);
}

test "encode AABBBCCCC" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "2A3B4C";
    const actual: []u8 = encode(&buffer, "AABBBCCCC");

    try testing.expectEqualStrings(expected, actual);
}

test "encode WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "12WB12W3B24WB";
    const actual: []u8 = encode(&buffer, "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB");

    try testing.expectEqualStrings(expected, actual);
}

test "encode '  hsqq qww  '" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "2 hs2q q2w2 ";
    const actual: []u8 = encode(&buffer, "  hsqq qww  ");

    try testing.expectEqualStrings(expected, actual);
}

test "encode aabbbcccc" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "2a3b4c";
    const actual: []u8 = encode(&buffer, "aabbbcccc");

    try testing.expectEqualStrings(expected, actual);
}

test "decode empty string" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "";
    const actual: []u8 = decode(&buffer, "");

    try testing.expectEqualStrings(expected, actual);
}

test "decode XYZ" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "XYZ";
    const actual: []u8 = decode(&buffer, "XYZ");

    try testing.expectEqualStrings(expected, actual);
}

test "decode 2A3B4C" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "AABBBCCCC";
    const actual: []u8 = decode(&buffer, "2A3B4C");

    try testing.expectEqualStrings(expected, actual);
}

test "decode 12WB12W3B24WB" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWB";
    const actual: []u8 = decode(&buffer, "12WB12W3B24WB");

    try testing.expectEqualStrings(expected, actual);
}

test "decode '2 hs2q q2w2 '" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "  hsqq qww  ";
    const actual: []u8 = decode(&buffer, "2 hs2q q2w2 ");

    try testing.expectEqualStrings(expected, actual);
}

test "decode 2a3b4c" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "aabbbcccc";
    const actual: []u8 = decode(&buffer, "2a3b4c");

    try testing.expectEqualStrings(expected, actual);
}

test "decode zzz ZZ  zZ" {
    const buffer_size = 80;
    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 = "zzz ZZ  zZ";
    const actual: []u8 = decode(&buffer, "zzz ZZ  zZ");

    try testing.expectEqualStrings(expected, actual);
}
