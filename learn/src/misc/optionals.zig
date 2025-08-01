const std = @import("std");

pub fn main() void {
    const number: ?u32 = 10;
    std.debug.print("number = {d}\n", .{number.?});

    if (number) |n| {
        std.debug.print("number = {d}\n", .{n});
    }
}
