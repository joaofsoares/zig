const std = @import("std");
const testing = std.testing;

pub fn maxSubArraySum(arr: []const i8) i32 {
    var res: i32 = arr[0];
    var maxEnding: i32 = arr[0];

    for (0..arr.len) |i| {
        maxEnding = @max(maxEnding + @as(i32, arr[i]), @as(i32, arr[i]));
        res = @max(@as(i32, res), maxEnding);
    }

    return res;
}

test "[2, 3, -8, 7, -1, 2, 3]" {
    const input = [_]i8{ 2, 3, -8, 7, -1, 2, 3 };
    const actual = maxSubArraySum(&input);
    try testing.expectEqual(11, actual);
}
