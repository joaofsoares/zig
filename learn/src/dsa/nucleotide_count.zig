const std = @import("std");
const testing = std.testing;

pub const NucleotideError = error{Invalid};

pub const Counts = struct {
    a: u32,
    c: u32,
    g: u32,
    t: u32,
};

pub fn countNucleotides(s: []const u8) NucleotideError!Counts {
    var cnt = Counts{
        .a = 0,
        .c = 0,
        .g = 0,
        .t = 0,
    };

    if (s.len == 0) {
        return cnt;
    }

    for (s) |c| {
        switch (c) {
            'A', 'a' => cnt.a += 1,
            'C', 'c' => cnt.c += 1,
            'G', 'g' => cnt.g += 1,
            'T', 't' => cnt.t += 1,
            else => return NucleotideError.Invalid,
        }
    }

    return cnt;
}

test "empty strand" {
    const actual = try countNucleotides("");

    try testing.expectEqual(@as(u32, 0), actual.a);
    try testing.expectEqual(@as(u32, 0), actual.c);
    try testing.expectEqual(@as(u32, 0), actual.g);
    try testing.expectEqual(@as(u32, 0), actual.t);
}

test "can count one nucleotide in single-character input" {
    const actual = try countNucleotides("G");

    try testing.expectEqual(@as(u32, 0), actual.a);
    try testing.expectEqual(@as(u32, 0), actual.c);
    try testing.expectEqual(@as(u32, 1), actual.g);
    try testing.expectEqual(@as(u32, 0), actual.t);
}

test "strand with repeated nucleotide" {
    const actual = try countNucleotides("GGGGGGG");

    try testing.expectEqual(@as(u32, 0), actual.a);
    try testing.expectEqual(@as(u32, 0), actual.c);
    try testing.expectEqual(@as(u32, 7), actual.g);
    try testing.expectEqual(@as(u32, 0), actual.t);
}

test "strand with multiple nucleotides" {
    const actual = try countNucleotides("AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC");

    try testing.expectEqual(@as(u32, 20), actual.a);
    try testing.expectEqual(@as(u32, 12), actual.c);
    try testing.expectEqual(@as(u32, 17), actual.g);
    try testing.expectEqual(@as(u32, 21), actual.t);
}

test "strand with invalid nucleotides" {
    const actual = countNucleotides("AGXXACT");

    try testing.expectError(NucleotideError.Invalid, actual);
}
