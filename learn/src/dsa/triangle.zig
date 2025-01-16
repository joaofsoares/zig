const std = @import("std");
const testing = std.testing;

const TriangleError = error{Invalid};

pub const Triangle = struct {
    side_a: f64,
    side_b: f64,
    side_c: f64,

    pub fn init(a: f64, b: f64, c: f64) TriangleError!Triangle {
        if ((a != 0 and b != 0 and c != 0) and (a + b >= c) and (b + c >= a) and (a + c >= b)) {
            return Triangle{
                .side_a = a,
                .side_b = b,
                .side_c = c,
            };
        } else {
            return TriangleError.Invalid;
        }
    }

    pub fn isEquilateral(self: Triangle) bool {
        return (self.side_a == self.side_b and self.side_b == self.side_c);
    }

    pub fn isIsosceles(self: Triangle) bool {
        return (((self.side_a == self.side_b) or (self.side_a == self.side_c)) or ((self.side_b == self.side_a) or (self.side_b == self.side_c)) or ((self.side_c == self.side_a) or (self.side_c == self.side_b)));
    }

    pub fn isScalene(self: Triangle) bool {
        return (self.side_a != self.side_b and self.side_a != self.side_c and self.side_b != self.side_c);
    }
};

test "equilateral all sides are equal" {
    const actual = try Triangle.init(2, 2, 2);
    try testing.expect(actual.isEquilateral());
}

test "equilateral any side is unequal" {
    const actual = try Triangle.init(2, 3, 2);
    try testing.expect(!actual.isEquilateral());
}

test "equilateral no sides are equal" {
    const actual = try Triangle.init(5, 4, 6);
    try testing.expect(!actual.isEquilateral());
}

test "equilateral all zero sides is not a triangle" {
    const actual = Triangle.init(0, 0, 0);
    try testing.expectError(TriangleError.Invalid, actual);
}

test "equilateral sides may be floats" {
    const actual = try Triangle.init(0.5, 0.5, 0.5);
    try testing.expect(actual.isEquilateral());
}

test "isosceles last two sides are equal" {
    const actual = try Triangle.init(3, 4, 4);
    try testing.expect(actual.isIsosceles());
}

test "isosceles first two sides are equal" {
    const actual = try Triangle.init(4, 4, 3);
    try testing.expect(actual.isIsosceles());
}

test "isosceles first and last sides are equal" {
    const actual = try Triangle.init(4, 3, 4);
    try testing.expect(actual.isIsosceles());
}

test "equilateral triangles are also isosceles" {
    const actual = try Triangle.init(4, 3, 4);
    try testing.expect(actual.isIsosceles());
}

test "isosceles no sides are equal" {
    const actual = try Triangle.init(2, 3, 4);
    try testing.expect(!actual.isIsosceles());
}

test "isosceles first triangle inequality violation" {
    const actual = Triangle.init(1, 1, 3);
    try testing.expectError(TriangleError.Invalid, actual);
}

test "isosceles second triangle inequality violation" {
    const actual = Triangle.init(1, 3, 1);
    try testing.expectError(TriangleError.Invalid, actual);
}

test "isosceles third triangle inequality violation" {
    const actual = Triangle.init(3, 1, 1);
    try testing.expectError(TriangleError.Invalid, actual);
}

test "isosceles sides may be floats" {
    const actual = try Triangle.init(0.5, 0.4, 0.5);
    try testing.expect(actual.isIsosceles());
}

test "scalene no sides are equal" {
    const actual = try Triangle.init(5, 4, 6);
    try testing.expect(actual.isScalene());
}

test "scalene all sides are equal" {
    const actual = try Triangle.init(4, 4, 4);
    try testing.expect(!actual.isScalene());
}

test "scalene first and second sides are equal" {
    const actual = try Triangle.init(4, 4, 3);
    try testing.expect(!actual.isScalene());
}

test "scalene first and third sides are equal" {
    const actual = try Triangle.init(3, 4, 3);
    try testing.expect(!actual.isScalene());
}

test "scalene second and third sides are equal" {
    const actual = try Triangle.init(4, 3, 3);
    try testing.expect(!actual.isScalene());
}

test "scalene may not violate triangle inequality" {
    const actual = Triangle.init(7, 3, 2);
    try testing.expectError(TriangleError.Invalid, actual);
}

test "scalene sides may be floats" {
    const actual = try Triangle.init(0.5, 0.4, 0.6);
    try testing.expect(actual.isScalene());
}
