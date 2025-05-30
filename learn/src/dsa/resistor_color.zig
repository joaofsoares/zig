const std = @import("std");
const testing = std.testing;

const ColorBand = enum {
    black,
    brown,
    red,
    orange,
    yellow,
    green,
    blue,
    violet,
    grey,
    white,
};

pub fn colorCode(color: ColorBand) usize {
    return switch (color) {
        ColorBand.black => 0,
        ColorBand.brown => 1,
        ColorBand.red => 2,
        ColorBand.orange => 3,
        ColorBand.yellow => 4,
        ColorBand.green => 5,
        ColorBand.blue => 6,
        ColorBand.violet => 7,
        ColorBand.grey => 8,
        ColorBand.white => 9,
    };
}

pub fn colors() []const ColorBand {
    return &[_]ColorBand{ ColorBand.black, ColorBand.brown, ColorBand.red, ColorBand.orange, ColorBand.yellow, ColorBand.green, ColorBand.blue, ColorBand.violet, ColorBand.grey, ColorBand.white };
}

test "black" {
    const expected: usize = 0;
    const actual = colorCode(.black);

    try testing.expectEqual(expected, actual);
}

test "white" {
    const expected: usize = 9;
    const actual = colorCode(.white);

    try testing.expectEqual(expected, actual);
}

test "orange" {
    const expected: usize = 3;
    const actual = colorCode(.orange);

    try testing.expectEqual(expected, actual);
}

test "colors" {
    const expected = &[_]ColorBand{
        .black, .brown, .red,    .orange, .yellow,
        .green, .blue,  .violet, .grey,   .white,
    };
    const actual = colors();

    try testing.expectEqualSlices(ColorBand, expected, actual);
}
