const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub fn toRoman(allocator: mem.Allocator, arabicNumeral: i16) mem.Allocator.Error![]u8 {
    var arr: std.ArrayList(u8) = .empty;
    defer arr.deinit(allocator);

    try create_roman_number(allocator, &arr, arabicNumeral);

    return arr.toOwnedSlice(allocator);
}

fn create_roman_number(allocator: std.mem.Allocator, arr: *std.ArrayList(u8), arabic_number: i16) !void {
    if (arabic_number < 1 or arabic_number > 3999) {
        return;
    }

    if (arabic_number >= 1000) {
        try arr.appendSlice(allocator, "M");
        try create_roman_number(allocator, arr, arabic_number - 1000);
    } else if (arabic_number >= 900) {
        try arr.appendSlice(allocator, "CM");
        try create_roman_number(allocator, arr, arabic_number - 900);
    } else if (arabic_number >= 500) {
        try arr.appendSlice(allocator, "D");
        try create_roman_number(allocator, arr, arabic_number - 500);
    } else if (arabic_number >= 400) {
        try arr.appendSlice(allocator, "CD");
        try create_roman_number(allocator, arr, arabic_number - 400);
    } else if (arabic_number >= 100) {
        try arr.appendSlice(allocator, "C");
        try create_roman_number(allocator, arr, arabic_number - 100);
    } else if (arabic_number >= 90) {
        try arr.appendSlice(allocator, "XC");
        try create_roman_number(allocator, arr, arabic_number - 90);
    } else if (arabic_number >= 50) {
        try arr.appendSlice(allocator, "L");
        try create_roman_number(allocator, arr, arabic_number - 50);
    } else if (arabic_number >= 40) {
        try arr.appendSlice(allocator, "XL");
        try create_roman_number(allocator, arr, arabic_number - 40);
    } else if (arabic_number >= 10) {
        try arr.appendSlice(allocator, "X");
        try create_roman_number(allocator, arr, arabic_number - 10);
    } else if (arabic_number >= 9) {
        try arr.appendSlice(allocator, "IX");
        try create_roman_number(allocator, arr, arabic_number - 9);
    } else if (arabic_number >= 5) {
        try arr.appendSlice(allocator, "V");
        try create_roman_number(allocator, arr, arabic_number - 5);
    } else if (arabic_number >= 4) {
        try arr.appendSlice(allocator, "IV");
        try create_roman_number(allocator, arr, arabic_number - 4);
    } else if (arabic_number >= 1) {
        try arr.appendSlice(allocator, "I");
        try create_roman_number(allocator, arr, arabic_number - 1);
    }
}

test "1 is I" {
    const expected = "I";

    const actual = try toRoman(testing.allocator, 1);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "2 is II" {
    const expected = "II";

    const actual = try toRoman(testing.allocator, 2);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "3 is III" {
    const expected = "III";

    const actual = try toRoman(testing.allocator, 3);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "4 is IV" {
    const expected = "IV";

    const actual = try toRoman(testing.allocator, 4);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "5 is V" {
    const expected = "V";

    const actual = try toRoman(testing.allocator, 5);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "6 is VI" {
    const expected = "VI";

    const actual = try toRoman(testing.allocator, 6);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "9 is IX" {
    const expected = "IX";

    const actual = try toRoman(testing.allocator, 9);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "16 is XVI" {
    const expected = "XVI";

    const actual = try toRoman(testing.allocator, 16);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "27 is XXVII" {
    const expected = "XXVII";

    const actual = try toRoman(testing.allocator, 27);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "48 is XLVIII" {
    const expected = "XLVIII";

    const actual = try toRoman(testing.allocator, 48);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "49 is XLIX" {
    const expected = "XLIX";

    const actual = try toRoman(testing.allocator, 49);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "59 is LIX" {
    const expected = "LIX";

    const actual = try toRoman(testing.allocator, 59);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "66 is LXVI" {
    const expected = "LXVI";

    const actual = try toRoman(testing.allocator, 66);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "93 is XCIII" {
    const expected = "XCIII";

    const actual = try toRoman(testing.allocator, 93);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "141 is CXLI" {
    const expected = "CXLI";

    const actual = try toRoman(testing.allocator, 141);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "163 is CLXIII" {
    const expected = "CLXIII";

    const actual = try toRoman(testing.allocator, 163);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "166 is CLXVI" {
    const expected = "CLXVI";

    const actual = try toRoman(testing.allocator, 166);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "402 is CDII" {
    const expected = "CDII";

    const actual = try toRoman(testing.allocator, 402);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "575 is DLXXV" {
    const expected = "DLXXV";

    const actual = try toRoman(testing.allocator, 575);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "666 is DCLXVI" {
    const expected = "DCLXVI";

    const actual = try toRoman(testing.allocator, 666);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "911 is CMXI" {
    const expected = "CMXI";

    const actual = try toRoman(testing.allocator, 911);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "1024 is MXXIV" {
    const expected = "MXXIV";

    const actual = try toRoman(testing.allocator, 1024);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "1666 is MDCLXVI" {
    const expected = "MDCLXVI";

    const actual = try toRoman(testing.allocator, 1666);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "3000 is MMM" {
    const expected = "MMM";

    const actual = try toRoman(testing.allocator, 3000);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "3001 is MMMI" {
    const expected = "MMMI";

    const actual = try toRoman(testing.allocator, 3001);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "3888 is MMMDCCCLXXXVIII" {
    const expected = "MMMDCCCLXXXVIII";

    const actual = try toRoman(testing.allocator, 3888);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}

test "3999 is MMMCMXCIX" {
    const expected = "MMMCMXCIX";

    const actual = try toRoman(testing.allocator, 3999);

    defer testing.allocator.free(actual);

    try testing.expectEqualStrings(expected, actual);
}
