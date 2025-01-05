const std = @import("std");
const ascii = std.ascii;
const testing = std.testing;

pub fn isValidIsbn10(s: []const u8) bool {
    if (s.len == 0) {
        return false;
    }

    var mult: usize = 10;
    var sum: usize = 0;

    for (s) |c| {
        if (c == '-') {
            continue;
        } else if (ascii.isDigit(c) and mult > 0) {
            const num: usize = std.fmt.parseInt(u8, &[_]u8{c}, 10) catch unreachable;
            sum += num * mult;
            mult -= 1;
        } else if (c == 'X' and mult == 1) {
            sum += 10;
            mult -= 1;
        } else {
            return false;
        }
    }

    if (mult != 0) {
        return false;
    }

    if (std.math.mod(usize, sum, 11)) |modNumber| {
        return modNumber == 0;
    } else |_| {
        return false;
    }
}

test "valid ISBN" {
    try testing.expect(isValidIsbn10("3-598-21508-8"));
}

test "invalid ISBN check digit" {
    try testing.expect(!isValidIsbn10("3-598-21508-9"));
}

test "valid ISBN with a check digit of 10" {
    try testing.expect(isValidIsbn10("3-598-21507-X"));
}

test "check digit is a character other than x" {
    try testing.expect(!isValidIsbn10("3-598-21507-A"));
}

test "invalid check digit in ISBN is not treated as zero" {
    try testing.expect(!isValidIsbn10("4-598-21507-B"));
}

test "invalid character in ISBN is not treated as zero" {
    try testing.expect(!isValidIsbn10("3-598-P1581-X"));
}

test "x is only valid as a check digit" {
    try testing.expect(!isValidIsbn10("3-598-2X507-9"));
}

test "valid ISBN without separating dashes" {
    try testing.expect(isValidIsbn10("3598215088"));
}

test "ISBN without separating dashes and x as check digit" {
    try testing.expect(isValidIsbn10("359821507X"));
}

test "ISBN without check digit and dashes" {
    try testing.expect(!isValidIsbn10("359821507"));
}

test "too long ISBN and no dashes" {
    try testing.expect(!isValidIsbn10("3598215078X"));
}

test "too short ISBN" {
    try testing.expect(!isValidIsbn10("00"));
}

test "ISBN without check digit" {
    try testing.expect(!isValidIsbn10("3-598-21507"));
}

test "check digit of x should not be used for 0" {
    try testing.expect(!isValidIsbn10("3-598-21515-X"));
}

test "empty ISBN" {
    try testing.expect(!isValidIsbn10(""));
}

test "input is 9 characters" {
    try testing.expect(!isValidIsbn10("134456729"));
}

test "invalid characters are not ignored after checking length" {
    try testing.expect(!isValidIsbn10("3132P34035"));
}

test "invalid characters are not ignored before checking length" {
    try testing.expect(!isValidIsbn10("3598P215088"));
}

test "input is too long but contains a valid ISBN" {
    try testing.expect(!isValidIsbn10("98245726788"));
}
