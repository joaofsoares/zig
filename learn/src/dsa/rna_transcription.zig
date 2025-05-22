const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub fn toRna(allocator: mem.Allocator, dna: []const u8) mem.Allocator.Error![]const u8 {
    var rna = try allocator.alloc(u8, dna.len);

    for (dna, 0..) |r, i| {
        rna[i] = switch (r) {
            'G' => 'C',
            'C' => 'G',
            'T' => 'A',
            'A' => 'U',
            else => r,
        };
    }

    return rna;
}

fn testTranscription(dna: []const u8, expected: []const u8) !void {
    const rna = try toRna(testing.allocator, dna);

    defer testing.allocator.free(rna);

    try testing.expectEqualStrings(expected, rna);
}

test "empty rna sequence" {
    try testTranscription("", "");
}

test "rna complement of cytosine is guanine" {
    try testTranscription("C", "G");
}

test "rna complement of guanine is cytosine" {
    try testTranscription("G", "C");
}

test "rna complement of thymine is adenine" {
    try testTranscription("T", "A");
}

test "rna complement of adenine is uracil" {
    try testTranscription("A", "U");
}

test "rna complement" {
    try testTranscription("ACGTGGTCTTAA", "UGCACCAGAAUU");
}
