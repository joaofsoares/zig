const std = @import("std");
const testing = std.testing;

const Clock = struct {
    text: []const u8 = undefined,

    pub fn init(allocator: std.mem.Allocator, hours: i32, minutes: i32) Clock {
        var total_minutes: i32 = @mod((hours * 60 + minutes), (24 * 60));

        if (total_minutes < 0) {
            total_minutes += (60 * 24);
        }

        const final_hour: u32 = @intCast(@divTrunc(total_minutes, 60));
        const final_minutes: u32 = @intCast(@mod(total_minutes, 60));

        const formatted_time = std.fmt.allocPrint(allocator, "{d:0>2}:{d:0>2}", .{ final_hour, final_minutes }) catch unreachable;

        return Clock{ .text = formatted_time };
    }

    pub fn deinit(self: *const Clock, allocator: std.mem.Allocator) void {
        allocator.free(self.text);
    }

    pub fn add_minutes(self: *const Clock, allocator: std.mem.Allocator, minutes: i32) Clock {
        const hs: i32 = std.fmt.parseInt(i32, self.text[0..2], 10) catch 0;
        const ms: i32 = std.fmt.parseInt(i32, self.text[3..5], 10) catch 0;
        return init(allocator, hs, ms + minutes);
    }

    pub fn sub_minutes(self: *const Clock, allocator: std.mem.Allocator, minutes: i32) Clock {
        const hs: i32 = std.fmt.parseInt(i32, self.text[0..2], 10) catch 0;
        const ms: i32 = std.fmt.parseInt(i32, self.text[3..5], 10) catch 0;
        return init(allocator, hs, ms - minutes);
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

test "Clock addition - add minutes" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 10, 0);
    defer clock.deinit(allocator);

    const updated_clock = clock.add_minutes(allocator, 3);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "10:00", clock.text);
    try testing.expectEqualSlices(u8, "10:03", updated_clock.text);
}

test "Clock addition - no minutes" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 6, 41);
    defer clock.deinit(allocator);

    const updated_clock = clock.add_minutes(allocator, 0);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "06:41", clock.text);
    try testing.expectEqualSlices(u8, "06:41", updated_clock.text);
}

test "Clock addition - add to next hour" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 0, 45);
    defer clock.deinit(allocator);

    const updated_clock = clock.add_minutes(allocator, 40);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "00:45", clock.text);
    try testing.expectEqualSlices(u8, "01:25", updated_clock.text);
}

test "Clock addition - add more than one hour" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 10, 0);
    defer clock.deinit(allocator);

    const updated_clock = clock.add_minutes(allocator, 61);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "10:00", clock.text);
    try testing.expectEqualSlices(u8, "11:01", updated_clock.text);
}

test "Clock addition - add more than two hours with carry" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 0, 45);
    defer clock.deinit(allocator);

    const updated_clock = clock.add_minutes(allocator, 160);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "00:45", clock.text);
    try testing.expectEqualSlices(u8, "03:25", updated_clock.text);
}

test "Clock addition - add across midnight" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 23, 59);
    defer clock.deinit(allocator);

    const updated_clock = clock.add_minutes(allocator, 2);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "23:59", clock.text);
    try testing.expectEqualSlices(u8, "00:01", updated_clock.text);
}

test "Clock addition - add more than one day" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 5, 32);
    defer clock.deinit(allocator);

    const updated_clock = clock.add_minutes(allocator, 1500);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "05:32", clock.text);
    try testing.expectEqualSlices(u8, "06:32", updated_clock.text);
}

test "Clock addition - add more than two days" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 1, 1);
    defer clock.deinit(allocator);

    const updated_clock = clock.add_minutes(allocator, 3500);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "01:01", clock.text);
    try testing.expectEqualSlices(u8, "11:21", updated_clock.text);
}

test "Clock subtraction - subtract minutes" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 10, 3);
    defer clock.deinit(allocator);

    const updated_clock = clock.sub_minutes(allocator, 3);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "10:03", clock.text);
    try testing.expectEqualSlices(u8, "10:00", updated_clock.text);
}

test "Clock subtraction - subtract to previous hour" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 10, 3);
    defer clock.deinit(allocator);

    const updated_clock = clock.sub_minutes(allocator, 30);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "10:03", clock.text);
    try testing.expectEqualSlices(u8, "09:33", updated_clock.text);
}

test "Clock subtraction - subtract more than an hour" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 10, 3);
    defer clock.deinit(allocator);

    const updated_clock = clock.sub_minutes(allocator, 70);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "10:03", clock.text);
    try testing.expectEqualSlices(u8, "08:53", updated_clock.text);
}

test "Clock subtraction - subtract across midnight" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 0, 3);
    defer clock.deinit(allocator);

    const updated_clock = clock.sub_minutes(allocator, 4);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "00:03", clock.text);
    try testing.expectEqualSlices(u8, "23:59", updated_clock.text);
}

test "Clock subtraction - subtract more than two hours" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 0, 0);
    defer clock.deinit(allocator);

    const updated_clock = clock.sub_minutes(allocator, 160);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "00:00", clock.text);
    try testing.expectEqualSlices(u8, "21:20", updated_clock.text);
}

test "Clock subtraction - subtract more than two hours with borrow" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 6, 15);
    defer clock.deinit(allocator);

    const updated_clock = clock.sub_minutes(allocator, 160);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "06:15", clock.text);
    try testing.expectEqualSlices(u8, "03:35", updated_clock.text);
}

test "Clock subtraction - subtract more than one day" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 5, 32);
    defer clock.deinit(allocator);

    const updated_clock = clock.sub_minutes(allocator, 1500);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "05:32", clock.text);
    try testing.expectEqualSlices(u8, "04:32", updated_clock.text);
}

test "Clock subtraction - subtract more than two days" {
    const allocator = std.testing.allocator;

    const clock = Clock.init(allocator, 2, 20);
    defer clock.deinit(allocator);

    const updated_clock = clock.sub_minutes(allocator, 3000);
    defer updated_clock.deinit(allocator);

    try testing.expectEqualSlices(u8, "02:20", clock.text);
    try testing.expectEqualSlices(u8, "00:20", updated_clock.text);
}

test "Clock comparision - same clocks" {
    const allocator = std.testing.allocator;

    const clock1 = Clock.init(allocator, 15, 37);
    defer clock1.deinit(allocator);

    const clock2 = Clock.init(allocator, 15, 37);
    defer clock2.deinit(allocator);

    try testing.expectEqualSlices(u8, clock1.text, clock2.text);
}

test "Clock comparision - compare clocks a minute apart" {
    const allocator = std.testing.allocator;

    const clock1 = Clock.init(allocator, 15, 36);
    defer clock1.deinit(allocator);

    const clock2 = Clock.init(allocator, 15, 37);
    defer clock2.deinit(allocator);

    try testing.expect(!std.mem.eql(u8, clock1.text, clock2.text));
}

test "Clock comparision - compare clocks an hour apart" {
    const allocator = std.testing.allocator;

    const clock1 = Clock.init(allocator, 10, 37);
    defer clock1.deinit(allocator);

    const clock2 = Clock.init(allocator, 34, 37);
    defer clock2.deinit(allocator);

    try testing.expectEqualSlices(u8, clock1.text, clock2.text);
}

test "Clock comparision - compare clocks with hour overflow by several days" {
    const allocator = std.testing.allocator;

    const clock1 = Clock.init(allocator, 3, 11);
    defer clock1.deinit(allocator);

    const clock2 = Clock.init(allocator, 99, 11);
    defer clock2.deinit(allocator);

    try testing.expectEqualSlices(u8, clock1.text, clock2.text);
}

test "Clock comparision - compare clocks with negative hour" {
    const allocator = std.testing.allocator;

    const clock1 = Clock.init(allocator, 22, 40);
    defer clock1.deinit(allocator);

    const clock2 = Clock.init(allocator, -2, 40);
    defer clock2.deinit(allocator);

    try testing.expectEqualSlices(u8, clock1.text, clock2.text);
}

test "Clock comparision - compare clocks with negative hour that wraps" {
    const allocator = std.testing.allocator;

    const clock1 = Clock.init(allocator, 17, 3);
    defer clock1.deinit(allocator);

    const clock2 = Clock.init(allocator, -31, 3);
    defer clock2.deinit(allocator);

    try testing.expectEqualSlices(u8, clock1.text, clock2.text);
}

test "Clock comparision - compare clocks with negative hour that wraps multiplle times" {
    const allocator = std.testing.allocator;

    const clock1 = Clock.init(allocator, 13, 49);
    defer clock1.deinit(allocator);

    const clock2 = Clock.init(allocator, -83, 49);
    defer clock2.deinit(allocator);

    try testing.expectEqualSlices(u8, clock1.text, clock2.text);
}

test "Clock comparision - compare clocks with minute overflow" {
    const allocator = std.testing.allocator;

    const clock1 = Clock.init(allocator, 0, 1);
    defer clock1.deinit(allocator);

    const clock2 = Clock.init(allocator, 0, 1441);
    defer clock2.deinit(allocator);

    try testing.expectEqualSlices(u8, clock1.text, clock2.text);
}

test "Clock comparision - compare clocks with minute overflow by several days" {
    const allocator = std.testing.allocator;

    const clock1 = Clock.init(allocator, 2, 2);
    defer clock1.deinit(allocator);

    const clock2 = Clock.init(allocator, 2, 4322);
    defer clock2.deinit(allocator);

    try testing.expectEqualSlices(u8, clock1.text, clock2.text);
}

test "Clock comparision - compare clocks zero" {
    const allocator = std.testing.allocator;

    const clock1 = Clock.init(allocator, 24, 0);
    defer clock1.deinit(allocator);

    const clock2 = Clock.init(allocator, 0, 0);
    defer clock2.deinit(allocator);

    try testing.expectEqualSlices(u8, clock1.text, clock2.text);
}
