const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var numbers = std.ArrayList(u8).init(allocator);
    defer numbers.deinit();

    try add_to_array(&numbers, 1);
    try add_to_array(&numbers, 10);

    const ns = try numbers.toOwnedSlice();
    std.debug.print("ns = {d}\n", .{ns});

    const str = try add_str("hello", "!");
    std.debug.print("str={s}\n", .{str});

    var external_buffer: [100]u8 = undefined;
    const str_new = try add_str_buffer(&external_buffer, "hello", "!");
    std.debug.print("buffer={s}\n", .{str_new});

    const init = "initial str";
    const concated_str = try concat_str(init, ", rest of str");
    std.debug.print("concated str = {s}\n", .{concated_str});

    const allocated_str = try concat_str_with_allocator(
        allocator, 
        init, 
        ", rest of str"
    );
    std.debug.print("allocated str = {s}\n", .{allocated_str});

    const small_str = try std.fmt.allocPrint(allocator, "{s}", .{"small"});
    std.debug.print("small_str={s}\n", .{small_str});

    const hello: []const u8 = "hello";
    const another_concat = another_concat_str(hello, " there!");
    std.debug.print("another_concat={s}\n", .{another_concat});
}

fn add_to_array(
    arr: *std.ArrayList(u8), 
    n: u8
) !void {
    try arr.append(n);
}

fn add_str(
    s: []const u8, 
    rest: []const u8
) ![]u8 {
    var inside_buffer: [40]u8 = undefined;
    return try std.fmt.bufPrint(&inside_buffer, "{s}{s}", .{ s, rest });
}

fn add_str_buffer(
    buffer: []u8, 
    s: []const u8, 
    rest: []const u8
) ![]u8 {
    return try std.fmt.bufPrint(buffer, "{s}{s}", .{ s, rest });
}

fn concat_str(
    head: []const u8, 
    rest: []const u8
) ![]u8 {
    var small_buffer: [50]u8 = undefined;
    return try std.fmt.bufPrint(&small_buffer, "{s}{s}", .{ head, rest });
}

fn another_concat_str(
    comptime head: []const u8,
    comptime tail: []const u8
) []const u8 {
    return head ++ tail;
}

fn concat_str_with_allocator(
    allocator: std.mem.Allocator, 
    first: []const u8, 
    second: []const u8
) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{s}{s}", .{first, second});
}
