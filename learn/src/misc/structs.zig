const std = @import("std");

const Numbers = struct {
    x: i32,
};

const Person = struct {
    name: []const u8,
    age: u32,

    pub fn create(name: []const u8, age: u32) Person {
        return .{ .name = name, .age = age };
    }

    pub fn inc_year_by_one(self: *Person) void {
        self.age += 1;
    }

    pub fn set_name(self: *Person, new_name: []const u8) void {
        self.name = new_name;
    }
};

const Foo = struct {
    ns: []u8,
    capacity: u8,

    pub fn create(allocator: std.mem.Allocator) !Foo {
        return .{
            .ns = try allocator.alloc(u8, 0),
            .capacity = 0,
        };
    }

    pub fn add(self: *Foo, allocator: std.mem.Allocator, item: u8) !void {
        self.capacity += 1;
        self.ns = try allocator.realloc(self.ns, self.capacity);
        self.ns[self.capacity - 1] = item;
    }
};

const Bar = struct {
    allocator: std.mem.Allocator,
    ns: []u8,
    capacity: u8,

    pub fn create(allocator: std.mem.Allocator) !Bar {
        return .{
            .allocator = allocator,
            .ns = try allocator.alloc(u8, 0),
            .capacity = 0,
        };
    }

    pub fn add(self: *Bar, item: u8) !void {
        self.capacity += 1;
        self.ns = try self.allocator.realloc(self.ns, self.capacity);
        self.ns[self.capacity - 1] = item;
    }
};

fn FooBar(comptime T: type) type {
    return struct {
        ns: []T,
        capacity: u8,

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) !Self {
            return .{
                .ns = try allocator.alloc(T, 0),
                .capacity = 0,
            };
        }

        pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
            allocator.free(self.ns);
        }

        pub fn add(self: *Self, allocator: std.mem.Allocator, item: u8) !void {
            self.capacity += 1;
            self.ns = try allocator.realloc(self.ns, self.capacity);
            self.ns[self.capacity - 1] = item;
        }
    };
}

fn malloc_usage(allocator: std.mem.Allocator) !void {
    var t = try allocator.alloc(u8, 0);
    defer allocator.free(t);
    std.debug.print("before t: {any}\n", .{t});
    t = try allocator.realloc(t, 1);
    t[0] = 1;
    std.debug.print("after t: {any}\n", .{t});
}

fn struct_usage(allocator: std.mem.Allocator) !void {
    var foo = try Foo.create(allocator);
    defer allocator.free(foo.ns); // ^ need free internal attribution created using allocator alloc

    std.debug.print("before foo: {any}\n", .{foo});
    try foo.add(allocator, 10);
    try foo.add(allocator, 20);
    std.debug.print("after foo: {any}\n", .{foo});

    var bar = try Bar.create(allocator);
    defer allocator.free(bar.ns); // ^ need free internal attribution created using allocator alloc

    std.debug.print("before bar [capacity: {d}, numbers: {any}]\n", .{ bar.capacity, bar.ns });
    try bar.add(50);
    try bar.add(60);
    std.debug.print("before bar [capacity: {d}, numbers: {any}]\n", .{ bar.capacity, bar.ns });

    var foo_bar = try FooBar(u8).init(allocator);
    defer foo_bar.deinit(allocator);

    std.debug.print("before foo_bar [capacity: {d}, numbers: {any}]\n", .{ foo_bar.capacity, foo_bar.ns });
    try foo_bar.add(allocator, 100);
    try foo_bar.add(allocator, 200);
    std.debug.print("before foo_bar [capacity: {d}, numbers: {any}]\n", .{ foo_bar.capacity, foo_bar.ns });
}

fn create_and_print_array(allocator: std.mem.Allocator) !void {
    var numbers: std.ArrayList(u8) = .empty;

    try numbers.append(allocator, 1);
    try numbers.append(allocator, 2);
    try numbers.append(allocator, 3);

    for (numbers.items) |n| {
        std.debug.print("n: {d}\n", .{n});
    }

    const result = try numbers.toOwnedSlice(allocator);
    defer allocator.free(result); // ^ memory leaked if not cleaned because array became a slice allocating memory for that

    std.debug.print("result: {any}\n", .{result});
}

test "detecting leak" {
    const allocator = std.testing.allocator;
    try create_and_print_array(allocator);
    std.debug.print("\n", .{});
    try malloc_usage(allocator);
    std.debug.print("\n", .{});
    try struct_usage(allocator);
    std.debug.print("\n", .{});
}

pub fn main() !void {
    var p1 = Person.create("Foo", 1);
    std.debug.print("Name: {s}, Age: {d}\n", .{ p1.name, p1.age });
    p1.age = 2;
    std.debug.print("Name: {s}, Age: {d}\n", .{ p1.name, p1.age });
    p1.inc_year_by_one();
    std.debug.print("Name: {s}, Age: {d}\n", .{ p1.name, p1.age });
    p1.set_name("Bar");
    std.debug.print("Name: {s}, Age: {d}\n", .{ p1.name, p1.age });

    var num = Numbers{ .x = 10 };
    std.debug.print("Num X = {d}\n", .{num.x});
    num.x = 20;
    std.debug.print("Num X = {d}\n", .{num.x});

    const allocator = std.heap.page_allocator;

    try create_and_print_array(allocator);
    std.debug.print("\n", .{});
    try malloc_usage(allocator);
    std.debug.print("\n", .{});
    try struct_usage(allocator);
}
