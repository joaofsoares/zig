const std = @import("std");
const testing = std.testing;

pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32) []const u8 {
    var idx: usize = 0;

    for (start_verse..(end_verse + 1)) |i| {
        idx += switch (i) {
            1 => add_str(buffer, idx, "This is the house that Jack built."),
            2 => add_str(buffer, idx, "This is the malt that lay in the house that Jack built."),
            3 => add_str(buffer, idx, "This is the rat that ate the malt that lay in the house that Jack built."),
            4 => add_str(buffer, idx, "This is the cat that killed the rat that ate the malt that lay in the house that Jack built."),
            5 => add_str(buffer, idx, "This is the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built."),
            6 => add_str(buffer, idx, "This is the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built."),
            7 => add_str(buffer, idx, "This is the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built."),
            8 => add_str(buffer, idx, "This is the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built."),
            9 => add_str(buffer, idx, "This is the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built."),
            10 => add_str(buffer, idx, "This is the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built."),
            11 => add_str(buffer, idx, "This is the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built."),
            12 => add_str(buffer, idx, "This is the horse and the hound and the horn that belonged to the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built."),
            else => unreachable,
        };

        idx += if (i < end_verse) add_str(buffer, idx, "\n") else 0;
    }

    return buffer[0..idx];
}

fn add_str(buffer: []u8, idx: usize, str: []const u8) usize {
    @memcpy(buffer[idx..(idx + str.len)], str);
    return str.len;
}

test "verse one - the house that jack built" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the house that Jack built.
    ;

    const actual = recite(&buffer, 1, 1);

    try testing.expectEqualStrings(expected, actual);
}

test "verse two - the malt that lay" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 2, 2);

    try testing.expectEqualStrings(expected, actual);
}

test "verse three - the rat that ate" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 3, 3);

    try testing.expectEqualStrings(expected, actual);
}

test "verse four - the cat that killed" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the cat that killed the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 4, 4);

    try testing.expectEqualStrings(expected, actual);
}

test "verse five - the dog that worried" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 5, 5);

    try testing.expectEqualStrings(expected, actual);
}

test "verse six - the cow with the crumpled horn" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 6, 6);

    try testing.expectEqualStrings(expected, actual);
}

test "verse seven - the maiden all forlorn" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 7, 7);

    try testing.expectEqualStrings(expected, actual);
}

test "verse eight - the man all tattered and torn" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 8, 8);

    try testing.expectEqualStrings(expected, actual);
}

test "verse nine - the priest all shaven and shorn" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 9, 9);

    try testing.expectEqualStrings(expected, actual);
}

test "verse 10 - the rooster that crowed in the morn" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 10, 10);

    try testing.expectEqualStrings(expected, actual);
}

test "verse 11 - the farmer sowing his corn" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 11, 11);

    try testing.expectEqualStrings(expected, actual);
}

test "verse 12 - the horse and the hound and the horn" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the horse and the hound and the horn that belonged to the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 12, 12);

    try testing.expectEqualStrings(expected, actual);
}

test "multiple verses" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 4, 8);

    try testing.expectEqualStrings(expected, actual);
}

test "full rhyme" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\This is the house that Jack built.
        \\This is the malt that lay in the house that Jack built.
        \\This is the rat that ate the malt that lay in the house that Jack built.
        \\This is the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
        \\This is the horse and the hound and the horn that belonged to the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.
    ;

    const actual = recite(&buffer, 1, 12);

    try testing.expectEqualStrings(expected, actual);
}
