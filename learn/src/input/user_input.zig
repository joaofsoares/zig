const std = @import("std");

pub fn getUserInput(allocator: std.mem.Allocator) ![]const u8 {
    const std_in = std.io.getStdIn().reader();
    const std_out = std.io.getStdOut().writer();

    try std_out.print("Enter your name: ", .{});

    var buffer_input: [50]u8 = undefined;
    const input = try std_in.readUntilDelimiter(buffer_input[0..], '\n');

    return try allocator.dupe(u8, input);
}
