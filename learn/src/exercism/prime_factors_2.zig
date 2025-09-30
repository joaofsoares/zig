const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub fn factors(allocator: mem.Allocator, value: u64) mem.Allocator.Error![]u64 {
    var result: std.ArrayList(u64) = .empty;
    errdefer result.deinit(allocator);

    if (value <= 1) {
        return result.toOwnedSlice(allocator);
    }

    var tmp_value = value;
    var divisor: usize = 2;

    while (tmp_value > 1) {
        while (tmp_value % divisor == 0) {
            tmp_value = tmp_value / divisor;
            try result.append(allocator, divisor);
        }

        divisor += if (divisor == 2) 1 else 2;

        if (divisor * divisor > tmp_value and tmp_value > 1) {
            try result.append(allocator, tmp_value);
            break;
        }
    }

    return result.toOwnedSlice(allocator);
}

test "no factors" {
    const expected = [_]u64{};
    const actual = try factors(testing.allocator, 1);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "prime number" {
    const expected = [_]u64{2};
    const actual = try factors(testing.allocator, 2);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "another prime number" {
    const expected = [_]u64{3};
    const actual = try factors(testing.allocator, 3);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "square of a prime" {
    const expected = [_]u64{ 3, 3 };
    const actual = try factors(testing.allocator, 9);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "product of first prime" {
    const expected = [_]u64{ 2, 2 };
    const actual = try factors(testing.allocator, 4);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "cube of a prime" {
    const expected = [_]u64{ 2, 2, 2 };
    const actual = try factors(testing.allocator, 8);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "product of second prime" {
    const expected = [_]u64{ 3, 3, 3 };
    const actual = try factors(testing.allocator, 27);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "product of third prime" {
    const expected = [_]u64{ 5, 5, 5, 5 };
    const actual = try factors(testing.allocator, 625);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "product of first and second prime" {
    const expected = [_]u64{ 2, 3 };
    const actual = try factors(testing.allocator, 6);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "product of primes and non-primes" {
    const expected = [_]u64{ 2, 2, 3 };
    const actual = try factors(testing.allocator, 12);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "product of primes" {
    const expected = [_]u64{ 5, 17, 23, 461 };
    const actual = try factors(testing.allocator, 901255);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "factors include a large prime" {
    const expected = [_]u64{ 11, 9539, 894119 };
    const actual = try factors(testing.allocator, 93819012551);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "product of three large primes" {
    const expected = [_]u64{ 2077681, 2099191, 2101243 };
    const actual = try factors(testing.allocator, 9164464719174396253);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}

test "one very large prime" {
    const expected = [_]u64{4016465016163};
    const actual = try factors(testing.allocator, 4016465016163);
    defer testing.allocator.free(actual);
    try testing.expectEqualSlices(u64, &expected, actual);
}
