const std = @import("std");
const mem = std.mem;
const testing = std.testing;

const ColorBand = enum { black, brown, red, orange, yellow, green, blue, violet, grey, white };

fn labelTest(allocator: std.mem.Allocator, colors: []const ColorBand, expected: []const u8) anyerror!void {
    const actual = try label(allocator, colors);
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings(expected, actual);
}

pub fn label(allocator: mem.Allocator, colors: []const ColorBand) mem.Allocator.Error![]u8 {
    const first: u8 = @intFromEnum(colors[0]);
    const second: u8 = @intFromEnum(colors[1]);
    const multi = std.math.pow(u32, 10, @intFromEnum(colors[2]));

    const number_str: []u8 = try std.fmt.allocPrint(allocator, "{d}{d}", .{ first, second });
    defer allocator.free(number_str);

    var number: u64 = std.fmt.parseInt(u64, number_str, 10) catch 0;
    number *= multi;

    var additional_str: []const u8 = undefined;
    var float_number: f64 = 0.0;

    if (number > 1_000_000_000) {
        additional_str = "gigaohms";
        float_number = @as(f64, @floatFromInt(number)) / 1_000_000_000;
    } else if (number > 1_000_000) {
        additional_str = "megaohms";
        float_number = @as(f64, @floatFromInt(number)) / 1_000_000;
    } else if (number > 1_000) {
        additional_str = "kiloohms";
        float_number = @as(f64, @floatFromInt(number)) / 1_000;
    } else {
        float_number = @as(f64, @floatFromInt(number)) / 1;
        additional_str = "ohms";
    }

    return try std.fmt.allocPrint(allocator, "{d} {s}", .{ float_number, additional_str });
}

test "Orange and orange and black" {
    const colors = [_]ColorBand{ .orange, .orange, .black };

    const expected: []const u8 = "33 ohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "Blue and grey and brown" {
    const colors = [_]ColorBand{ .blue, .grey, .brown };

    const expected: []const u8 = "680 ohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "Red and black and red" {
    const colors = [_]ColorBand{ .red, .black, .red };

    const expected: []const u8 = "2 kiloohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "Green and brown and orange" {
    const colors = [_]ColorBand{ .green, .brown, .orange };

    const expected: []const u8 = "51 kiloohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "Yellow and violet and yellow" {
    const colors = [_]ColorBand{ .yellow, .violet, .yellow };

    const expected: []const u8 = "470 kiloohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "Blue and violet and blue" {
    const colors = [_]ColorBand{ .blue, .violet, .blue };

    const expected: []const u8 = "67 megaohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "Minimum possible value" {
    const colors = [_]ColorBand{ .black, .black, .black };

    const expected: []const u8 = "0 ohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "Maximum possible value" {
    const colors = [_]ColorBand{ .white, .white, .white };

    const expected: []const u8 = "99 gigaohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "First two colors make an invalid octal number" {
    const colors = [_]ColorBand{ .black, .grey, .black };

    const expected: []const u8 = "8 ohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "Ignore extra colors" {
    const colors = [_]ColorBand{ .blue, .green, .yellow, .orange };

    const expected: []const u8 = "650 kiloohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "Orange and orange and red" {
    const colors = [_]ColorBand{ .orange, .orange, .red };

    const expected: []const u8 = "3.3 kiloohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "Orange and orange and green" {
    const colors = [_]ColorBand{ .orange, .orange, .green };

    const expected: []const u8 = "3.3 megaohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "White and white and violet" {
    const colors = [_]ColorBand{ .white, .white, .violet };

    const expected: []const u8 = "990 megaohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}

test "White and white and grey" {
    const colors = [_]ColorBand{ .white, .white, .grey };

    const expected: []const u8 = "9.9 gigaohms";

    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        labelTest,
        .{ &colors, expected },
    );
}
