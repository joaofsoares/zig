const std = @import("std");
const testing = std.testing;
const ArrayList = std.ArrayList;

pub fn maxPotholes(road: []const u8, budget: usize) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const roadz = try allocator.alloc(u8, road.len + 1);
    defer allocator.free(roadz);

    @memcpy(roadz[0..road.len], road);
    @memcpy(roadz[road.len..(road.len + 1)], ".");

    const cnt = try allocator.alloc(u8, road.len + 1);
    defer allocator.free(cnt);

    for (0..cnt.len) |i| {
        cnt[i] = 0;
    }

    var k: usize = 0;

    for (roadz) |c| {
        if (c == 'x') {
            k += 1;
        } else if (k > 0) {
            cnt[k] += 1;
            k = 0;
        }
    }

    var ans: usize = 0;
    k = cnt.len - 1;

    var tmpBudget: usize = budget;

    while (k > 0 and tmpBudget > 0) : (k -= 1) {
        const tmp = @min(tmpBudget / (k + 1), cnt[k]);
        ans += tmp * k;
        tmpBudget -= tmp * (k + 1);
        cnt[k - 1] += cnt[k] - tmp;
    }

    return ans;
}

test "output 0" {
    const actual = maxPotholes("..", 5);
    try testing.expectEqual(0, actual);
}

test "output 3" {
    const actual = maxPotholes("..xxxxx", 4);
    try testing.expectEqual(3, actual);
}

test "output 6" {
    const actual = maxPotholes("x.x.xxx...x", 14);
    try testing.expectEqual(6, actual);
}
