const std = @import("std");

pub fn main() !void {
    one: for (0..10) |i| {
        std.debug.print("i = {d}\n", .{i});
        if (i == 2) {
            std.debug.print("break loop here\n", .{});
            break :one;
        }
    }

    std.debug.print("after loop break\n", .{});
}
