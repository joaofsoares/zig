const std = @import("std");
const testing = std.testing;

pub fn bsearch(items: []const u8, target: usize) ?usize {
    var left: usize = 0;
    var right = items.len;

    while (left < right) {
        const mid = left + (right - left) / 2;
        if (items[mid] == target) {
            return items[mid];
        } else if (items[mid] < target) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }

    return null;
}

test "search 1" {
    const expected: usize = 1;
    const input = [_]u8{ 1, 2, 3, 4, 5, 6 };
    const actual = bsearch(&input, 1);
    try testing.expectEqual(expected, actual);
}

test "search 2" {
    const expected: usize = 2;
    const input = [_]u8{ 1, 2, 3, 4, 5, 6 };
    const actual = bsearch(&input, 2);
    try testing.expectEqual(expected, actual);
}

test "search 3" {
    const expected: usize = 3;
    const input = [_]u8{ 1, 2, 3, 4, 5, 6 };
    const actual = bsearch(&input, 3);
    try testing.expectEqual(expected, actual);
}

test "search 4" {
    const expected: usize = 4;
    const input = [_]u8{ 1, 2, 3, 4, 5, 6 };
    const actual = bsearch(&input, 4);
    try testing.expectEqual(expected, actual);
}

test "search 5" {
    const expected: usize = 5;
    const input = [_]u8{ 1, 2, 3, 4, 5, 6 };
    const actual = bsearch(&input, 5);
    try testing.expectEqual(expected, actual);
}

test "search 6" {
    const expected = 6;
    const input = [_]u8{ 1, 2, 3, 4, 5, 6 };
    const actual = bsearch(&input, 6);
    try testing.expectEqual(expected, actual);
}

test "search bigger than array" {
    const input = [_]u8{ 1, 2, 3, 4, 5, 6 };
    const actual = bsearch(&input, 10);
    try testing.expectEqual(null, actual);
}

test "search less than array" {
    const input = [_]u8{ 4, 5, 6 };
    const actual = bsearch(&input, 1);
    try testing.expectEqual(null, actual);
}

test "unsorted array" {
    const expected = 2;
    var input = [_]u8{ 1, 9, 2, 8, 3, 7, 4, 6, 5 };
    std.mem.sort(u8, &input, {}, comptime std.sort.asc(u8));
    const actual = bsearch(&input, 2);
    try testing.expectEqual(expected, actual);
}

test "search bigger than unsorted array" {
    var input = [_]u8{ 1, 9, 2, 8, 3, 7, 4, 6, 5 };
    std.mem.sort(u8, &input, {}, comptime std.sort.asc(u8));
    const actual = bsearch(&input, 12);
    try testing.expectEqual(null, actual);
}

test "search less than unsorted array" {
    var input = [_]u8{ 9, 2, 8, 3, 7, 4, 6, 5 };
    std.mem.sort(u8, &input, {}, comptime std.sort.asc(u8));
    const actual = bsearch(&input, 1);
    try testing.expectEqual(null, actual);
}
