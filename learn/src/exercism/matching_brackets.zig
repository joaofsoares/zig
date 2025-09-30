const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub fn isBalanced(allocator: mem.Allocator, s: []const u8) !bool {
    var map = std.AutoHashMap(u8, u8).init(allocator);
    defer map.deinit();

    try map.put(')', '(');
    try map.put('}', '{');
    try map.put(']', '[');

    var brackets: std.ArrayList(u8) = .empty;
    defer brackets.deinit(allocator);

    for (s) |c| {
        if (c == ']' or c == '}' or c == ')') {
            if (map.get(c)) |opposite| {
                if (brackets.pop()) |last| {
                    if (last != opposite) {
                        return false;
                    }
                } else {
                    return false;
                }
            } else {
                return false;
            }
        } else if (c == '[' or c == '{' or c == '(') {
            try brackets.append(allocator, c);
        }
    }

    return brackets.items.len == 0;
}

test "paired square brackets" {
    const actual = try isBalanced(testing.allocator, "[]");

    try testing.expect(actual);
}

test "empty string" {
    const actual = try isBalanced(testing.allocator, "");

    try testing.expect(actual);
}

test "unpaired brackets" {
    const actual = try isBalanced(testing.allocator, "[[");

    try testing.expect(!actual);
}

test "wrong ordered brackets" {
    const actual = try isBalanced(testing.allocator, "}{");

    try testing.expect(!actual);
}

test "wrong closing bracket" {
    const actual = try isBalanced(testing.allocator, "{]");

    try testing.expect(!actual);
}

test "paired with whitespace" {
    const actual = try isBalanced(testing.allocator, "{ }");

    try testing.expect(actual);
}

test "partially paired brackets" {
    const actual = try isBalanced(testing.allocator, "{[])");

    try testing.expect(!actual);
}

test "simple nested brackets" {
    const actual = try isBalanced(testing.allocator, "{[]}");

    try testing.expect(actual);
}

test "several paired brackets" {
    const actual = try isBalanced(testing.allocator, "{}[]");

    try testing.expect(actual);
}

test "paired and nested brackets" {
    const actual = try isBalanced(testing.allocator, "([{}({}[])])");

    try testing.expect(actual);
}

test "unopened closing brackets" {
    const actual = try isBalanced(testing.allocator, "{[)][]}");

    try testing.expect(!actual);
}

test "unpaired and nested brackets" {
    const actual = try isBalanced(testing.allocator, "([{])");

    try testing.expect(!actual);
}

test "paired and wrong nested brackets" {
    const actual = try isBalanced(testing.allocator, "[({]})");

    try testing.expect(!actual);
}

test "paired and wrong nested brackets but innermost are correct" {
    const actual = try isBalanced(testing.allocator, "[({}])");

    try testing.expect(!actual);
}

test "paired and incomplete brackets" {
    const actual = try isBalanced(testing.allocator, "{}[");

    try testing.expect(!actual);
}

test "too many closing brackets" {
    const actual = try isBalanced(testing.allocator, "[]]");

    try testing.expect(!actual);
}

test "early unexpected brackets" {
    const actual = try isBalanced(testing.allocator, ")()");

    try testing.expect(!actual);
}

test "early mismatched brackets" {
    const actual = try isBalanced(testing.allocator, "{)()");

    try testing.expect(!actual);
}

test "math expression" {
    const actual = try isBalanced(testing.allocator, "(((185 + 223.85) * 15) - 543)/2");

    try testing.expect(actual);
}

test "complex latex expression" {
    const s = "\\left(\\begin{array}{cc} \\frac{1}{3} & x\\\\ \\mathrm{e}^{x} &... x^2 \\end{array}\\right)";

    const actual = try isBalanced(testing.allocator, s);

    try testing.expect(actual);
}

test "maximum required level of nesting" {
    const s = "(((_[[[_{{{_()_}}}_]]]_)))";

    const actual = try isBalanced(testing.allocator, s);

    try testing.expect(actual);
}
