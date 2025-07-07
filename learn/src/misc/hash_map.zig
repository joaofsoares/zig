const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var map = std.StringArrayHashMap(u32).init(allocator);
    defer map.deinit();

    try map.put("one", 1);

    if (map.get("one")) |one| {
        std.debug.print("one = {d}\n", .{one});
    }

    if (map.get("two")) |two| {
        std.debug.print("two= {d}\n", .{two});
    }
}
