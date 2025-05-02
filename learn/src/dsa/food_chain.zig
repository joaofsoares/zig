const std = @import("std");
const testing = std.testing;

const Food = enum {
    Fly,
    Spider,
    Bird,
    Cat,
    Dog,
    Goat,
    Cow,
    Horse,
};

pub fn recite(buffer: []u8, start_verse: u32, end_verse: u32) []const u8 {
    var idx: usize = 0;

    for (start_verse..(end_verse + 1)) |i| {
        idx += switch (i) {
            1 => add_str(buffer, idx, generate_verse(Food.Fly)),
            2 => add_str(buffer, idx, generate_verse(Food.Spider)),
            3 => add_str(buffer, idx, generate_verse(Food.Bird)),
            4 => add_str(buffer, idx, generate_verse(Food.Cat)),
            5 => add_str(buffer, idx, generate_verse(Food.Dog)),
            6 => add_str(buffer, idx, generate_verse(Food.Goat)),
            7 => add_str(buffer, idx, generate_verse(Food.Cow)),
            8 => add_str(buffer, idx, generate_verse(Food.Horse)),
            else => 0,
        };

        idx += if (i < end_verse) add_str(buffer, idx, "\n\n") else 0;
    }

    return buffer[0..idx];
}

fn swallowed_food(food: Food) []const u8 {
    return switch (food) {
        Food.Fly => "I know an old lady who swallowed a fly.\n",
        Food.Spider => "I know an old lady who swallowed a spider.\n",
        Food.Bird => "I know an old lady who swallowed a bird.\n",
        Food.Cat => "I know an old lady who swallowed a cat.\n",
        Food.Dog => "I know an old lady who swallowed a dog.\n",
        Food.Goat => "I know an old lady who swallowed a goat.\n",
        Food.Cow => "I know an old lady who swallowed a cow.\n",
        Food.Horse => "I know an old lady who swallowed a horse.\n",
    };
}

fn action(food: Food) []const u8 {
    return switch (food) {
        Food.Spider => "It wriggled and jiggled and tickled inside her.\n",
        Food.Bird => "How absurd to swallow a bird!\n",
        Food.Cat => "Imagine that, to swallow a cat!\n",
        Food.Dog => "What a hog, to swallow a dog!\n",
        Food.Goat => "Just opened her throat and swallowed a goat!\n",
        Food.Cow => "I don't know how she swallowed a cow!\n",
        else => "",
    };
}

fn create_end_verse(food: Food) []const u8 {
    return switch (food) {
        Food.Horse => "She's dead, of course!",
        else => "I don't know why she swallowed the fly. Perhaps she'll die.",
    };
}

fn generate_regression(food: Food) []const u8 {
    return switch (food) {
        Food.Spider => "She swallowed the spider to catch the fly.\n",
        Food.Bird => "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\nShe swallowed the spider to catch the fly.\n",
        Food.Cat => "She swallowed the cat to catch the bird.\nShe swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\nShe swallowed the spider to catch the fly.\n",
        Food.Dog => "She swallowed the dog to catch the cat.\nShe swallowed the cat to catch the bird.\nShe swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\nShe swallowed the spider to catch the fly.\n",
        Food.Goat => "She swallowed the goat to catch the dog.\nShe swallowed the dog to catch the cat.\nShe swallowed the cat to catch the bird.\nShe swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\nShe swallowed the spider to catch the fly.\n",
        Food.Cow => "She swallowed the cow to catch the goat.\nShe swallowed the goat to catch the dog.\nShe swallowed the dog to catch the cat.\nShe swallowed the cat to catch the bird.\nShe swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\nShe swallowed the spider to catch the fly.\n",
        else => "",
    };
}

fn generate_verse(food: Food) []const u8 {
    var buffer: [4000]u8 = undefined;

    const swallowed = swallowed_food(food);
    const action_str = action(food);
    const regression = generate_regression(food);
    const end_verse = create_end_verse(food);

    _ = std.fmt.bufPrint(&buffer, "{s}{s}{s}{s}", .{ swallowed, action_str, regression, end_verse }) catch "nothing";

    return buffer[0..(swallowed.len + action_str.len + regression.len + end_verse.len)];
}

fn add_str(buffer: []u8, idx: usize, str: []const u8) usize {
    @memcpy(buffer[idx..(idx + str.len)], str);
    return str.len;
}

test "fly" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\I know an old lady who swallowed a fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
    ;

    const actual = recite(&buffer, 1, 1);

    try testing.expectEqualStrings(expected, actual);
}

test "spider" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\I know an old lady who swallowed a spider.
        \\It wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
    ;

    const actual = recite(&buffer, 2, 2);

    try testing.expectEqualStrings(expected, actual);
}

test "bird" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\I know an old lady who swallowed a bird.
        \\How absurd to swallow a bird!
        \\She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
    ;

    const actual = recite(&buffer, 3, 3);

    try testing.expectEqualStrings(expected, actual);
}

test "cat" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\I know an old lady who swallowed a cat.
        \\Imagine that, to swallow a cat!
        \\She swallowed the cat to catch the bird.
        \\She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
    ;

    const actual = recite(&buffer, 4, 4);

    try testing.expectEqualStrings(expected, actual);
}

test "dog" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\I know an old lady who swallowed a dog.
        \\What a hog, to swallow a dog!
        \\She swallowed the dog to catch the cat.
        \\She swallowed the cat to catch the bird.
        \\She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
    ;

    const actual = recite(&buffer, 5, 5);

    try testing.expectEqualStrings(expected, actual);
}

test "goat" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\I know an old lady who swallowed a goat.
        \\Just opened her throat and swallowed a goat!
        \\She swallowed the goat to catch the dog.
        \\She swallowed the dog to catch the cat.
        \\She swallowed the cat to catch the bird.
        \\She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
    ;

    const actual = recite(&buffer, 6, 6);

    try testing.expectEqualStrings(expected, actual);
}

test "cow" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\I know an old lady who swallowed a cow.
        \\I don't know how she swallowed a cow!
        \\She swallowed the cow to catch the goat.
        \\She swallowed the goat to catch the dog.
        \\She swallowed the dog to catch the cat.
        \\She swallowed the cat to catch the bird.
        \\She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
    ;

    const actual = recite(&buffer, 7, 7);

    try testing.expectEqualStrings(expected, actual);
}

test "horse" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\I know an old lady who swallowed a horse.
        \\She's dead, of course!
    ;

    const actual = recite(&buffer, 8, 8);

    try testing.expectEqualStrings(expected, actual);
}

test "multiple verses" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\I know an old lady who swallowed a fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
        \\
        \\I know an old lady who swallowed a spider.
        \\It wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
        \\
        \\I know an old lady who swallowed a bird.
        \\How absurd to swallow a bird!
        \\She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
    ;

    const actual = recite(&buffer, 1, 3);

    try testing.expectEqualStrings(expected, actual);
}

test "full song" {
    const buffer_size = 4000;

    var buffer: [buffer_size]u8 = undefined;

    const expected: []const u8 =
        \\I know an old lady who swallowed a fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
        \\
        \\I know an old lady who swallowed a spider.
        \\It wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
        \\
        \\I know an old lady who swallowed a bird.
        \\How absurd to swallow a bird!
        \\She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
        \\
        \\I know an old lady who swallowed a cat.
        \\Imagine that, to swallow a cat!
        \\She swallowed the cat to catch the bird.
        \\She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
        \\
        \\I know an old lady who swallowed a dog.
        \\What a hog, to swallow a dog!
        \\She swallowed the dog to catch the cat.
        \\She swallowed the cat to catch the bird.
        \\She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
        \\
        \\I know an old lady who swallowed a goat.
        \\Just opened her throat and swallowed a goat!
        \\She swallowed the goat to catch the dog.
        \\She swallowed the dog to catch the cat.
        \\She swallowed the cat to catch the bird.
        \\She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
        \\
        \\I know an old lady who swallowed a cow.
        \\I don't know how she swallowed a cow!
        \\She swallowed the cow to catch the goat.
        \\She swallowed the goat to catch the dog.
        \\She swallowed the dog to catch the cat.
        \\She swallowed the cat to catch the bird.
        \\She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.
        \\She swallowed the spider to catch the fly.
        \\I don't know why she swallowed the fly. Perhaps she'll die.
        \\
        \\I know an old lady who swallowed a horse.
        \\She's dead, of course!
    ;

    const actual = recite(&buffer, 1, 8);

    try testing.expectEqualStrings(expected, actual);
}
