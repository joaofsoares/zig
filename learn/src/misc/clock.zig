const std = @import("std");
const testing = std.testing;

const text_size = 5;

const Clock = struct {
    const Self = @This();

    text: []const u8 = undefined,

    pub fn init(hour: u32, minute: u32) Self {
        var total_minutes = (hour * 60 + minute) % (24 * 60);

        if (total_minutes < 0) {
            total_minutes += 24 * 60;
        }

        const hours = total_minutes / 60;
        const minutes = total_minutes % 60;

        const formatted_text = std.fmt.allocPrint(std.heap.page_allocator, "{d:0>2}:{d:0>2}", .{ hours, minutes }) catch {
            return Self{ .text = "00:00" };
        };

        return Self{ .text = formatted_text };
    }

    pub fn deinit(self: Self) void {
        std.heap.page_allocator.free(self.text);
    }
};

test "Clock creation" {
    const clock = Clock.init(10, 30);
    try testing.expectEqualStrings("10:30", clock.text);

    const clock2 = Clock.init(25, 61);
    try testing.expectEqualStrings("02:01", clock2.text);

    const clock3 = Clock.init(8, 0);
    try testing.expectEqualStrings("08:00", clock3.text);

    const clock4 = Clock.init(0, 1723);
    try testing.expectEqualStrings("04:43", clock4.text);
}
