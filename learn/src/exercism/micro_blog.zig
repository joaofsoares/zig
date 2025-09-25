const std = @import("std");
const testing = std.testing;

pub fn truncate(phrase: []const u8) []const u8 {
    if (phrase.len > 5) {
        const view = std.unicode.Utf8View.init(phrase) catch unreachable;
        var iter = view.iterator();
        return iter.peek(5);
    }

    return phrase;
}

test "English language short" {
    const expected: []const u8 = "Hi";

    const actual = truncate("Hi");

    try testing.expectEqualStrings(expected, actual);
}

test "English language long" {
    const expected: []const u8 = "Hello";

    const actual = truncate("Hello there");

    try testing.expectEqualStrings(expected, actual);
}

test "German language short (broth)" {
    const expected: []const u8 = "brühe";

    const actual = truncate("brühe");

    try testing.expectEqualStrings(expected, actual);
}

test "German language long (bear carpet → beards)" {
    const expected: []const u8 = "Bärte";

    const actual = truncate("Bärteppich");

    try testing.expectEqualStrings(expected, actual);
}

test "Bulgarian language short (good)" {
    const expected: []const u8 = "Добър";

    const actual = truncate("Добър");

    try testing.expectEqualStrings(expected, actual);
}

test "Greek language short (health)" {
    const expected: []const u8 = "υγειά";

    const actual = truncate("υγειά");

    try testing.expectEqualStrings(expected, actual);
}

test "Maths short" {
    const expected: []const u8 = "a=πr²";

    const actual = truncate("a=πr²");

    try testing.expectEqualStrings(expected, actual);
}

test "Maths long" {
    const expected: []const u8 = "∅⊊ℕ⊊ℤ";

    const actual = truncate("∅⊊ℕ⊊ℤ⊊ℚ⊊ℝ⊊ℂ");

    try testing.expectEqualStrings(expected, actual);
}

test "English and emoji short" {
    const expected: []const u8 = "Fly 🛫";

    const actual = truncate("Fly 🛫");

    try testing.expectEqualStrings(expected, actual);
}

test "Emoji short" {
    const expected: []const u8 = "💇";

    const actual = truncate("💇");

    try testing.expectEqualStrings(expected, actual);
}

test "Emoji long" {
    const expected: []const u8 = "❄🌡🤧🤒🏥";

    const actual = truncate("❄🌡🤧🤒🏥🕰😀");

    try testing.expectEqualStrings(expected, actual);
}

test "Royal Flush?" {
    const expected: []const u8 = "🃎🂸🃅🃋🃍";

    const actual = truncate("🃎🂸🃅🃋🃍🃁🃊");

    try testing.expectEqualStrings(expected, actual);
}

test "ideograms" {
    const expected: []const u8 = "二兎を追う";

    const actual = truncate("二兎を追う者は一兎をも得ず");

    try testing.expectEqualStrings(expected, actual);
}
