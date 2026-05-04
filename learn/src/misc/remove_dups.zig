const std = @import("std");
const testing = std.testing;

// remove all subsequent characters until there is no more subsequent characters
pub fn remove_all(allocator: std.mem.Allocator, input: []const u8) std.mem.Allocator.Error![]u8 {
    const first = try remove_simple(allocator, input);
    defer allocator.free(first);

    const next = try remove_simple(allocator, first);

    if (!std.mem.eql(u8, first, next)) {
        defer allocator.free(next);

        var tmp_first = first;
        defer allocator.free(tmp_first);

        var tmp_next = next;

        while (!std.mem.eql(u8, tmp_first, tmp_next)) {
            tmp_first = try remove_simple(allocator, tmp_next);
            tmp_next = try remove_simple(allocator, tmp_first);
        }

        return tmp_next;
    }

    return next;
}

// remove simple subsequent characters in range of characters
pub fn remove_simple(allocator: std.mem.Allocator, input: []const u8) std.mem.Allocator.Error![]u8 {
    const input_size = input.len;

    var acc: std.ArrayList(u8) = .empty;
    errdefer acc.deinit(allocator);

    var i: usize = 0;
    while (i < input_size) {
        if (i + 1 < input_size and input[i] == input[i + 1]) {
            var tmp_idx = i;
            while (tmp_idx < input_size and input[i] == input[tmp_idx]) {
                tmp_idx += 1;
            }
            i = tmp_idx;
        } else {
            try acc.append(allocator, input[i]);
            i += 1;
        }
    }

    return acc.toOwnedSlice(allocator);
}

// testing remove simple
test "remove simple a == a" {
    const expected = "a";
    const actual = try remove_simple(testing.allocator, "a");
    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "remove simple aa == ''" {
    const expected = "";
    const actual = try remove_simple(testing.allocator, "aa");
    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "remove simple abc == abc" {
    const expected = "abc";
    const actual = try remove_simple(testing.allocator, "abc");
    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "remove simpple abbc == ac" {
    const expected = "ac";
    const actual = try remove_simple(testing.allocator, "abbc");
    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

// testing remove all
test "remove all a == a" {
    const expected = "a";
    const actual = try remove_all(testing.allocator, "a");
    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "remove all aa == ''" {
    const expected = "";
    const actual = try remove_all(testing.allocator, "aa");
    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "remove all abc == abc" {
    const expected = "abc";
    const actual = try remove_all(testing.allocator, "abc");
    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "remove all abbc == ac" {
    const expected = "ac";
    const actual = try remove_all(testing.allocator, "abbc");
    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "remove all abbbaca == ca" {
    const expected = "ca";
    const actual = try remove_all(testing.allocator, "abbbaca");
    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}
