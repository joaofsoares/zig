const std = @import("std");
const testing = std.testing;

const Error = error{
    NotFound,
};

pub fn two_sum(nums: []const i8, target: i8) ![]usize {
    if (nums.len < 2) {
        return Error.NotFound;
    }

    const allocator = std.heap.page_allocator;

    var m = std.AutoArrayHashMap(i32, usize).init(allocator);
    defer m.deinit();

    var arr = std.ArrayList(usize).init(allocator);
    defer arr.deinit();

    for (nums, 0..) |n, i| {
        if (m.get(n)) |idx| {
            try arr.appendSlice(&.{ idx, i });
            return arr.toOwnedSlice();
        } else {
            try m.put(target - n, i);
        }
    }

    return Error.NotFound;
}

test "example 1" {
    const nums = &.{ 2, 7, 11, 15 };
    const actual = try two_sum(nums, 9);
    try testing.expectEqualSlices(usize, &.{ 0, 1 }, actual);
}

test "example 2" {
    const nums = &.{ 3, 2, 4 };
    const actual = try two_sum(nums, 6);
    try testing.expectEqualSlices(usize, &.{ 1, 2 }, actual);
}

test "example 3" {
    const nums = &.{ 3, 3 };
    const actual = try two_sum(nums, 6);
    try testing.expectEqualSlices(usize, &.{ 0, 1 }, actual);
}

test "example 4" {
    const nums = &.{ 1, 2, 3, 4, 5, 6 };
    const actual = try two_sum(nums, 9);
    try testing.expectEqualSlices(usize, &.{ 3, 4 }, actual);
}

test "Not Found < 2" {
    const nums = &.{1};
    const actual = two_sum(nums, 1);
    try testing.expectError(Error.NotFound, actual);
}

test "Not Found" {
    const nums = &.{ 1, 2, 3 };
    const actual = two_sum(nums, 7);
    try testing.expectError(Error.NotFound, actual);
}
