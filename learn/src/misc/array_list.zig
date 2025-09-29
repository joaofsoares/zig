const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var numbers: std.ArrayList(u32) = .empty;
    defer numbers.deinit(allocator);

    try numbers.append(allocator, 10);
    try numbers.append(allocator, 20);

    for (numbers.items) |n| {
        std.debug.print("number inside array list = {d}\n", .{n});
    }
}
