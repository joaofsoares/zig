const std = @import("std");
const testing = std.testing;

pub fn recite(buffer: []u8, start_bottles: u32, take_down: u32) []const u8 {
    var buffer_end: usize = 0;
    var bottles_num: u32 = start_bottles;

    var bottles_take_down: u32 = take_down;
    while (bottles_take_down > 0) : (bottles_take_down -= 1) {
        const first_num = get_number(bottles_num, true);
        @memcpy(buffer[buffer_end..(buffer_end + first_num.len)], first_num);
        buffer_end += first_num.len;

        const first_str = if (std.mem.eql(u8, first_num, "One")) " green bottle hanging on the wall,\n" else " green bottles hanging on the wall,\n";
        @memcpy(buffer[buffer_end..(buffer_end + first_str.len)], first_str);
        buffer_end += first_str.len;
        @memcpy(buffer[buffer_end..(buffer_end + (first_num.len + first_str.len))], buffer[(buffer_end - (first_num.len + first_str.len))..buffer_end]);
        buffer_end += (first_num.len + first_str.len);

        const neutral_phrase = "And if one green bottle should accidentally fall,\n";
        @memcpy(buffer[buffer_end..(buffer_end + neutral_phrase.len)], neutral_phrase);
        buffer_end += neutral_phrase.len;

        const initial_phrase = "There'll be ";
        @memcpy(buffer[buffer_end..(buffer_end + initial_phrase.len)], initial_phrase);
        buffer_end += initial_phrase.len;

        const second_num = get_number((bottles_num - 1), false);
        @memcpy(buffer[buffer_end..(buffer_end + second_num.len)], second_num);
        buffer_end += second_num.len;

        const end_phrase = if (std.mem.eql(u8, second_num, "one")) " green bottle hanging on the wall." else " green bottles hanging on the wall.";
        @memcpy(buffer[buffer_end..(buffer_end + end_phrase.len)], end_phrase);
        buffer_end += end_phrase.len;

        if (bottles_take_down > 1) {
            const jump = "\n\n";
            @memcpy(buffer[buffer_end..(buffer_end + jump.len)], jump);
            buffer_end += jump.len;

            bottles_num -= 1;
        }
    }

    return buffer[0..buffer_end];
}

fn get_number(n: u32, isCap: bool) []const u8 {
    return switch (n) {
        1 => if (isCap) "One" else "one",
        2 => if (isCap) "Two" else "two",
        3 => if (isCap) "Three" else "three",
        4 => if (isCap) "Four" else "four",
        5 => if (isCap) "Five" else "five",
        6 => if (isCap) "Six" else "six",
        7 => if (isCap) "Seven" else "seven",
        8 => if (isCap) "Eight" else "eight",
        9 => if (isCap) "Nine" else "nine",
        10 => if (isCap) "Ten" else "ten",
        else => if (isCap) "No" else "no",
    };
}

test "verse-single verse-first generic verse" {
    const buffer_size = 4000;
    var buffer: [buffer_size]u8 = undefined;
    const expected: []const u8 =
        \\Ten green bottles hanging on the wall,
        \\Ten green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be nine green bottles hanging on the wall.
    ;
    const actual = recite(&buffer, 10, 1);

    try testing.expectEqualStrings(expected, actual);
}

test "verse-single verse-last generic verse" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\Three green bottles hanging on the wall,
        \\Three green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be two green bottles hanging on the wall.
    ;

    const actual = recite(&buffer, 3, 1);

    try testing.expectEqualStrings(expected, actual);
}
test "verse-single verse-verse with 2 bottles" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\Two green bottles hanging on the wall,
        \\Two green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be one green bottle hanging on the wall.
    ;

    const actual = recite(&buffer, 2, 1);

    try testing.expectEqualStrings(expected, actual);
}

test "verse-single verse-verse with 1 bottle" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\One green bottle hanging on the wall,
        \\One green bottle hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be no green bottles hanging on the wall.
    ;

    const actual = recite(&buffer, 1, 1);

    try testing.expectEqualStrings(expected, actual);
}

test "lyrics-multiple verses-first two verses" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\Ten green bottles hanging on the wall,
        \\Ten green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be nine green bottles hanging on the wall.
        \\
        \\Nine green bottles hanging on the wall,
        \\Nine green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be eight green bottles hanging on the wall.
    ;

    const actual = recite(&buffer, 10, 2);

    try testing.expectEqualStrings(expected, actual);
}

test "lyrics-multiple verses-last three verses" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\Three green bottles hanging on the wall,
        \\Three green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be two green bottles hanging on the wall.
        \\
        \\Two green bottles hanging on the wall,
        \\Two green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be one green bottle hanging on the wall.
        \\
        \\One green bottle hanging on the wall,
        \\One green bottle hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be no green bottles hanging on the wall.
    ;

    const actual = recite(&buffer, 3, 3);

    try testing.expectEqualStrings(expected, actual);
}

test "lyrics-multiple verses-all verses" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\Ten green bottles hanging on the wall,
        \\Ten green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be nine green bottles hanging on the wall.
        \\
        \\Nine green bottles hanging on the wall,
        \\Nine green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be eight green bottles hanging on the wall.
        \\
        \\Eight green bottles hanging on the wall,
        \\Eight green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be seven green bottles hanging on the wall.
        \\
        \\Seven green bottles hanging on the wall,
        \\Seven green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be six green bottles hanging on the wall.
        \\
        \\Six green bottles hanging on the wall,
        \\Six green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be five green bottles hanging on the wall.
        \\
        \\Five green bottles hanging on the wall,
        \\Five green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be four green bottles hanging on the wall.
        \\
        \\Four green bottles hanging on the wall,
        \\Four green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be three green bottles hanging on the wall.
        \\
        \\Three green bottles hanging on the wall,
        \\Three green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be two green bottles hanging on the wall.
        \\
        \\Two green bottles hanging on the wall,
        \\Two green bottles hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be one green bottle hanging on the wall.
        \\
        \\One green bottle hanging on the wall,
        \\One green bottle hanging on the wall,
        \\And if one green bottle should accidentally fall,
        \\There'll be no green bottles hanging on the wall.
    ;

    const actual = recite(&buffer, 10, 10);

    try testing.expectEqualStrings(expected, actual);
}
