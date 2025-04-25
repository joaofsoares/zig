const std = @import("std");
const testing = std.testing;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var numbers = try allocator.alloc(u8, 1);
    defer allocator.free(numbers);

    numbers[0] = 1;

    std.debug.print("numbers = {any}\n", .{numbers});

    numbers = try add_number(allocator, numbers, 2);

    std.debug.print("numbers = {any}\n", .{numbers});
}

fn add_number(allocator: std.mem.Allocator, numbers: []u8, n: u8) ![]u8 {
    var new_numbers = try allocator.realloc(numbers, numbers.len + 1);

    new_numbers[numbers.len] = n;

    return new_numbers;
}

test "adding a number to the array" {
    const allocator = testing.allocator;

    var numbers = try allocator.alloc(u8, 1);
    defer allocator.free(numbers);

    numbers[0] = 1;

    numbers = try add_number(allocator, numbers, 2);

    const expected = [_]u8{ 1, 2 };

    try testing.expectEqual(expected.len, numbers.len);
    try testing.expectEqualSlices(u8, &expected, numbers);
}
