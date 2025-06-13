const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub fn detectAnagrams(
    allocator: mem.Allocator,
    word: []const u8,
    candidates: []const []const u8,
) !std.BufSet {
    var set = std.BufSet.init(allocator);

    var buffer = try allocator.alloc(u8, word.len);
    defer allocator.free(buffer);

    buffer = std.ascii.lowerString(buffer, word);
    std.mem.sort(u8, buffer, {}, std.sort.asc(u8));

    for (candidates) |candidate| {
        if (is_same_str(candidate, word)) continue;

        var candidate_buffer = try allocator.alloc(u8, candidate.len);
        defer allocator.free(candidate_buffer);

        candidate_buffer = std.ascii.lowerString(candidate_buffer, candidate);
        std.mem.sort(u8, candidate_buffer, {}, std.sort.asc(u8));

        if (std.mem.eql(u8, buffer, candidate_buffer)) {
            try set.insert(candidate);
        }
    }

    return set;
}

fn is_same_str(candidate: []const u8, word: []const u8) bool {
    if (candidate.len != word.len) return false;

    for (0..candidate.len) |i| {
        if (std.ascii.toLower(candidate[i]) != std.ascii.toLower(word[i])) return false;
    }

    return true;
}

fn testAnagrams(
    expected: []const []const u8,
    word: []const u8,
    candidates: []const []const u8,
) !void {
    var actual = try detectAnagrams(testing.allocator, word, candidates);

    defer actual.deinit();

    try testing.expectEqual(expected.len, actual.count());

    for (expected) |e| {
        try testing.expect(actual.contains(e));
    }
}

test "no matches" {
    const expected = [_][]const u8{};

    const word = "diaper";

    const candidates = [_][]const u8{ "hello", "world", "zombies", "pants" };

    try testAnagrams(&expected, word, &candidates);
}

test "detects two anagrams" {
    const expected = [_][]const u8{ "lemons", "melons" };

    const word = "solemn";

    const candidates = [_][]const u8{ "lemons", "cherry", "melons" };

    try testAnagrams(&expected, word, &candidates);
}

test "does not detect anagram subsets" {
    const expected = [_][]const u8{};

    const word = "good";

    const candidates = [_][]const u8{ "dog", "goody" };

    try testAnagrams(&expected, word, &candidates);
}

test "detects anagram" {
    const expected = [_][]const u8{"inlets"};

    const word = "listen";

    const candidates = [_][]const u8{ "enlists", "google", "inlets", "banana" };

    try testAnagrams(&expected, word, &candidates);
}

test "detects three anagrams" {
    const expected = [_][]const u8{ "gallery", "regally", "largely" };

    const word = "allergy";

    const candidates = [_][]const u8{ "gallery", "ballerina", "regally", "clergy", "largely", "leading" };

    try testAnagrams(&expected, word, &candidates);
}

test "detects multiple anagrams with different case" {
    const expected = [_][]const u8{ "Eons", "ONES" };

    const word = "nose";

    const candidates = [_][]const u8{ "Eons", "ONES" };

    try testAnagrams(&expected, word, &candidates);
}

test "does not detect non-anagrams with identical checksum" {
    const expected = [_][]const u8{};

    const word = "mass";

    const candidates = [_][]const u8{"last"};

    try testAnagrams(&expected, word, &candidates);
}

test "detects anagrams case-insensitively" {
    const expected = [_][]const u8{"Carthorse"};

    const word = "Orchestra";

    const candidates = [_][]const u8{ "cashregister", "Carthorse", "radishes" };

    try testAnagrams(&expected, word, &candidates);
}

test "detects anagrams using case-insensitive subject" {
    const expected = [_][]const u8{"carthorse"};

    const word = "Orchestra";

    const candidates = [_][]const u8{ "cashregister", "carthorse", "radishes" };

    try testAnagrams(&expected, word, &candidates);
}

test "detects anagrams using case-insensitive possible matches" {
    const expected = [_][]const u8{"Carthorse"};

    const word = "orchestra";

    const candidates = [_][]const u8{ "cashregister", "Carthorse", "radishes" };

    try testAnagrams(&expected, word, &candidates);
}

test "does not detect an anagram if the original word is repeated" {
    const expected = [_][]const u8{};

    const word = "go";

    const candidates = [_][]const u8{"goGoGO"};

    try testAnagrams(&expected, word, &candidates);
}

test "anagrams must use all letters exactly once" {
    const expected = [_][]const u8{};

    const word = "tapper";

    const candidates = [_][]const u8{"patter"};

    try testAnagrams(&expected, word, &candidates);
}

test "words are not anagrams of themselves" {
    const expected = [_][]const u8{};

    const word = "BANANA";

    const candidates = [_][]const u8{"BANANA"};

    try testAnagrams(&expected, word, &candidates);
}

test "words are not anagrams of themselves even if letter case is partially different" {
    const expected = [_][]const u8{};

    const word = "BANANA";

    const candidates = [_][]const u8{"Banana"};

    try testAnagrams(&expected, word, &candidates);
}

test "words are not anagrams of themselves even if letter case is completely different" {
    const expected = [_][]const u8{};

    const word = "BANANA";

    const candidates = [_][]const u8{"banana"};

    try testAnagrams(&expected, word, &candidates);
}

test "words other than themselves can be anagrams" {
    const expected = [_][]const u8{"Silent"};

    const word = "LISTEN";

    const candidates = [_][]const u8{ "LISTEN", "Silent" };

    try testAnagrams(&expected, word, &candidates);
}
