const std = @import("std");
const testing = std.testing;

pub const Category = enum {
    ones,
    twos,
    threes,
    fours,
    fives,
    sixes,
    full_house,
    four_of_a_kind,
    little_straight,
    big_straight,
    choice,
    yacht,
};

pub fn score(dice: [5]u3, category: Category) u32 {
    const allocator = std.heap.page_allocator;

    return switch (category) {
        .ones => count(dice, 1),
        .twos => count(dice, 2) * 2,
        .threes => count(dice, 3) * 3,
        .fours => count(dice, 4) * 4,
        .fives => count(dice, 5) * 5,
        .sixes => count(dice, 6) * 6,
        .full_house => calc_full_house(allocator, dice),
        .four_of_a_kind => calc_four_kind(allocator, dice),
        .little_straight => calc_little_straight(dice),
        .big_straight => calc_big_straight(dice),
        .choice => sum_dice(dice),
        .yacht => if (isYacht(dice)) 50 else 0,
    };
}

fn isYacht(dice: [5]u3) bool {
    const first = dice[0];
    for (dice[1..]) |die| {
        if (die != first) return false;
    }
    return true;
}

fn count(dice: [5]u3, value: u3) u32 {
    var total: u32 = 0;
    for (dice) |die| {
        if (die == value) total += 1;
    }
    return total;
}

fn calc_full_house(allocator: std.mem.Allocator, dice: [5]u3) u32 {
    var m = std.AutoArrayHashMap(u32, u32).init(allocator);
    defer m.deinit();

    for (dice) |die| {
        if (m.get(die)) |cnt| {
            m.put(die, cnt + 1) catch unreachable;
        } else {
            m.put(die, 1) catch unreachable;
        }
    }

    var has_pair = false;
    var has_triple = false;

    var it = m.iterator();
    while (it.next()) |entry| {
        if (entry.value_ptr.* == 2) {
            has_pair = true;
        } else if (entry.value_ptr.* == 3) {
            has_triple = true;
        } else {
            return 0;
        }
    }

    if (has_pair and has_triple) {
        return sum_dice(dice);
    }

    return 0;
}

fn calc_four_kind(allocator: std.mem.Allocator, dice: [5]u3) u32 {
    var m = std.AutoArrayHashMap(u32, u32).init(allocator);
    defer m.deinit();

    for (dice) |die| {
        if (m.get(die)) |cnt| {
            m.put(die, cnt + 1) catch unreachable;
        } else {
            m.put(die, 1) catch unreachable;
        }
    }

    var four_of_a_kind_value: u32 = 0;

    var it = m.iterator();
    while (it.next()) |entry| {
        if (entry.value_ptr.* >= 4) {
            four_of_a_kind_value = entry.key_ptr.*;
        }
    }

    return four_of_a_kind_value * 4;
}

fn calc_little_straight(dice: [5]u3) u32 {
    const little_straight = [_]u3{ 1, 2, 3, 4, 5 };
    for (little_straight) |value| {
        if (!std.mem.containsAtLeast(u3, &dice, 1, &[_]u3{value})) return 0;
    }
    return 30;
}

fn calc_big_straight(dice: [5]u3) u32 {
    const big_straight = [_]u3{ 2, 3, 4, 5, 6 };
    for (big_straight) |value| {
        if (!std.mem.containsAtLeast(u3, &dice, 1, &[_]u3{value})) return 0;
    }
    return 30;
}

fn sum_dice(dice: [5]u3) u32 {
    var total: u32 = 0;
    for (dice) |die| {
        total += die;
    }
    return total;
}

test "yacht" {
    const expected: u32 = 50;

    const actual = score([_]u3{ 5, 5, 5, 5, 5 }, .yacht);

    try testing.expectEqual(expected, actual);
}

test "not yacht" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 1, 3, 3, 2, 5 }, .yacht);

    try testing.expectEqual(expected, actual);
}

test "ones" {
    const expected: u32 = 3;

    const actual = score([_]u3{ 1, 1, 1, 3, 5 }, .ones);

    try testing.expectEqual(expected, actual);
}

test "ones, out of order" {
    const expected: u32 = 3;

    const actual = score([_]u3{ 3, 1, 1, 5, 1 }, .ones);

    try testing.expectEqual(expected, actual);
}

test "no ones" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 4, 3, 6, 5, 5 }, .ones);

    try testing.expectEqual(expected, actual);
}

test "twos" {
    const expected: u32 = 2;

    const actual = score([_]u3{ 2, 3, 4, 5, 6 }, .twos);

    try testing.expectEqual(expected, actual);
}

test "fours" {
    const expected: u32 = 8;

    const actual = score([_]u3{ 1, 4, 1, 4, 1 }, .fours);

    try testing.expectEqual(expected, actual);
}

test "yacht counted as threes" {
    const expected: u32 = 15;

    const actual = score([_]u3{ 3, 3, 3, 3, 3 }, .threes);

    try testing.expectEqual(expected, actual);
}

test "yacht of 3s counted as fives" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 3, 3, 3, 3, 3 }, .fives);

    try testing.expectEqual(expected, actual);
}

test "fives" {
    const expected: u32 = 10;

    const actual = score([_]u3{ 1, 5, 3, 5, 3 }, .fives);

    try testing.expectEqual(expected, actual);
}

test "sixes" {
    const expected: u32 = 6;

    const actual = score([_]u3{ 2, 3, 4, 5, 6 }, .sixes);

    try testing.expectEqual(expected, actual);
}

test "full house two small, three big" {
    const expected: u32 = 16;

    const actual = score([_]u3{ 2, 2, 4, 4, 4 }, .full_house);

    try testing.expectEqual(expected, actual);
}

test "full house two small, three big, alternative order" {
    const expected: u32 = 14;

    const actual = score([_]u3{ 4, 4, 2, 2, 2 }, .full_house);

    try testing.expectEqual(expected, actual);
}

test "full house three small, two big" {
    const expected: u32 = 19;

    const actual = score([_]u3{ 5, 3, 3, 5, 3 }, .full_house);

    try testing.expectEqual(expected, actual);
}

test "full house three small, two big, alternative order" {
    const expected: u32 = 21;

    const actual = score([_]u3{ 3, 5, 5, 3, 5 }, .full_house);

    try testing.expectEqual(expected, actual);
}

test "two pair is not a full house" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 2, 2, 4, 4, 5 }, .full_house);

    try testing.expectEqual(expected, actual);
}

test "four of a kind is not a full house" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 1, 4, 4, 4, 4 }, .full_house);

    try testing.expectEqual(expected, actual);
}

test "yacht is not a full house" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 2, 2, 2, 2, 2 }, .full_house);

    try testing.expectEqual(expected, actual);
}

test "four of a kind" {
    const expected: u32 = 24;

    const actual = score([_]u3{ 6, 6, 4, 6, 6 }, .four_of_a_kind);

    try testing.expectEqual(expected, actual);
}

test "four of a kind alternative order" {
    const expected: u32 = 16;

    const actual = score([_]u3{ 4, 4, 6, 4, 4 }, .four_of_a_kind);

    try testing.expectEqual(expected, actual);
}

test "yacht can be scored as four of a kind" {
    const expected: u32 = 12;

    const actual = score([_]u3{ 3, 3, 3, 3, 3 }, .four_of_a_kind);

    try testing.expectEqual(expected, actual);
}

test "full house is not four of a kind" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 3, 3, 3, 5, 5 }, .four_of_a_kind);

    try testing.expectEqual(expected, actual);
}

test "little straight" {
    const expected: u32 = 30;

    const actual = score([_]u3{ 3, 5, 4, 1, 2 }, .little_straight);

    try testing.expectEqual(expected, actual);
}

test "little straight as big straight" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 1, 2, 3, 4, 5 }, .big_straight);

    try testing.expectEqual(expected, actual);
}

test "four in order but not a little straight" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 1, 1, 2, 3, 4 }, .little_straight);

    try testing.expectEqual(expected, actual);
}

test "no pairs but not a little straight" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 1, 2, 3, 4, 6 }, .little_straight);

    try testing.expectEqual(expected, actual);
}

test "minimum is 1, maximum is 5, but not a little straight" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 1, 1, 3, 4, 5 }, .little_straight);

    try testing.expectEqual(expected, actual);
}

test "big straight" {
    const expected: u32 = 30;

    const actual = score([_]u3{ 4, 6, 2, 5, 3 }, .big_straight);

    try testing.expectEqual(expected, actual);
}

test "big straight as little straight" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 6, 5, 4, 3, 2 }, .little_straight);

    try testing.expectEqual(expected, actual);
}

test "no pairs but not a big straight" {
    const expected: u32 = 0;

    const actual = score([_]u3{ 6, 5, 4, 3, 1 }, .big_straight);

    try testing.expectEqual(expected, actual);
}

test "choice" {
    const expected: u32 = 23;

    const actual = score([_]u3{ 3, 3, 5, 6, 6 }, .choice);

    try testing.expectEqual(expected, actual);
}

test "yacht as choice" {
    const expected: u32 = 10;

    const actual = score([_]u3{ 2, 2, 2, 2, 2 }, .choice);

    try testing.expectEqual(expected, actual);
}
