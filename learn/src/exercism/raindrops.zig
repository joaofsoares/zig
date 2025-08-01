const std = @import("std");
const testing = std.testing;

pub fn convert(buffer: []u8, n: u32) []const u8 {
    if (n == 0) {
        return buffer;
    }

    const div_three = n % 3 == 0;
    const div_five = n % 5 == 0;
    const div_seven = n % 7 == 0;

    if (div_three and div_five and div_seven) {
        return std.fmt.bufPrint(buffer, "{s}", .{"PlingPlangPlong"}) catch unreachable;
    } else if (div_three and div_five) {
        return std.fmt.bufPrint(buffer, "{s}", .{"PlingPlang"}) catch unreachable;
    } else if (div_three and div_seven) {
        return std.fmt.bufPrint(buffer, "{s}", .{"PlingPlong"}) catch unreachable;
    } else if (div_five and div_seven) {
        return std.fmt.bufPrint(buffer, "{s}", .{"PlangPlong"}) catch unreachable;
    } else if (div_seven) {
        return std.fmt.bufPrint(buffer, "{s}", .{"Plong"}) catch unreachable;
    } else if (div_five) {
        return std.fmt.bufPrint(buffer, "{s}", .{"Plang"}) catch unreachable;
    } else if (div_three) {
        return std.fmt.bufPrint(buffer, "{s}", .{"Pling"}) catch unreachable;
    } else {
        return std.fmt.bufPrint(buffer, "{d}", .{n}) catch unreachable;
    }
}

fn testConvert(comptime n: u32, expected: []const u8) !void {
    const buffer_size = 15; // The maximum length is for PlingPlangPlong

    var buffer: [buffer_size]u8 = undefined;

    const actual = convert(&buffer, n);

    try testing.expectEqualStrings(expected, actual);
}

test "the sound for 1 is 1" {
    try testConvert(1, "1");
}

test "the sound for 3 is Pling" {
    try testConvert(3, "Pling");
}

test "the sound for 5 is Plang" {
    try testConvert(5, "Plang");
}

test "the sound for 7 is Plong" {
    try testConvert(7, "Plong");
}

test "the sound for 6 is Pling as it has a factor 3" {
    try testConvert(6, "Pling");
}

test "2 to the power 3 does not make a raindrop sound as 3 is the exponent not the base" {
    try testConvert(8, "8");
}

test "the sound for 9 is Pling as it has a factor 3" {
    try testConvert(9, "Pling");
}

test "the sound for 10 is Plang as it has a factor 5" {
    try testConvert(10, "Plang");
}

test "the sound for 14 is Plong as it has a factor of 7" {
    try testConvert(14, "Plong");
}

test "the sound for 15 is PlingPlang as it has factors 3 and 5" {
    try testConvert(15, "PlingPlang");
}

test "the sound for 21 is PlingPlong as it has factors 3 and 7" {
    try testConvert(21, "PlingPlong");
}

test "the sound for 25 is Plang as it has a factor 5" {
    try testConvert(25, "Plang");
}

test "the sound for 27 is Pling as it has a factor 3" {
    try testConvert(27, "Pling");
}

test "the sound for 35 is PlangPlong as it has factors 5 and 7" {
    try testConvert(35, "PlangPlong");
}

test "the sound for 49 is Plong as it has a factor 7" {
    try testConvert(49, "Plong");
}

test "the sound for 52 is 52" {
    try testConvert(52, "52");
}

test "the sound for 105 is PlingPlangPlong as it has factors 3, 5 and 7" {
    try testConvert(105, "PlingPlangPlong");
}

test "the sound for 3125 is Plang as it has a factor 5" {
    try testConvert(3125, "Plang");
}
