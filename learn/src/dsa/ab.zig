const std = @import("std");
const testing = std.testing;

pub fn countAb(str: []const u8) usize {
    var cnt: usize = 0;
    var idx: usize = 0;

    while (idx < str.len) : (idx += 1) {
        if (str[idx] == 'a' and (idx + 1) < str.len and str[idx + 1] == 'b') {
            cnt += 1;
        }
    }

    return cnt;
}

test "single ab string" {
    const actual = countAb("ab");
    try testing.expectEqual(1, actual);
}

test "no ab string" {
    const actual = countAb("zz");
    try testing.expectEqual(0, actual);
}

test "double ab string" {
    const actual = countAb("abab");
    try testing.expectEqual(2, actual);
}

test "random ab string" {
    const actual = countAb("aaaaabaaaaaab");
    try testing.expectEqual(2, actual);
}
