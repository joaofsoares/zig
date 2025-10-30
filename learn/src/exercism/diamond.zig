const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub fn rows(allocator: mem.Allocator, letter: u8) mem.Allocator.Error![][]u8 {
    std.debug.assert(letter >= 'A');
    std.debug.assert(letter <= 'Z');

    const str_size: usize = ((letter - 'A') + 1) * 2 - 1;
    const center = str_size / 2;

    const result = try allocator.alloc([]u8, str_size);
    errdefer allocator.free(result);

    var cnt: usize = 0;
    errdefer for (0..cnt) |i| {
        allocator.free(result[i]);
    };

    while (cnt < str_size) : (cnt += 1) {
        result[cnt] = try allocator.alloc(u8, str_size);
        @memset(result[cnt], ' ');
    }

    for (0..center + 1) |i| {
        const char = 'A' + @as(u8, @intCast(i));
        result[i][center - i] = char;
        result[i][center + i] = char;
        result[str_size - i - 1][center - i] = char;
        result[str_size - i - 1][center + i] = char;
    }

    return result;
}

fn free(slices: [][]u8) void {
    for (slices) |slice| {
        testing.allocator.free(slice);
    }
    testing.allocator.free(slices);
}

fn testRows(allocator: std.mem.Allocator, expected: []const []const u8, letter: u8) !void {
    const actual = try rows(allocator, letter);

    defer free(actual);

    try testing.expectEqual(expected.len, actual.len);

    for (0..expected.len) |i| {
        try testing.expectEqualStrings(expected[i], actual[i]);
    }
}

test "Degenerate case with a single 'A' row" {
    const expected = [_][]const u8{
        "A", //
    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        testRows,
        .{ &expected, 'A' },
    );
}

test "Degenerate case with no row containing 3 distinct groups of spaces" {
    const expected = [_][]const u8{
        " A ", //
        "B B", //
        " A ", //
    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        testRows,
        .{ &expected, 'B' },
    );
}

test "Smallest non-degenerate case with odd diamond side length" {
    const expected = [_][]const u8{
        "  A  ", //
        " B B ", //
        "C   C", //
        " B B ", //
        "  A  ", //
    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        testRows,
        .{ &expected, 'C' },
    );
}

test "Smallest non-degenerate case with even diamond side length" {
    const expected = [_][]const u8{
        "   A   ", //
        "  B B  ", //
        " C   C ", //
        "D     D", //
        " C   C ", //
        "  B B  ", //
        "   A   ", //
    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        testRows,
        .{ &expected, 'D' },
    );
}

test "Largest possible diamond" {
    const expected = [_][]const u8{
        "                         A                         ", //
        "                        B B                        ", //
        "                       C   C                       ", //
        "                      D     D                      ", //
        "                     E       E                     ", //
        "                    F         F                    ", //
        "                   G           G                   ", //
        "                  H             H                  ", //
        "                 I               I                 ", //
        "                J                 J                ", //
        "               K                   K               ", //
        "              L                     L              ", //
        "             M                       M             ", //
        "            N                         N            ", //
        "           O                           O           ", //
        "          P                             P          ", //
        "         Q                               Q         ", //
        "        R                                 R        ", //
        "       S                                   S       ", //
        "      T                                     T      ", //
        "     U                                       U     ", //
        "    V                                         V    ", //
        "   W                                           W   ", //
        "  X                                             X  ", //
        " Y                                               Y ", //
        "Z                                                 Z", //
        " Y                                               Y ", //
        "  X                                             X  ", //
        "   W                                           W   ", //
        "    V                                         V    ", //
        "     U                                       U     ", //
        "      T                                     T      ", //
        "       S                                   S       ", //
        "        R                                 R        ", //
        "         Q                               Q         ", //
        "          P                             P          ", //
        "           O                           O           ", //
        "            N                         N            ", //
        "             M                       M             ", //
        "              L                     L              ", //
        "               K                   K               ", //
        "                J                 J                ", //
        "                 I               I                 ", //
        "                  H             H                  ", //
        "                   G           G                   ", //
        "                    F         F                    ", //
        "                     E       E                     ", //
        "                      D     D                      ", //
        "                       C   C                       ", //
        "                        B B                        ", //
        "                         A                         ", //
    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        testRows,
        .{ &expected, 'Z' },
    );
}
