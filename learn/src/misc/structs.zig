const std = @import("std");

const Person = struct {
    const Self = @This();

    name: []const u8,
    age: u32,

    fn create(name: []const u8, age: u32) Person {
        return .{ .name = name, .age = age };
    }

    fn inc_year_by_one(self: *Self) void {
        self.age += 1;
    }
};

pub fn main() void {
    var p1 = Person.create("Foo", 1);
    std.debug.print("Name: {s}, Age: {d}\n", .{ p1.name, p1.age });
    p1.age = 2;
    std.debug.print("Name: {s}, Age: {d}\n", .{ p1.name, p1.age });
    p1.inc_year_by_one();
    std.debug.print("Name: {s}, Age: {d}\n", .{ p1.name, p1.age });
}
