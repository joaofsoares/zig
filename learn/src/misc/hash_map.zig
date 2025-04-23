const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var map = std.StringArrayHashMap(u32).init(allocator);
    defer map.deinit();

    try map.put("one", 1);

    const result = map.get("one").?;
    std.debug.print("result = {d}\n", .{result});
}
