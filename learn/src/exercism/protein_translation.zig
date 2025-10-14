const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub const TranslationError = error{
    InvalidCodon,
};

pub const Protein = enum {
    methionine,
    phenylalanine,
    leucine,
    serine,
    tyrosine,
    cysteine,
    tryptophan,
};

pub fn proteins(allocator: mem.Allocator, strand: []const u8) (mem.Allocator.Error || TranslationError)![]Protein {
    var ps: std.ArrayList(Protein) = .empty;
    defer ps.deinit(allocator);

    var cnt: usize = 0;
    while ((cnt + 3) <= strand.len) {
        const codon = strand[cnt..(cnt + 3)];

        if (std.mem.eql(u8, "AUG", codon)) {
            try ps.append(allocator, Protein.methionine);
        } else if (std.mem.eql(u8, "UUU", codon) or std.mem.eql(u8, "UUC", codon)) {
            try ps.append(allocator, Protein.phenylalanine);
        } else if (std.mem.eql(u8, "UUA", codon) or std.mem.eql(u8, "UUG", codon)) {
            try ps.append(allocator, Protein.leucine);
        } else if (std.mem.eql(u8, "UCU", codon) or std.mem.eql(u8, "UCC", codon) or std.mem.eql(u8, "UCA", codon) or std.mem.eql(u8, "UCG", codon)) {
            try ps.append(allocator, Protein.serine);
        } else if (std.mem.eql(u8, "UAU", codon) or std.mem.eql(u8, "UAC", codon)) {
            try ps.append(allocator, Protein.tyrosine);
        } else if (std.mem.eql(u8, "UGU", codon) or std.mem.eql(u8, "UGC", codon)) {
            try ps.append(allocator, Protein.cysteine);
        } else if (std.mem.eql(u8, "UGG", codon)) {
            try ps.append(allocator, Protein.tryptophan);
        } else if (std.mem.eql(u8, "UAA", codon) or std.mem.eql(u8, "UAG", codon) or std.mem.eql(u8, "UGA", codon)) {
            break;
        } else {
            return TranslationError.InvalidCodon;
        }

        cnt += 3;

        if ((strand.len - cnt) != 0 and (strand.len - cnt) < 3) {
            return TranslationError.InvalidCodon;
        }
    }

    return ps.toOwnedSlice(allocator);
}

test "Empty RNA sequence results in no proteins" {
    const expected = [_]Protein{};

    const actual = try proteins(testing.allocator, "");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Methionine RNA sequence" {
    const expected = [_]Protein{.methionine};

    const actual = try proteins(testing.allocator, "AUG");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Phenylalanine RNA sequence 1" {
    const expected = [_]Protein{.phenylalanine};

    const actual = try proteins(testing.allocator, "UUU");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Phenylalanine RNA sequence 2" {
    const expected = [_]Protein{.phenylalanine};

    const actual = try proteins(testing.allocator, "UUC");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Leucine RNA sequence 1" {
    const expected = [_]Protein{.leucine};

    const actual = try proteins(testing.allocator, "UUA");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Leucine RNA sequence 2" {
    const expected = [_]Protein{.leucine};

    const actual = try proteins(testing.allocator, "UUG");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Serine RNA sequence 1" {
    const expected = [_]Protein{.serine};

    const actual = try proteins(testing.allocator, "UCU");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Serine RNA sequence 2" {
    const expected = [_]Protein{.serine};

    const actual = try proteins(testing.allocator, "UCC");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Serine RNA sequence 3" {
    const expected = [_]Protein{.serine};

    const actual = try proteins(testing.allocator, "UCA");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Serine RNA sequence 4" {
    const expected = [_]Protein{.serine};

    const actual = try proteins(testing.allocator, "UCG");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Tyrosine RNA sequence 1" {
    const expected = [_]Protein{.tyrosine};

    const actual = try proteins(testing.allocator, "UAU");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Tyrosine RNA sequence 2" {
    const expected = [_]Protein{.tyrosine};

    const actual = try proteins(testing.allocator, "UAC");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Cysteine RNA sequence 1" {
    const expected = [_]Protein{.cysteine};

    const actual = try proteins(testing.allocator, "UGU");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Cysteine RNA sequence 2" {
    const expected = [_]Protein{.cysteine};

    const actual = try proteins(testing.allocator, "UGC");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Tryptophan RNA sequence" {
    const expected = [_]Protein{.tryptophan};

    const actual = try proteins(testing.allocator, "UGG");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "STOP codon RNA sequence 1" {
    const expected = [_]Protein{};

    const actual = try proteins(testing.allocator, "UAA");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "STOP codon RNA sequence 2" {
    const expected = [_]Protein{};

    const actual = try proteins(testing.allocator, "UAG");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "STOP codon RNA sequence 3" {
    const expected = [_]Protein{};

    const actual = try proteins(testing.allocator, "UGA");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Sequence of two protein codons translates into proteins" {
    const expected = [_]Protein{ .phenylalanine, .phenylalanine };

    const actual = try proteins(testing.allocator, "UUUUUU");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Sequence of two different protein codons translates into proteins" {
    const expected = [_]Protein{ .leucine, .leucine };

    const actual = try proteins(testing.allocator, "UUAUUG");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Translate RNA strand into correct protein list" {
    const expected = [_]Protein{ .methionine, .phenylalanine, .tryptophan };

    const actual = try proteins(testing.allocator, "AUGUUUUGG");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Translation stops if STOP codon at beginning of sequence" {
    const expected = [_]Protein{};

    const actual = try proteins(testing.allocator, "UAGUGG");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Translation stops if STOP codon at end of two-codon sequence" {
    const expected = [_]Protein{.tryptophan};

    const actual = try proteins(testing.allocator, "UGGUAG");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Translation stops if STOP codon at end of three-codon sequence" {
    const expected = [_]Protein{ .methionine, .phenylalanine };

    const actual = try proteins(testing.allocator, "AUGUUUUAA");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Translation stops if STOP codon in middle of three-codon sequence" {
    const expected = [_]Protein{.tryptophan};

    const actual = try proteins(testing.allocator, "UGGUAGUGG");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Translation stops if STOP codon in middle of six-codon sequence" {
    const expected = [_]Protein{ .tryptophan, .cysteine, .tyrosine };

    const actual = try proteins(testing.allocator, "UGGUGUUAUUAAUGGUUU");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Sequence of two non-STOP codons does not translate to a STOP codon" {
    const expected = [_]Protein{ .methionine, .methionine };

    const actual = try proteins(testing.allocator, "AUGAUG");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}

test "Unknown amino acids, not part of a codon, can't translate" {
    try testing.expectError(TranslationError.InvalidCodon, proteins(testing.allocator, "XYZ"));
}

test "Incomplete RNA sequence can't translate" {
    try testing.expectError(TranslationError.InvalidCodon, proteins(testing.allocator, "AUGU"));
}

test "Incomplete RNA sequence can translate if valid until a STOP codon" {
    const expected = [_]Protein{ .phenylalanine, .phenylalanine };

    const actual = try proteins(testing.allocator, "UUCUUCUAAUGGU");

    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Protein, &expected, actual);
}
