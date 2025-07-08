const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub const Triplet = struct {
    a_side: usize,
    b_side: usize,
    c_side: usize,

    pub fn init(a: usize, b: usize, c: usize) Triplet {
        return Triplet{
            .a_side = a,
            .b_side = b,
            .c_side = c,
        };
    }
};

pub fn tripletsWithSum(allocator: mem.Allocator, n: usize) mem.Allocator.Error![]Triplet {
    var memory = try allocator.alloc(Triplet, 0);
    var found: usize = 0;

    var i: usize = 1;
    while (i <= (n / 3)) {
        var j: usize = i + 1;
        while (j <= (n / 2)) {
            const z = n - i - j;
            if (i * i + j * j == z * z) {
                memory = try allocator.realloc(memory, (found + 1));
                memory[found] = Triplet.init(i, j, z);
                found += 1;
            }
            j += 1;
        }
        i += 1;
    }

    return memory[0..found];
}

test "triplets whose sum is 12" {
    const expected: [1]Triplet = .{
        Triplet.init(3, 4, 5),
    };

    const actual = try tripletsWithSum(testing.allocator, 12);
    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Triplet, &expected, actual);
}

test "triplets whose sum is 108" {
    const expected: [1]Triplet = .{
        Triplet.init(27, 36, 45),
    };

    const actual = try tripletsWithSum(testing.allocator, 108);
    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Triplet, &expected, actual);
}

test "triplets whose sum is 1000" {
    const expected: [1]Triplet = .{
        Triplet.init(200, 375, 425),
    };

    const actual = try tripletsWithSum(testing.allocator, 1000);
    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Triplet, &expected, actual);
}

test "no matching triplets for 1001" {
    const expected: [0]Triplet = .{};

    const actual = try tripletsWithSum(testing.allocator, 1001);
    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Triplet, &expected, actual);
}

test "returns all matching triplets" {
    const expected: [2]Triplet = .{
        Triplet.init(9, 40, 41),

        Triplet.init(15, 36, 39),
    };

    const actual = try tripletsWithSum(testing.allocator, 90);
    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Triplet, &expected, actual);
}

test "several matching triplets" {
    const expected: [8]Triplet = .{
        Triplet.init(40, 399, 401),
        Triplet.init(56, 390, 394),
        Triplet.init(105, 360, 375),
        Triplet.init(120, 350, 370),
        Triplet.init(140, 336, 364),
        Triplet.init(168, 315, 357),
        Triplet.init(210, 280, 350),
        Triplet.init(240, 252, 348),
    };

    const actual = try tripletsWithSum(testing.allocator, 840);
    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Triplet, &expected, actual);
}

test "triplets for large number" {
    const expected: [5]Triplet = .{
        Triplet.init(1200, 14375, 14425),
        Triplet.init(1875, 14000, 14125),
        Triplet.init(5000, 12000, 13000),
        Triplet.init(6000, 11250, 12750),
        Triplet.init(7500, 10000, 12500),
    };

    const actual = try tripletsWithSum(testing.allocator, 30000);
    defer testing.allocator.free(actual);

    try testing.expectEqualSlices(Triplet, &expected, actual);
}
