const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub const ConversionError = error{
    InvalidInputBase,
    InvalidOutputBase,
    InvalidDigit,
};

pub fn convert(
    allocator: mem.Allocator,
    digits: []const u32,
    input_base: u32,
    output_base: u32,
) (mem.Allocator.Error || ConversionError)![]u32 {
    var arr: std.ArrayList(u32) = .empty;

    if (check_base(input_base) == false) {
        return ConversionError.InvalidInputBase;
    } else if (check_base(output_base) == false) {
        return ConversionError.InvalidOutputBase;
    }

    if (digits.len == 0) {
        try arr.append(allocator, 0);
        return try arr.toOwnedSlice(allocator);
    }

    var cnt: usize = digits.len;
    var idx: usize = 0;
    var tmp: u32 = 0;

    while (cnt > 0) {
        if (digits[idx] >= input_base) {
            return ConversionError.InvalidDigit;
        }

        tmp += digits[idx] * (std.math.pow(u32, input_base, (std.math.cast(u32, cnt).?) - 1));

        cnt -= 1;
        idx += 1;
    }

    if (tmp == 0) {
        try arr.append(allocator, 0);
        return arr.toOwnedSlice(allocator);
    }

    try convert_to(allocator, &arr, output_base, tmp);

    return arr.toOwnedSlice(allocator);
}

fn check_base(b: u32) bool {
    return b >= 2 and b <= 100;
}

fn convert_to(
    allocator: std.mem.Allocator,
    arr: *std.ArrayList(u32),
    output_base: u32,
    value: u32,
) !void {
    var tmp = value;

    while (tmp > 0) {
        const digit = tmp % output_base;
        try arr.append(allocator, digit);
        tmp /= output_base;
    }

    std.mem.reverse(u32, arr.items);

    // return arr.toOwnedSlice();
}

test "single bit one to decimal" {
    const expected = [_]u32{1};

    const digits = [_]u32{1};

    const input_base = 2;

    const output_base = 10;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "binary to single decimal" {
    const expected = [_]u32{5};

    const digits = [_]u32{ 1, 0, 1 };

    const input_base = 2;

    const output_base = 10;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "single decimal to binary" {
    const expected = [_]u32{ 1, 0, 1 };

    const digits = [_]u32{5};

    const input_base = 10;

    const output_base = 2;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "binary to multiple decimal" {
    const expected = [_]u32{ 4, 2 };

    const digits = [_]u32{ 1, 0, 1, 0, 1, 0 };

    const input_base = 2;

    const output_base = 10;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "decimal to binary" {
    const expected = [_]u32{ 1, 0, 1, 0, 1, 0 };

    const digits = [_]u32{ 4, 2 };

    const input_base = 10;

    const output_base = 2;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "trinary to hexadecimal" {
    const expected = [_]u32{ 2, 10 };

    const digits = [_]u32{ 1, 1, 2, 0 };

    const input_base = 3;

    const output_base = 16;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "hexadecimal to trinary" {
    const expected = [_]u32{ 1, 1, 2, 0 };

    const digits = [_]u32{ 2, 10 };

    const input_base = 16;

    const output_base = 3;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "15-bit integer" {
    const expected = [_]u32{ 6, 10, 45 };

    const digits = [_]u32{ 3, 46, 60 };

    const input_base = 97;

    const output_base = 73;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "empty list - second call returns different memory" {

    // The `convert` doc comment says that the caller owns the returned memory.

    // `convert` must always return memory that can be freed.

    // Test that `convert` does not return a slice that references a global array.

    const expected = [_]u32{0};

    const digits = [_]u32{};

    const input_base = 10;

    const output_base = 2;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);

    actual[0] = 1; // Modify the output!

    const again = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(again);

    try testing.expectEqualSlices(u32, &expected, again);
}

test "empty list" {
    const expected = [_]u32{0};

    const digits = [_]u32{};

    const input_base = 2;

    const output_base = 10;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "single zero" {
    const expected = [_]u32{0};

    const digits = [_]u32{0};

    const input_base = 10;

    const output_base = 2;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "multiple zeros" {
    const expected = [_]u32{0};

    const digits = [_]u32{ 0, 0, 0 };

    const input_base = 10;

    const output_base = 2;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "leading zeros" {
    const expected = [_]u32{ 4, 2 };

    const digits = [_]u32{ 0, 6, 0 };

    const input_base = 7;

    const output_base = 10;

    const actual = try convert(testing.allocator, &digits, input_base, output_base);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(u32, &expected, actual);
}

test "input base is one" {
    const expected = ConversionError.InvalidInputBase;

    const digits = [_]u32{0};

    const input_base = 1;

    const output_base = 10;

    const actual = convert(testing.allocator, &digits, input_base, output_base);

    try testing.expectError(expected, actual);
}

test "input base is zero" {
    const expected = ConversionError.InvalidInputBase;

    const digits = [_]u32{};

    const input_base = 0;

    const output_base = 10;

    const actual = convert(testing.allocator, &digits, input_base, output_base);

    try testing.expectError(expected, actual);
}

test "invalid positive digit" {
    const expected = ConversionError.InvalidDigit;

    const digits = [_]u32{ 1, 2, 1, 0, 1, 0 };

    const input_base = 2;

    const output_base = 10;

    const actual = convert(testing.allocator, &digits, input_base, output_base);

    try testing.expectError(expected, actual);
}

test "output base is one" {
    const expected = ConversionError.InvalidOutputBase;

    const digits = [_]u32{ 1, 0, 1, 0, 1, 0 };

    const input_base = 2;

    const output_base = 1;

    const actual = convert(testing.allocator, &digits, input_base, output_base);

    try testing.expectError(expected, actual);
}

test "output base is zero" {
    const expected = ConversionError.InvalidOutputBase;

    const digits = [_]u32{7};

    const input_base = 10;

    const output_base = 0;

    const actual = convert(testing.allocator, &digits, input_base, output_base);

    try testing.expectError(expected, actual);
}
