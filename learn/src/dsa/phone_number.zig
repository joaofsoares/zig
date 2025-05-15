const std = @import("std");
const testing = std.testing;

pub fn clean(phrase: []const u8) ?[10]u8 {
    var result: [10]u8 = undefined;
    var number: [20]u8 = undefined;
    var cnt: usize = 0;

    for (phrase) |c| {
        if (std.ascii.isDigit(c)) {
            number[cnt] = c;
            cnt += 1;
        }
    }

    if (cnt < 10 or cnt > 11) {
        return null;
    } else if (cnt == 10) {
        if (number[0] == '0' or
            number[0] == '1' or
            number[3] == '0' or
            number[3] == '1')
        {
            return null;
        }

        result = number[0..10].*;
    } else if (cnt == 11) {
        if (number[0] != '1' or
            number[1] == '0' or
            number[1] == '1' or
            number[4] == '0' or
            number[4] == '1')
        {
            return null;
        }

        result = number[1..11].*;
    }

    return result;
}

test "cleans the number" {
    const expected: ?[10]u8 = "2234567890".*;

    const actual = clean("(223) 456-7890");

    try testing.expectEqual(expected, actual);
}

test "cleans numbers with dots" {
    const expected: ?[10]u8 = "2234567890".*;

    const actual = clean("223.456.7890");

    try testing.expectEqual(expected, actual);
}

test "cleans numbers with multiple spaces" {
    const expected: ?[10]u8 = "2234567890".*;

    const actual = clean("223 456   7890   ");

    try testing.expectEqual(expected, actual);
}

test "invalid when 9 digits" {
    const expected: ?[10]u8 = null;

    const actual = clean("123456789");

    try testing.expectEqual(expected, actual);
}

test "invalid when 11 digits does not start with a 1" {
    const expected: ?[10]u8 = null;

    const actual = clean("22234567890");

    try testing.expectEqual(expected, actual);
}

test "valid when 11 digits and starting with 1" {
    const expected: ?[10]u8 = "2234567890".*;

    const actual = clean("12234567890");

    try testing.expectEqual(expected, actual);
}

test "valid when 11 digits and starting with 1 even with punctuation" {
    const expected: ?[10]u8 = "2234567890".*;

    const actual = clean("+1 (223) 456-7890");

    try testing.expectEqual(expected, actual);
}

test "invalid when more than 11 digits" {
    const expected: ?[10]u8 = null;

    const actual = clean("321234567890");

    try testing.expectEqual(expected, actual);
}

test "invalid with letters" {
    const expected: ?[10]u8 = null;

    const actual = clean("523-abc-7890");

    try testing.expectEqual(expected, actual);
}

test "invalid with punctuations" {
    const expected: ?[10]u8 = null;

    const actual = clean("523-@:!-7890");

    try testing.expectEqual(expected, actual);
}

test "invalid if area code starts with 0" {
    const expected: ?[10]u8 = null;

    const actual = clean("(023) 456-7890");

    try testing.expectEqual(expected, actual);
}

test "invalid if area code starts with 1" {
    const expected: ?[10]u8 = null;

    const actual = clean("(123) 456-7890");

    try testing.expectEqual(expected, actual);
}

test "invalid if exchange code starts with 0" {
    const expected: ?[10]u8 = null;

    const actual = clean("(223) 056-7890");

    try testing.expectEqual(expected, actual);
}

test "invalid if exchange code starts with 1" {
    const expected: ?[10]u8 = null;

    const actual = clean("(223) 156-7890");

    try testing.expectEqual(expected, actual);
}

test "invalid if area code starts with 0 on valid 11-digit number" {
    const expected: ?[10]u8 = null;

    const actual = clean("1 (023) 456-7890");

    try testing.expectEqual(expected, actual);
}

test "invalid if area code starts with 1 on valid 11-digit number" {
    const expected: ?[10]u8 = null;

    const actual = clean("1 (123) 456-7890");

    try testing.expectEqual(expected, actual);
}

test "invalid if exchange code starts with 0 on valid 11-digit number" {
    const expected: ?[10]u8 = null;

    const actual = clean("1 (223) 056-7890");

    try testing.expectEqual(expected, actual);
}

test "invalid if exchange code starts with 1 on valid 11-digit number" {
    const expected: ?[10]u8 = null;

    const actual = clean("1 (223) 156-7890");

    try testing.expectEqual(expected, actual);
}
