const std = @import("std");
const math = std.math;
const testing = std.testing;

pub const Coordinate = struct {
    points: usize,

    pub fn init(x_coord: f32, y_coord: f32) Coordinate {
        const distance = math.sqrt(x_coord * x_coord + y_coord * y_coord);

        if (distance <= 1) {
            return Coordinate{ .points = 10 };
        } else if (distance <= 5) {
            return Coordinate{ .points = 5 };
        } else if (distance <= 10) {
            return Coordinate{ .points = 1 };
        } else {
            return Coordinate{ .points = 0 };
        }
    }

    pub fn score(self: Coordinate) usize {
        return self.points;
    }
};

test "missed target" {
    const expected: usize = 0;
    const coordinate = Coordinate.init(-9.0, 9.0);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}

test "on the outer circle" {
    const expected: usize = 1;
    const coordinate = Coordinate.init(0.0, 10.0);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}

test "on the middle circle" {
    const expected: usize = 5;
    const coordinate = Coordinate.init(-5.0, 0.0);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}

test "on the inner circle" {
    const expected: usize = 10;
    const coordinate = Coordinate.init(0.0, -1.0);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}

test "exactly on center" {
    const expected: usize = 10;
    const coordinate = Coordinate.init(0.0, 0.0);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}

test "near the center" {
    const expected: usize = 10;
    const coordinate = Coordinate.init(-0.1, -0.1);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}

test "just within the inner circle" {
    const expected: usize = 10;
    const coordinate = Coordinate.init(0.7, 0.7);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}

test "just outside the inner circle" {
    const expected: usize = 5;
    const coordinate = Coordinate.init(0.8, -0.8);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}

test "just within the middle circle" {
    const expected: usize = 5;
    const coordinate = Coordinate.init(3.5, -3.5);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}

test "just outside the middle circle" {
    const expected: usize = 1;
    const coordinate = Coordinate.init(-3.6, -3.6);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}

test "just within the outer circle" {
    const expected: usize = 1;
    const coordinate = Coordinate.init(-7.0, 7.0);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}

test "just outside the outer circle" {
    const expected: usize = 0;
    const coordinate = Coordinate.init(7.1, -7.1);
    const actual = coordinate.score();
    try testing.expectEqual(expected, actual);
}

test "asymmetric position between the inner and middle circles" {
    const expected: usize = 5;
    const coordinate = Coordinate.init(0.5, -4.0);
    const actual = coordinate.score();

    try testing.expectEqual(expected, actual);
}
