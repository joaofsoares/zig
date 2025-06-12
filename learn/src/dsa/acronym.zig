const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub fn abbreviate(allocator: mem.Allocator, comptime words: []const u8) mem.Allocator.Error![]u8 {
    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    var formatted_word: [words.len]u8 = undefined;
    _ = std.mem.replace(u8, words, "-", " ", formatted_word[0..]);
    const underscore_remove = std.mem.replace(u8, &formatted_word, "_", "", formatted_word[0..]);

    var word_split = mem.splitSequence(u8, (&formatted_word)[0..(formatted_word.len - underscore_remove)], " ");

    while (word_split.next()) |word| {
        if (word.len == 0) continue;

        try result.append(std.ascii.toUpper(word[0]));
    }

    return result.toOwnedSlice();
}

test "basic" {
    const expected = "PNG";

    const actual = try abbreviate(testing.allocator, "Portable Network Graphics");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "lowercase words" {
    const expected = "ROR";

    const actual = try abbreviate(testing.allocator, "Ruby on Rails");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "punctuation" {
    const expected = "FIFO";

    const actual = try abbreviate(testing.allocator, "First In, First Out");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "all caps word" {
    const expected = "GIMP";

    const actual = try abbreviate(testing.allocator, "GNU Image Manipulation Program");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "punctuation without whitespace" {
    const expected = "CMOS";

    const actual = try abbreviate(testing.allocator, "Complementary metal-oxide semiconductor");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "very long abbreviation" {
    const expected = "ROTFLSHTMDCOALM";

    const actual = try abbreviate(testing.allocator, "Rolling On The Floor Laughing So Hard That My Dogs Came Over And Licked Me");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "consecutive delimiters" {
    const expected = "SIMUFTA";

    const actual = try abbreviate(testing.allocator, "Something - I made up from thin air");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "apostrophes" {
    const expected = "HC";

    const actual = try abbreviate(testing.allocator, "Halley's Comet");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "underscore emphasis" {
    const expected = "TRNT";

    const actual = try abbreviate(testing.allocator, "The Road _Not_ Taken");

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}
