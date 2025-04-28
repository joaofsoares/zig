const std = @import("std");
const testing = std.testing;
const mem = std.mem;

pub fn translate(allocator: mem.Allocator, phrase: []const u8) mem.Allocator.Error![]u8 {
    var strAlloc = try allocator.alloc(u8, phrase.len);
    errdefer allocator.free(strAlloc);

    const endStr = "ay";

    var it = mem.splitSequence(u8, phrase, " ");

    var currIdx: usize = 0;
    var endIdx: usize = 0;

    var spaces = mem.count(u8, phrase, " ");

    while (it.next()) |word| {
        for (0.., word) |idx, c| {
            if ((idx == 0 and isVowel(c)) or
                (word[0] == 'x' and word[1] == 'r') or
                (word[0] == 'y' and word[1] == 't'))
            {
                addStr(strAlloc, &currIdx, &endIdx, word);

                strAlloc = try allocator.realloc(strAlloc, strAlloc.len + endStr.len);
                addStr(strAlloc, &currIdx, &endIdx, endStr);

                break;
            } else if (c == 'y') {
                const before = if (idx == 0) word[0..(idx + 1)] else word[0..idx];
                const after = if (idx == 0) word[(idx + 1)..] else word[idx..];

                addStr(strAlloc, &currIdx, &endIdx, after);
                addStr(strAlloc, &currIdx, &endIdx, before);

                strAlloc = try allocator.realloc(strAlloc, strAlloc.len + endStr.len);
                addStr(strAlloc, &currIdx, &endIdx, endStr);

                break;
            } else if (c == 'q' and phrase[idx + 1] == 'u') {
                const before = word[0..idx];
                const killU = word[idx..(idx + 2)];
                const after = word[(idx + 2)..];

                if (before.len == 0) {
                    addStr(strAlloc, &currIdx, &endIdx, after);
                    addStr(strAlloc, &currIdx, &endIdx, killU);
                } else {
                    addStr(strAlloc, &currIdx, &endIdx, after);
                    addStr(strAlloc, &currIdx, &endIdx, before);
                    addStr(strAlloc, &currIdx, &endIdx, killU);
                }

                strAlloc = try allocator.realloc(strAlloc, strAlloc.len + endStr.len);
                addStr(strAlloc, &currIdx, &endIdx, endStr);

                break;
            } else if (isVowel(c)) {
                const before = word[0..idx];
                const after = word[idx..];

                addStr(strAlloc, &currIdx, &endIdx, after);
                addStr(strAlloc, &currIdx, &endIdx, before);

                strAlloc = try allocator.realloc(strAlloc, strAlloc.len + endStr.len);
                addStr(strAlloc, &currIdx, &endIdx, endStr);

                break;
            }
        }

        if (spaces > 0) {
            addStr(strAlloc, &currIdx, &endIdx, " ");
            spaces -= 1;
        }
    }

    return strAlloc;
}

fn addStr(str: []u8, currIdx: *usize, endIdx: *usize, word: []const u8) void {
    endIdx.* += word.len;
    @memcpy(str[(currIdx.*)..(endIdx.*)], word);
    currIdx.* = endIdx.*;
}

fn isVowel(c: u8) bool {
    return switch (c) {
        'a', 'e', 'i', 'o', 'u' => true,
        else => false,
    };
}

test "apple" {
    const actual = try translate(testing.allocator, "apple");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("appleay", actual);
}

test "xray" {
    const actual = try translate(testing.allocator, "xray");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("xrayay", actual);
}

test "yttria" {
    const actual = try translate(testing.allocator, "yttria");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("yttriaay", actual);
}

test "ear" {
    const actual = try translate(testing.allocator, "ear");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("earay", actual);
}

test "igloo" {
    const actual = try translate(testing.allocator, "igloo");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("iglooay", actual);
}

test "object" {
    const actual = try translate(testing.allocator, "object");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("objectay", actual);
}

test "under" {
    const actual = try translate(testing.allocator, "under");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("underay", actual);
}

test "equal" {
    const actual = try translate(testing.allocator, "equal");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("equalay", actual);
}

test "pig" {
    const actual = try translate(testing.allocator, "pig");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("igpay", actual);
}

test "chair" {
    const actual = try translate(testing.allocator, "chair");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("airchay", actual);
}

test "thrush" {
    const actual = try translate(testing.allocator, "thrush");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("ushthray", actual);
}

test "koala" {
    const actual = try translate(testing.allocator, "koala");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("oalakay", actual);
}

test "xenon" {
    const actual = try translate(testing.allocator, "xenon");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("enonxay", actual);
}

test "qat" {
    const actual = try translate(testing.allocator, "qat");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("atqay", actual);
}

test "fast" {
    const actual = try translate(testing.allocator, "fast");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("astfay", actual);
}

test "queen" {
    const actual = try translate(testing.allocator, "queen");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("eenquay", actual);
}

test "square" {
    const actual = try translate(testing.allocator, "square");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("aresquay", actual);
}

test "rhythm" {
    const actual = try translate(testing.allocator, "rhythm");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("ythmrhay", actual);
}

test "my" {
    const actual = try translate(testing.allocator, "my");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("ymay", actual);
}

test "string with spaces" {
    const actual = try translate(testing.allocator, "quick fast run");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("ickquay astfay unray", actual);
}

test "yellow" {
    const actual = try translate(testing.allocator, "yellow");
    defer testing.allocator.free(actual);
    try testing.expectEqualStrings("ellowyay", actual);
}
