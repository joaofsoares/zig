const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const response = try pascal_triangle(allocator, 5);
    defer free_slices(allocator, response);

    std.debug.print("response = {any}\n", .{response});
}

fn free_slices(allocator: std.mem.Allocator, slices: [][]u128) void {
    for (slices) |slice| {
        allocator.free(slice);
    }

    allocator.free(slices);
}

fn pascal_triangle(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error![][]u128 {
    if (count == 0) {
        return try allocator.alloc([]u128, count);
    }

    var mat: std.ArrayList([]u128) = .empty;

    for (0..count) |row| {
        var arr: std.ArrayList(u128) = .empty;

        for (0..(row + 1)) |i| {
            if (row == i or i == 0) {
                try arr.append(allocator, 1);
            } else {
                try arr.append(allocator, mat.items[row - 1][i - 1] + mat.items[row - 1][i]);
            }
        }

        try mat.append(allocator, arr.items);
    }

    return mat.items;
}
