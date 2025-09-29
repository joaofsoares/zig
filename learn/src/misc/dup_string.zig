const std = @import("std");
const testing = std.testing;

pub fn get_dups(s: []const u8) ![]const u8 {
    const allocator = std.heap.page_allocator;

    var seen = std.AutoHashMap(u8, bool).init(allocator);
    var dups: std.ArrayList(u8) = .empty;

    for (s) |c| {
        if (seen.get(c)) |exists| {
            if (!exists) {
                try dups.append(allocator, c);
                try seen.put(c, true);
            }
        } else {
            try seen.put(c, false);
        }
    }

    return dups.toOwnedSlice(allocator);
}

test "str with dups" {
    const result = try get_dups("hello world");
    try testing.expectEqualSlices(u8, "lo", result);
}

test " str with no dups" {
    const result = try get_dups("abcdefg");
    try testing.expectEqualSlices(u8, "", result);
}
