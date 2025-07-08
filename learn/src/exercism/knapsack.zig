const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub const Item = struct {
    weight: usize,
    value: usize,

    pub fn init(weight: usize, value: usize) Item {
        return .{ .weight = weight, .value = value };
    }
};

pub fn maximumValue(allocator: mem.Allocator, maximumWeight: usize, items: []const Item) !usize {
    if (items.len == 0) {
        return 0;
    } else if (items.len == 1) {
        const item: Item = items[0];
        return if (item.weight <= maximumWeight) item.value else 0;
    } else {
        var arr = try allocator.alloc(usize, maximumWeight + 1);
        defer allocator.free(arr);

        for (arr) |*elem| {
            elem.* = 0;
        }

        for (items) |item| {
            var j: usize = maximumWeight;
            while (j > 0) {
                if (item.weight <= j) {
                    arr[j] = @max(arr[j], arr[j - item.weight] + item.value);
                }
                j -= 1;
            }
        }

        return arr[maximumWeight];
    }
}

test "no items" {
    const expected: usize = 0;
    const items: [0]Item = .{};
    const actual = try maximumValue(testing.allocator, 100, &items);
    try testing.expectEqual(expected, actual);
}

test "one item, too heavy" {
    const expected: usize = 0;
    const items: [1]Item = .{
        Item.init(100, 1),
    };

    const actual = try maximumValue(testing.allocator, 10, &items);
    try testing.expectEqual(expected, actual);
}

test "five items (cannot be greedy by weight)" {
    const expected: usize = 21;
    const items: [5]Item = .{
        Item.init(2, 5),
        Item.init(2, 5),
        Item.init(2, 5),
        Item.init(2, 5),
        Item.init(10, 21),
    };

    const actual = try maximumValue(testing.allocator, 10, &items);
    try testing.expectEqual(expected, actual);
}
test "five items (cannot be greedy by value)" {
    const expected: usize = 80;
    const items: [5]Item = .{
        Item.init(2, 20),
        Item.init(2, 20),
        Item.init(2, 20),
        Item.init(2, 20),
        Item.init(10, 50),
    };

    const actual = try maximumValue(testing.allocator, 10, &items);
    try testing.expectEqual(expected, actual);
}

test "example knapsack" {
    const expected: usize = 90;
    const items: [4]Item = .{
        Item.init(5, 10),
        Item.init(4, 40),
        Item.init(6, 30),
        Item.init(4, 50),
    };

    const actual = try maximumValue(testing.allocator, 10, &items);
    try testing.expectEqual(expected, actual);
}

test "8 items" {
    const expected: usize = 900;
    const items: [8]Item = .{
        Item.init(25, 350),
        Item.init(35, 400),
        Item.init(45, 450),
        Item.init(5, 20),
        Item.init(25, 70),
        Item.init(3, 8),
        Item.init(2, 5),
        Item.init(2, 5),
    };

    const actual = try maximumValue(testing.allocator, 104, &items);
    try testing.expectEqual(expected, actual);
}

test "15 items" {
    const expected: usize = 1458;
    const items: [15]Item = .{
        Item.init(70, 135),
        Item.init(73, 139),
        Item.init(77, 149),
        Item.init(80, 150),
        Item.init(82, 156),
        Item.init(87, 163),
        Item.init(90, 173),
        Item.init(94, 184),
        Item.init(98, 192),
        Item.init(106, 201),
        Item.init(110, 210),
        Item.init(113, 214),
        Item.init(115, 221),
        Item.init(118, 229),
        Item.init(120, 240),
    };

    const actual = try maximumValue(testing.allocator, 750, &items);
    try testing.expectEqual(expected, actual);
}
