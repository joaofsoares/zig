const std = @import("std");
const mem = std.mem;
const testing = std.testing;

/// Returns the selected row of the matrix.
pub fn row(allocator: mem.Allocator, s: []const u8, index: i32) ![]i16 {
    var split = mem.splitSequence(u8, s, "\n");

    var arr: std.ArrayList(i16) = .empty;
    defer arr.deinit(allocator);

    var cnt: usize = 0;
    while (split.next()) |entry| {
        if ((cnt + 1) == index) {
            var elements = mem.splitSequence(u8, entry, " ");
            while (elements.next()) |element| {
                const int_element: i16 = try std.fmt.parseInt(i16, element, 10);
                try arr.append(allocator, int_element);
            }
        }
        cnt += 1;
    }

    return arr.toOwnedSlice(allocator);
}

/// Returns the selected column of the matrix.
pub fn column(allocator: mem.Allocator, s: []const u8, index: i32) ![]i16 {
    var split = mem.splitSequence(u8, s, "\n");

    var arr: std.ArrayList(i16) = .empty;
    defer arr.deinit(allocator);

    while (split.next()) |entry| {
        var elements = mem.splitSequence(u8, entry, " ");
        var cnt: usize = 0;
        while (elements.next()) |element| {
            if ((cnt + 1) == index) {
                const int_element: i16 = try std.fmt.parseInt(i16, element, 10);
                try arr.append(allocator, int_element);
            }
            cnt += 1;
        }
    }

    return arr.toOwnedSlice(allocator);
}

test "extract row from one number matrix" {
    const expected = &[_]i16{1};

    const s = "1";

    const actual = try row(testing.allocator, s, 1);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(i16, expected, actual);
}

test "can extract row" {
    const expected = &[_]i16{ 3, 4 };

    const s = "1 2\n3 4";

    const actual = try row(testing.allocator, s, 2);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(i16, expected, actual);
}

test "extract row where numbers have different widths" {
    const expected = &[_]i16{ 10, 20 };

    const s = "1 2\n10 20";

    const actual = try row(testing.allocator, s, 2);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(i16, expected, actual);
}

test "can extract row from non-square matrix with no corresponding column" {
    const expected = &[_]i16{ 8, 7, 6 };

    const s = "1 2 3\n4 5 6\n7 8 9\n8 7 6";

    const actual = try row(testing.allocator, s, 4);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(i16, expected, actual);
}

test "extract column from one number matrix" {
    const expected = &[_]i16{1};

    const s = "1";

    const actual = try column(testing.allocator, s, 1);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(i16, expected, actual);
}

test "can extract column" {
    const expected = &[_]i16{ 3, 6, 9 };

    const s = "1 2 3\n4 5 6\n7 8 9";

    const actual = try column(testing.allocator, s, 3);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(i16, expected, actual);
}

test "can extract column from non-square matrix with no corresponding row" {
    const expected = &[_]i16{ 4, 8, 6 };

    const s = "1 2 3 4\n5 6 7 8\n9 8 7 6";

    const actual = try column(testing.allocator, s, 4);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(i16, expected, actual);
}

test "extract column where numbers have different widths" {
    const expected = &[_]i16{ 1903, 3, 4 };

    const s = "89 1903 3\n18 3 1\n9 4 800";

    const actual = try column(testing.allocator, s, 2);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(i16, expected, actual);
}

test "row with negative numbers" {
    const expected = &[_]i16{ -57, 9, -42 };

    const s = "1 2 4\n-57 9 -42\n10 0 65";

    const actual = try row(testing.allocator, s, 2);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(i16, expected, actual);
}

test "column with negative numbers" {
    const expected = &[_]i16{ -4, -42, -465 };

    const s = "1 2 -4\n-57 9 -42\n10 0 -465";

    const actual = try column(testing.allocator, s, 3);

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(i16, expected, actual);
}
