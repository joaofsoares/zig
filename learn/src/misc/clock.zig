const std = @import("std");
const testing = std.testing;

const Clock = struct {
    text: []const u8 = undefined,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, hours: i32, minutes: i32) Self {
        var total_minutes: i32 = @mod((hours * 60 + minutes), (24 * 60));

        if (total_minutes < 0) {
            total_minutes += (60 * 24);
        }

        const final_hour: u32 = @intCast(@divTrunc(total_minutes, 60));
        const final_minutes: u32 = @intCast(@mod(total_minutes, 60));

        const formatted_time = std.fmt.allocPrint(allocator, "{d:0>2}:{d:0>2}", .{ final_hour, final_minutes }) catch "00:00";

        return Self{ .text = formatted_time };
    }

    pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
        allocator.free(self.text);
    }
};

test "Clock creation - on the hour" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 8, 0);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "08:00", clock.text);
}

test "Clock creation - past the hour" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 11, 9);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "11:09", clock.text);
}

test "Clock creation - midnight" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 24, 0);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "00:00", clock.text);
}

test "Clock creation - hour rolls over" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 25, 0);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "01:00", clock.text);
}

test "Clock creation - hour rolls over continously" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 100, 0);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "04:00", clock.text);
}

test "Clock creation - sixty minutes is next hour" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 1, 60);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "02:00", clock.text);
}

test "Clock creation - minutes roll over" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 0, 160);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "02:40", clock.text);
}

test "Clock creation - minutes roll over continously" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 0, 1723);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "04:43", clock.text);
}

test "Clock creation - hour and minutes roll over" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 25, 160);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "03:40", clock.text);
}

test "Clock creation - hour and minutes roll over constinously" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 201, 3001);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "11:01", clock.text);
}

test "Clock creation - hour and minutes roll over to exactly midnight" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 72, 8640);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "00:00", clock.text);
}

test "Clock creation - negative hour" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, -1, 15);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "23:15", clock.text);
}

test "Clock creation - negative hour rolls over" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, -25, 0);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "23:00", clock.text);
}

test "Clock creation - negative hour rolls over continously" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, -91, 0);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "05:00", clock.text);
}

test "Clock creation - negative minutes" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 1, -40);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "00:20", clock.text);
}

test "Clock creation - negative minutes roll over" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 1, -160);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "22:20", clock.text);
}

test "Clock creation - negative minutes roll over continously" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 1, -4820);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "16:40", clock.text);
}

test "Clock creation - negative sixty minutes is previous hour" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, 2, -60);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "01:00", clock.text);
}

test "Clock creation - negative hour and minutes both roll over" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, -25, -160);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "20:20", clock.text);
}

test "Clock creation - negative hour and minutes both roll over continously" {
    const allocator = std.testing.allocator;
    const clock = Clock.init(allocator, -121, -5810);
    defer clock.deinit(allocator);
    try testing.expectEqualSlices(u8, "22:10", clock.text);
}
