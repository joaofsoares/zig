const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub fn prime(allocator: mem.Allocator, number: usize) !usize {
    _ = allocator;

    var num: usize = 2;
    var i = number;

    while (i > 0) : (num += 1) {
        if (is_prime(num)) {
            i -= 1;
        }
    }

    return num - 1;
}

fn is_prime(n: usize) bool {
    if (n <= 1) {
        return false;
    } else if (n == 2 or n == 3) {
        return true;
    } else if (n % 2 == 0 or n % 3 == 0) {
        return false;
    } else {
        for (2..n) |i| {
            if (n % i == 0) {
                return false;
            }
        }
    }

    return true;
}

test "first prime" {
    const p = try prime(testing.allocator, 1);
    try testing.expectEqual(2, p);
}

test "second prime" {
    const p = try prime(testing.allocator, 2);
    try testing.expectEqual(3, p);
}

test "third prime" {
    const p = try prime(testing.allocator, 3);
    try testing.expectEqual(5, p);
}

test "fourth prime" {
    const p = try prime(testing.allocator, 4);
    try testing.expectEqual(7, p);
}
test "fifth prime" {
    const p = try prime(testing.allocator, 5);
    try testing.expectEqual(11, p);
}

test "sixth prime" {
    const p = try prime(testing.allocator, 6);
    try testing.expectEqual(13, p);
}
test "seventh prime" {
    const p = try prime(testing.allocator, 7);
    try testing.expectEqual(17, p);
}
test "big prime" {
    const p = try prime(testing.allocator, 10001);
    try testing.expectEqual(104743, p);
}
