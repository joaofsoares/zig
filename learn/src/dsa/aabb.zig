const std = @import("std");
const testing = std.testing;

pub fn countStr(str: []const u8) usize {
    const str_size = str.len;

    var idx: usize = 0;
    var cnt: usize = 0;

    while (idx < str_size) {
        if (str[idx] == 'a' and (idx + 4 <= str_size) and checker(str[idx..(idx + 4)])) {
            cnt += 1;
            idx += 4;
        } else {
            idx += 1;
        }
    }

    return cnt;
}

fn checker(input: []const u8) bool {
    return std.mem.eql(u8, input, "aabb");
}

test "single aabb string" {
    const actual = countStr("aabb");
    try testing.expectEqual(1, actual);
}

test "no aabb string" {
    const actual = countStr("zabx");
    try testing.expectEqual(0, actual);
}

test "aabb in the end of string" {
    const actual = countStr("sksahdfkaskfaaabb");
    try testing.expectEqual(1, actual);
}

test "double aabb string" {
    const actual = countStr("aabbaabb");
    try testing.expectEqual(2, actual);
}

test "internal aabb string" {
    const actual = countStr("aaaabbabbbaaaaabbbbb");
    try testing.expectEqual(2, actual);
}
