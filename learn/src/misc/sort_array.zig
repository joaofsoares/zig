const std = @import("std");
const testing = std.testing;

fn sort_array(allocator: std.mem.Allocator, arr: []const i8) ![]i8 {
    const sorted_array = try allocator.alloc(i8, arr.len);

    @memcpy(sorted_array, arr[0..]);

    std.mem.sort(i8, sorted_array, {}, std.sort.asc(i8));

    return sorted_array;
}

test "simple sort array" {
    const expected = [_]i8{ 1, 2, 3 };
    const result = try sort_array(std.testing.allocator, &[_]i8{ 3, 2, 1 });
    defer std.testing.allocator.free(result);
    try testing.expectEqualSlices(i8, &expected, result);
}

test "sort array with negative numbers" {
    const expected = [_]i8{ -4, -1, -1, 0, 1, 2 };
    const result = try sort_array(std.testing.allocator, &[_]i8{ -1, 0, 1, 2, -1, -4 });
    defer std.testing.allocator.free(result);
    try testing.expectEqualSlices(i8, &expected, result);
}
