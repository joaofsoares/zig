const std = @import("std");
const testing = std.testing;

pub fn isIsogram(str: []const u8) bool {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();

    var map = std.AutoHashMap(u8, bool).init(allocator);
    defer map.deinit();

    for (str) |s| {
        const sLower = std.ascii.toLower(s);

        if (map.contains(sLower)) {
            return false;
        } else if (std.ascii.isAlphabetic(sLower)) {
            map.put(sLower, true) catch unreachable;
        }
    }

    return true;
}

test "valid word: lumberjacks" {
    try testing.expect(isIsogram("lumberjacks") == true);
}

test "valid word: six-year-old" {
    try testing.expect(isIsogram("six-year-old") == true);
}

test "invalid word: AbBa" {
    try testing.expect(isIsogram("AbBa") == false);
}
