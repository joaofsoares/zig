const std = @import("std");
const testing = std.testing;

pub const SeriesError = error{
    InvalidCharacter,
    NegativeSpan,
    InsufficientDigits,
};

pub fn largestProduct(digits: []const u8, span: i32) SeriesError!u64 {
    if (span < 0) {
        return SeriesError.NegativeSpan;
    } else if (digits.len < span) {
        return SeriesError.InsufficientDigits;
    } else if (digits.len == 0 or span == 0) {
        return 1;
    } else {
        const span_usize: usize = @intCast(span);

        var prod: u64 = 1;
        var result: u64 = 0;

        var i: usize = 0;
        while ((i + span_usize) <= digits.len) : (i += 1) {
            prod = std.fmt.parseInt(u32, &[_]u8{digits[i]}, 10) catch return SeriesError.InvalidCharacter;

            for (1..span_usize) |j| {
                prod *= std.fmt.parseInt(u32, &[_]u8{digits[(i + j)]}, 10) catch return SeriesError.InvalidCharacter;
            }

            result = @max(result, prod);
        }

        return result;
    }
}

test "63915" {
    const expected: u32 = 162;
    const actual = largestProduct("63915", 3);
    try testing.expectEqual(expected, actual);
}

test "finds the largest product if span equals length" {
    const expected: u64 = 18;
    const actual = try largestProduct("29", 2);

    try testing.expectEqual(expected, actual);
}

test "can find the largest product of 2 with numbers in order" {
    const expected: u64 = 72;
    const actual = try largestProduct("0123456789", 2);

    try testing.expectEqual(expected, actual);
}

test "can find the largest product of 2" {
    const expected: u64 = 48;
    const actual = try largestProduct("576802143", 2);

    try testing.expectEqual(expected, actual);
}

test "can find the largest product of 3 with numbers in order" {
    const expected: u64 = 504;
    const actual = try largestProduct("0123456789", 3);

    try testing.expectEqual(expected, actual);
}

test "can find the largest product of 3" {
    const expected: u64 = 270;
    const actual = try largestProduct("1027839564", 3);

    try testing.expectEqual(expected, actual);
}

test "can find the largest product of 5 with numbers in order" {
    const expected: u64 = 15120;
    const actual = try largestProduct("0123456789", 5);

    try testing.expectEqual(expected, actual);
}

test "can get the largest product of a big number" {
    const expected: u64 = 23520;
    const actual = try largestProduct("73167176531330624919225119674426574742355349194934", 6);

    try testing.expectEqual(expected, actual);
}

test "reports zero if the only digits are zero" {
    const expected: u64 = 0;
    const actual = try largestProduct("0000", 2);

    try testing.expectEqual(expected, actual);
}

test "reports zero if all spans include zero" {
    const expected: u64 = 0;
    const actual = try largestProduct("99099", 3);

    try testing.expectEqual(expected, actual);
}

test "rejects span longer than string length" {
    const actual = largestProduct("123", 4);

    try testing.expectError(SeriesError.InsufficientDigits, actual);
}

test "reports 1 for empty string and empty product (0 span)" {
    const expected: u64 = 1;
    const actual = try largestProduct("", 0);

    try testing.expectEqual(expected, actual);
}

test "reports 1 for nonempty string and empty product (0 span)" {
    const expected: u64 = 1;
    const actual = try largestProduct("123", 0);

    try testing.expectEqual(expected, actual);
}

test "rejects empty string and nonzero span" {
    const actual = largestProduct("", 1);

    try testing.expectError(SeriesError.InsufficientDigits, actual);
}

test "rejects invalid character in digits" {
    const actual = largestProduct("1234a5", 2);

    try testing.expectError(SeriesError.InvalidCharacter, actual);
}

test "rejects negative span" {
    const actual = largestProduct("12345", -1);

    try testing.expectError(SeriesError.NegativeSpan, actual);
}
