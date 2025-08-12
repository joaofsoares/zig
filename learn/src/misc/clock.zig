const std = @import("std");
const testing = std.testing;

const Clock = struct {
    const Self = @This();

    text: []const u8,

    pub fn init(hours: i32, minutes: i32) Self {
        var total_minutes: i32 = @mod((hours * 60 + minutes), (24 * 60));

        if (total_minutes < 0) {
            total_minutes += (60 * 24);
        }

        const final_hour: u32 = @intCast(@divTrunc(total_minutes, 60));
        const final_minutes: u32 = @intCast(@mod(total_minutes, 60));

        var buffer: [5]u8 = undefined;
        const result = std.fmt.bufPrint(&buffer, "{d:0>2}:{d:0>2}", .{ final_hour, final_minutes }) catch {
            return Self{ .text = "00:00" };
        };

        return Self{ .text = result };
    }
};

test "Clock creation - on the hour" {
    const clock = Clock.init(8, 0);
    try testing.expectEqualSlices(u8, "08:00", clock.text);
}

test "Clock creation - past the hour" {
    const clock = Clock.init(11, 9);
    try testing.expectEqualSlices(u8, "11:09", clock.text);
}

test "Clock creation - midnight" {
    const clock = Clock.init(24, 0);
    try testing.expectEqualSlices(u8, "00:00", clock.text);
}

test "Clock creation - hour rolls over" {
    const clock = Clock.init(25, 0);
    try testing.expectEqualSlices(u8, "01:00", clock.text);
}

test "Clock creation - hour rolls over continously" {
    const clock = Clock.init(100, 0);
    try testing.expectEqualSlices(u8, "04:00", clock.text);
}

test "Clock creation - sixty minutes is next hour" {
    const clock = Clock.init(1, 60);
    try testing.expectEqualSlices(u8, "02:00", clock.text);
}

test "Clock creation - minutes roll over" {
    const clock = Clock.init(0, 160);
    try testing.expectEqualSlices(u8, "02:40", clock.text);
}

test "Clock creation - minutes roll over continously" {
    const clock = Clock.init(0, 1723);
    try testing.expectEqualSlices(u8, "04:43", clock.text);
}

test "Clock creation - hour and minutes roll over" {
    const clock = Clock.init(25, 160);
    try testing.expectEqualSlices(u8, "03:40", clock.text);
}

test "Clock creation - hour and minutes roll over constinously" {
    const clock = Clock.init(201, 3001);
    try testing.expectEqualSlices(u8, "11:01", clock.text);
}

test "Clock creation - hour and minutes roll over to exactly midnight" {
    const clock = Clock.init(72, 8640);
    try testing.expectEqualSlices(u8, "00:00", clock.text);
}

test "Clock creation - negative hour" {
    const clock = Clock.init(-1, 15);
    try testing.expectEqualSlices(u8, "23:15", clock.text);
}

test "Clock creation - negative hour rolls over" {
    const clock = Clock.init(-25, 0);
    try testing.expectEqualSlices(u8, "23:00", clock.text);
}

test "Clock creation - negative hour rolls over continously" {
    const clock = Clock.init(-91, 0);
    try testing.expectEqualSlices(u8, "05:00", clock.text);
}

test "Clock creation - negative minutes" {
    const clock = Clock.init(1, -40);
    try testing.expectEqualSlices(u8, "00:20", clock.text);
}

test "Clock creation - negative minutes roll over" {
    const clock = Clock.init(1, -160);
    try testing.expectEqualSlices(u8, "22:20", clock.text);
}

test "Clock creation - negative minutes roll over continously" {
    const clock = Clock.init(1, -4820);
    try testing.expectEqualSlices(u8, "16:40", clock.text);
}

test "Clock creation - negative sixty minutes is previous hour" {
    const clock = Clock.init(2, -60);
    try testing.expectEqualSlices(u8, "01:00", clock.text);
}

test "Clock creation - negative hour and minutes both roll over" {
    const clock = Clock.init(-25, -160);
    try testing.expectEqualSlices(u8, "20:20", clock.text);
}

test "Clock creation - negative hour and minutes both roll over continously" {
    const clock = Clock.init(-121, -5810);
    try testing.expectEqualSlices(u8, "22:10", clock.text);
}
