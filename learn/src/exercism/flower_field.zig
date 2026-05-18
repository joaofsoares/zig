const std = @import("std");
const mem = std.mem;
const testing = std.testing;

const star = '*';

pub fn annotate(allocator: mem.Allocator, garden: []const []const u8) mem.Allocator.Error![][]u8 {
    var arr = try allocator.alloc([]u8, garden.len);
    var i: usize = 0;
    errdefer {
        var j: usize = 0;
        while (j < i) : (j += 1) {
            allocator.free(arr[j]);
        }
        allocator.free(arr);
    }

    while (i < garden.len) : (i += 1) {
        arr[i] = try allocator.dupe(u8, garden[i]);
    }

    for (0..garden.len) |x| {
        for (0..garden[x].len) |y| {
            if (garden[x][y] != star) {
                var tmp: usize = 0;

                // check top
                if (x != 0 and garden[x - 1][y] == star) {
                    tmp += 1;
                }

                // check bottom
                if (x < (garden.len - 1) and garden[x + 1][y] == star) {
                    tmp += 1;
                }

                // check left
                if (y > 0 and garden[x][y - 1] == star) {
                    tmp += 1;
                }

                // check right
                if (y < (garden[x].len - 1) and garden[x][y + 1] == star) {
                    tmp += 1;
                }

                // check diagonal top-left
                if (x > 0 and y > 0 and garden[x - 1][y - 1] == star) {
                    tmp += 1;
                }

                // check diagonal top-right
                if (x > 0 and y < (garden[x - 1].len - 1) and garden[x - 1][y + 1] == star) {
                    tmp += 1;
                }

                // check diagonal bottom-left
                if (x + 1 < garden.len and (y > 0 and y - 1 < garden[x].len) and garden[x + 1][y - 1] == star) {
                    tmp += 1;
                }

                // check diagonal bottom-right
                if (x + 1 < garden.len and (y + 1 < garden[x].len) and garden[x + 1][y + 1] == star) {
                    tmp += 1;
                }

                if (tmp == 0) {
                    arr[x][y] = ' ';
                } else {
                    arr[x][y] = @intCast(tmp + '0');
                }
            }
        }
    }

    return arr;
}

fn free(slices: [][]u8) void {
    for (slices) |slice| {
        testing.allocator.free(slice);
    }

    testing.allocator.free(slices);
}

fn annotateTest(allocator: std.mem.Allocator, expected: []const []const u8, garden: []const []const u8) !void {
    const actual = try annotate(allocator, garden);

    defer free(actual);

    try testing.expectEqual(expected.len, actual.len);

    for (0..expected.len) |i| {
        try testing.expectEqualStrings(expected[i], actual[i]);
    }
}

test "no rows" {
    const garden = [_][]const u8{};

    const expected = [_][]const u8{};

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "no columns" {
    const garden = [_][]const u8{
        "", //

    };

    const expected = [_][]const u8{
        "", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "no flowers" {
    const garden = [_][]const u8{
        "   ", //

        "   ", //

        "   ", //

    };

    const expected = [_][]const u8{
        "   ", //

        "   ", //

        "   ", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "garden full of flowers" {
    const garden = [_][]const u8{
        "***", //

        "***", //

        "***", //

    };

    const expected = [_][]const u8{
        "***", //

        "***", //

        "***", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "flower surrounded by spaces" {
    const garden = [_][]const u8{
        "   ", //

        " * ", //

        "   ", //

    };

    const expected = [_][]const u8{
        "111", //

        "1*1", //

        "111", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "space surrounded by flowers" {
    const garden = [_][]const u8{
        "***", //

        "* *", //

        "***", //

    };

    const expected = [_][]const u8{
        "***", //

        "*8*", //

        "***", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "horizontal line" {
    const garden = [_][]const u8{
        " * * ", //

    };

    const expected = [_][]const u8{
        "1*2*1", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "horizontal line, flowers at edges" {
    const garden = [_][]const u8{
        "*   *", //

    };

    const expected = [_][]const u8{
        "*1 1*", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "vertical line" {
    const garden = [_][]const u8{
        " ", //

        "*", //

        " ", //

        "*", //

        " ", //

    };

    const expected = [_][]const u8{
        "1", //

        "*", //

        "2", //

        "*", //

        "1", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "vertical line, flowers at edges" {
    const garden = [_][]const u8{
        "*", //

        " ", //

        " ", //

        " ", //

        "*", //

    };

    const expected = [_][]const u8{
        "*", //

        "1", //

        " ", //

        "1", //

        "*", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "cross" {
    const garden = [_][]const u8{
        "  *  ", //

        "  *  ", //

        "*****", //

        "  *  ", //

        "  *  ", //

    };

    const expected = [_][]const u8{
        " 2*2 ", //

        "25*52", //

        "*****", //

        "25*52", //

        " 2*2 ", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "large garden" {
    const garden = [_][]const u8{
        " *  * ", //

        "  *   ", //

        "    * ", //

        "   * *", //

        " *  * ", //

        "      ", //

    };

    const expected = [_][]const u8{
        "1*22*1", //

        "12*322", //

        " 123*2", //

        "112*4*", //

        "1*22*2", //

        "111111", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}

test "multiple adjacent flowers" {
    const garden = [_][]const u8{
        " ** ", //

    };

    const expected = [_][]const u8{
        "1**1", //

    };

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,

        annotateTest,

        .{ &expected, &garden },
    );
}
