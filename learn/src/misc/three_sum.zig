const std = @import("std");

pub fn three_sum(allocator: std.mem.Allocator, comptime T: type, numbers: []const T) ![][]T {
    if (numbers.len < 3) return &.{};

    const sorted_numbers = try sort_numbers(T, allocator, numbers);
    defer allocator.free(sorted_numbers);

    var result = std.ArrayList([]T).init(allocator);

    for (0..sorted_numbers.len - 2) |i| {
        if (i > 0 and sorted_numbers[i] == sorted_numbers[i - 1]) continue;

        var left = i + 1;
        var right = sorted_numbers.len - 1;

        while (left < right) {
            const sum = sorted_numbers[i] + sorted_numbers[left] + sorted_numbers[right];

            if (sum == 0) {
                var tmp_arr = std.ArrayList(T).init(allocator);
                try tmp_arr.append(sorted_numbers[i]);
                try tmp_arr.append(sorted_numbers[left]);
                try tmp_arr.append(sorted_numbers[right]);
                try result.append(try tmp_arr.toOwnedSlice());

                left += 1;
                right -= 1;

                while (left < right and sorted_numbers[left] == sorted_numbers[left - 1]) {
                    right -= 1;
                }
            } else if (sum < 0) {
                left += 1;
            } else {
                right -= 1;
            }
        }
    }

    return result.toOwnedSlice();
}

fn sort_numbers(comptime T: type, allocator: std.mem.Allocator, numbers: []const T) ![]T {
    const sorted = try allocator.alloc(T, numbers.len);

    @memcpy(sorted, numbers);

    std.mem.sort(T, sorted, {}, std.sort.asc(T));

    return sorted;
}

fn clear_memory(allocator: std.mem.Allocator, arr: [][]i32) void {
    for (arr) |slice| {
        allocator.free(slice);
    }

    allocator.free(arr);
}
