const std = @import("std");

const CliError = error 
{
    InvalidParameter,
};

pub fn main() !void 
{
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 4)
    {
        std.debug.print("Error passing parameters\n", .{});
        return CliError.InvalidParameter;
    } 

    const spark_script = args[1];
    const from_table_name = args[2];
    const to_table_name = args[3];

    std.debug.print("Spark Script = {s}\n", .{spark_script});
    std.debug.print("From Table Name = {s}\n", .{from_table_name});
    std.debug.print("To Table Name = {s}\n", .{to_table_name});
    std.debug.print("Spark Submit Script = {s} {s} {s} {s}\n", .{"spark-submit --class", spark_script, from_table_name, to_table_name});

    var cmd = std.process.Child.init(&[_][]const u8{ "echo", "hello", "there" }, allocator);
    try cmd.spawn();
    // in a real application you'd not want to ignore the status here probably
    const exited = try cmd.wait();
    if (exited.Exited == 0)
    {
        std.debug.print("Command executed\n", .{});
    }
}
