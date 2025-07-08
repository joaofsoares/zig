const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub fn encode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    var alphabet = std.AutoHashMap(u8, u8).init(allocator);
    defer alphabet.deinit();

    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    try generate_alphabet(&alphabet, false);

    var cnt: usize = 0;

    for (s) |c| {
        if (std.ascii.isAlphabetic(c)) {
            const letter = alphabet.get(std.ascii.toLower(c)) orelse continue;
            try result.append(letter);
        } else if (std.ascii.isDigit(c)) {
            try result.append(c);
        } else {
            continue;
        }

        cnt += 1;

        if (cnt == 5) {
            try result.append(' ');
            cnt = 0;
        }
    }

    if (result.getLast() == ' ') {
        _ = result.pop();
    }

    return result.toOwnedSlice();
}

pub fn decode(allocator: mem.Allocator, s: []const u8) mem.Allocator.Error![]u8 {
    var alphabet = std.AutoHashMap(u8, u8).init(allocator);
    defer alphabet.deinit();

    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    try generate_alphabet(&alphabet, true);

    for (s) |c| {
        if (std.ascii.isAlphabetic(c)) {
            const letter = alphabet.get(std.ascii.toLower(c)) orelse continue;
            try result.append(letter);
        } else if (std.ascii.isDigit(c)) {
            try result.append(c);
        } else {
            continue;
        }
    }

    if (result.getLast() == ' ') {
        _ = result.pop();
    }

    return result.toOwnedSlice();
}

fn generate_alphabet(alphabet: *std.AutoHashMap(u8, u8), reverse: bool) !void {
    const a = 'a';
    const z = 'z';
    const size: usize = @intCast(z - a + 1);

    for (0..size) |i| {
        const letter: u8 = @intCast(a + i);
        const reverse_letter: u8 = @intCast(z - i);

        if (reverse) {
            try alphabet.put(reverse_letter, letter);
        } else {
            try alphabet.put(letter, reverse_letter);
        }
    }
}

test "encode yes" {
    const expected = "bvh";

    const s = "yes";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode no" {
    const expected = "ml";

    const s = "no";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode omg" {
    const expected = "lnt";

    const s = "OMG";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode spaces" {
    const expected = "lnt";

    const s = "O M G";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode mindblowingly" {
    const expected = "nrmwy oldrm tob";

    const s = "mindblowingly";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode numbers" {
    const expected = "gvhgr mt123 gvhgr mt";

    const s = "Testing,1 2 3, testing.";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode deep thought" {
    const expected = "gifgs rhurx grlm";

    const s = "Truth is fiction.";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "encode all the letters" {
    const expected = "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt";

    const s = "The quick brown fox jumps over the lazy dog.";

    const actual = try encode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode exercism" {
    const expected = "exercism";

    const s = "vcvix rhn";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode a sentence" {
    const expected = "anobstacleisoftenasteppingstone";

    const s = "zmlyh gzxov rhlug vmzhg vkkrm thglm v";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode numbers" {
    const expected = "testing123testing";

    const s = "gvhgr mt123 gvhgr mt";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode all the letters" {
    const expected = "thequickbrownfoxjumpsoverthelazydog";

    const s = "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode with too many spaces" {
    const expected = "exercism";

    const s = "vc vix    r hn";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "decode with no spaces" {
    const expected = "anobstacleisoftenasteppingstone";

    const s = "zmlyhgzxovrhlugvmzhgvkkrmthglmv";

    const actual = try decode(testing.allocator, s);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}
