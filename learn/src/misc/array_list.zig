const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var numbers = std.ArrayList(u32).init(allocator);
    defer numbers.deinit();

    try numbers.append(10);
    try numbers.append(20);

    for (numbers.items) |n| {
        std.debug.print("number inside array list = {d}\n", .{n});
    }
}
