const std = @import("std");

pub const User = struct {
    name: []const u8,
    power: u64,

    pub fn init(name: []const u8, power: u64) User {
        return .{
            .name = name,
            .power = power,
        };
    }

    pub fn initPtr(allocator: std.mem.Allocator, name: []const u8, power: u64) !*User {
        const user = try allocator.create(User);
        user.* = .{
            .name = name,
            .power = power,
        };
        return user;
    }

    pub fn levelUp(self: *User) void {
        self.power += 1;
    }
};
