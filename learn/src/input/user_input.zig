const std = @import("std");
const ascii = std.ascii;

pub fn getUserInput(allocator: std.mem.Allocator) ![]const u8 {
    const std_in = std.io.getStdIn().reader();
    const std_out = std.io.getStdOut().writer();

    var buffer_input: [50]u8 = undefined;

    try std_out.print("Enter your name: ", .{});

    _ = try std_in.readUntilDelimiter(buffer_input[0..], '\n');

    var cnt: usize = 0;

    for (buffer_input) |character| {
        if (ascii.isAlphabetic(character)) {
            cnt += 1;
        }
    }

    const result: []u8 = buffer_input[0..cnt];
    return try allocator.dupe(u8, result);
}
