const std = @import("std");
const testing = std.testing;

pub const Plant = enum {
    clover,
    grass,
    radishes,
    violets,
};

pub fn plants(diagram: []const u8, student: []const u8) [4]Plant {
    const student_idx = get_student_idx(student);

    var lines = std.mem.splitSequence(u8, diagram, "\n");
    var result: [4]Plant = undefined;
    var cnt: usize = 0;

    while (lines.next()) |line| {
        for (line[student_idx..(student_idx + 2)]) |l| {
            switch (l) {
                'C' => result[cnt] = Plant.clover,
                'G' => result[cnt] = Plant.grass,
                'R' => result[cnt] = Plant.radishes,
                'V' => result[cnt] = Plant.violets,
                else => {},
            }

            cnt += 1;
        }
    }

    return result;
}

fn get_student_idx(student: []const u8) usize {
    if (std.mem.eql(u8, student, "Alice")) {
        return 0;
    } else if (std.mem.eql(u8, student, "Bob")) {
        return 2;
    } else if (std.mem.eql(u8, student, "Charlie")) {
        return 4;
    } else if (std.mem.eql(u8, student, "David")) {
        return 6;
    } else if (std.mem.eql(u8, student, "Eve")) {
        return 8;
    } else if (std.mem.eql(u8, student, "Fred")) {
        return 10;
    } else if (std.mem.eql(u8, student, "Ginny")) {
        return 12;
    } else if (std.mem.eql(u8, student, "Harriet")) {
        return 14;
    } else if (std.mem.eql(u8, student, "Ileana")) {
        return 16;
    } else if (std.mem.eql(u8, student, "Joseph")) {
        return 18;
    } else if (std.mem.eql(u8, student, "Kincaid")) {
        return 20;
    } else if (std.mem.eql(u8, student, "Larry")) {
        return 22;
    }

    return 0;
}

test "partial garden with single student" {
    const diagram: []const u8 =
        \\RC
        \\GG
    ;

    const expected = .{ .radishes, .clover, .grass, .grass };

    const actual = plants(diagram, "Alice");

    try testing.expectEqual(expected, actual);
}

test "partial garden-different garden with single student" {
    const diagram: []const u8 =
        \\VC
        \\RC
    ;

    const expected = .{ .violets, .clover, .radishes, .clover };

    const actual = plants(diagram, "Alice");

    try testing.expectEqual(expected, actual);
}

test "partial garden with two students" {
    const diagram: []const u8 =
        \\VVCG
        \\VVRC
    ;

    const expected = .{ .clover, .grass, .radishes, .clover };

    const actual = plants(diagram, "Bob");

    try testing.expectEqual(expected, actual);
}

test "partial garden-multiple students for the same garden with three students-second student's garden" {
    const diagram: []const u8 =
        \\VVCCGG
        \\VVCCGG
    ;

    const expected = .{ .clover, .clover, .clover, .clover };

    const actual = plants(diagram, "Bob");

    try testing.expectEqual(expected, actual);
}

test "partial garden-multiple students for the same garden with three students-third student's garden" {
    const diagram: []const u8 =
        \\VVCCGG
        \\VVCCGG
    ;

    const expected = .{ .grass, .grass, .grass, .grass };

    const actual = plants(diagram, "Charlie");

    try testing.expectEqual(expected, actual);
}

test "full garden-for Alice, first student's garden" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .violets, .radishes, .violets, .radishes };

    const actual = plants(diagram, "Alice");

    try testing.expectEqual(expected, actual);
}

test "full garden-for Bob, second student's garden" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .clover, .grass, .clover, .clover };

    const actual = plants(diagram, "Bob");

    try testing.expectEqual(expected, actual);
}

test "full garden-for Charlie" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .violets, .violets, .clover, .grass };

    const actual = plants(diagram, "Charlie");

    try testing.expectEqual(expected, actual);
}

test "full garden-for David" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .radishes, .violets, .clover, .radishes };

    const actual = plants(diagram, "David");

    try testing.expectEqual(expected, actual);
}

test "full garden-for Eve" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .clover, .grass, .radishes, .grass };

    const actual = plants(diagram, "Eve");

    try testing.expectEqual(expected, actual);
}

test "full garden-for Fred" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .grass, .clover, .violets, .clover };

    const actual = plants(diagram, "Fred");

    try testing.expectEqual(expected, actual);
}

test "full garden-for Ginny" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .clover, .grass, .grass, .clover };

    const actual = plants(diagram, "Ginny");

    try testing.expectEqual(expected, actual);
}

test "full garden-for Harriet" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .violets, .radishes, .radishes, .violets };

    const actual = plants(diagram, "Harriet");

    try testing.expectEqual(expected, actual);
}

test "full garden-for Ileana" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .grass, .clover, .violets, .clover };

    const actual = plants(diagram, "Ileana");

    try testing.expectEqual(expected, actual);
}

test "full garden-for Joseph" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .violets, .clover, .violets, .grass };

    const actual = plants(diagram, "Joseph");

    try testing.expectEqual(expected, actual);
}

test "full garden-for Kincaid, second to last student's garden" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .grass, .clover, .clover, .grass };

    const actual = plants(diagram, "Kincaid");

    try testing.expectEqual(expected, actual);
}

test "full garden-for Larry, last student's garden" {
    const diagram: []const u8 =
        \\VRCGVVRVCGGCCGVRGCVCGCGV
        \\VRCCCGCRRGVCGCRVVCVGCGCV
    ;

    const expected = .{ .grass, .violets, .clover, .violets };

    const actual = plants(diagram, "Larry");

    try testing.expectEqual(expected, actual);
}
