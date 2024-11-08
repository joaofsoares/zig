const std = @import("std");
const User = @import("model/user.zig").User;

pub fn main() !void {
    var u = User.init("Goku", 9001);
    std.debug.print("User[Name={s},Power={d}]\n", .{ u.name, u.power });

    u.levelUp();
    std.debug.print("After Update: User[Name={s},Power={d}]\n", .{ u.name, u.power });

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const first_string: []u8 = try allocator.alloc(u8, 5);
    defer allocator.free(first_string);

    @memcpy(first_string, "hello");
    std.debug.print("First String: {s}\n", .{first_string});

    const second_string: []u8 = try allocator.alloc(u8, 8);
    defer allocator.free(second_string);

    @memcpy(second_string, "surprise");
    std.debug.print("Second String: {s}\n", .{second_string});

    const user = try User.initPtr(allocator, "SuperPtr", 10_000);
    defer allocator.destroy(user);
    std.debug.print("User Type: {any}\n", .{@TypeOf(user)});
    std.debug.print("Pointer: User[Name={s},Power={d}]\n", .{ user.name, user.power });
}
