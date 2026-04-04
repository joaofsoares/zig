const std = @import("std");
const testing = std.testing;

pub const ArgumentError = error{
    UnsupportedQuestion,
    SyntaxError,
    DivisionByZero,
};

pub fn calculate(has_opt: *bool, has_digit: *bool, digit: *i32, is_div: bool, input: []const u8, f: fn (*i32, i32) void) ArgumentError!void {
    if (has_opt.*) {
        return ArgumentError.SyntaxError;
    }

    const num = std.fmt.parseInt(i32, input, 10) catch {
        return ArgumentError.SyntaxError;
    };

    if (is_div and num == 0) {
        return ArgumentError.DivisionByZero;
    }

    f(digit, num);

    has_digit.* = true;
    has_opt.* = false;
}

fn add(digit: *i32, num: i32) void {
    digit.* += num;
}

fn sub(digit: *i32, num: i32) void {
    digit.* -= num;
}

fn mult(digit: *i32, num: i32) void {
    digit.* *= num;
}

fn div(digit: *i32, num: i32) void {
    digit.* = @divTrunc(digit.*, num);
}

pub fn answer(question: []const u8) ArgumentError!i32 {
    if (question.len <= "What is?".len) {
        return ArgumentError.SyntaxError;
    }

    const str = question[8..(question.len - 1)];

    var split = std.mem.splitSequence(u8, str, " ");

    var digit: i32 = 0;
    var has_digit: bool = false;
    var has_opt: bool = false;

    while (split.next()) |input| {
        if (std.ascii.isDigit(input[0]) or std.ascii.isDigit(input[1])) {
            if (has_digit) {
                return ArgumentError.SyntaxError;
            }

            digit = std.fmt.parseInt(i32, input, 10) catch {
                return ArgumentError.UnsupportedQuestion;
            };

            has_digit = true;
        } else if (std.mem.eql(u8, input, "plus")) {
            if (split.next()) |next| {
                try calculate(&has_opt, &has_digit, &digit, false, next, add);
            } else {
                return ArgumentError.SyntaxError;
            }
        } else if (std.mem.eql(u8, input, "minus")) {
            if (split.next()) |next| {
                try calculate(&has_opt, &has_digit, &digit, false, next, sub);
            } else {
                return ArgumentError.SyntaxError;
            }
        } else if (std.mem.eql(u8, input, "multiplied")) {
            _ = split.next();

            if (split.next()) |next| {
                try calculate(&has_opt, &has_digit, &digit, false, next, mult);
            } else {
                return ArgumentError.SyntaxError;
            }
        } else if (std.mem.eql(u8, input, "divided")) {
            _ = split.next();

            if (split.next()) |next| {
                try calculate(&has_opt, &has_digit, &digit, true, next, div);
            } else {
                return ArgumentError.SyntaxError;
            }
        } else {
            return ArgumentError.UnsupportedQuestion;
        }
    }

    return digit;
}

test "just a number" {
    try testing.expectEqual(5, answer("What is 5?"));
}

test "just a zero" {
    try testing.expectEqual(0, answer("What is 0?"));
}

test "just a negative number" {
    try testing.expectEqual(-123, answer("What is -123?"));
}

test "addition" {
    try testing.expectEqual(2, answer("What is 1 plus 1?"));
}

test "addition with a left hand zero" {
    try testing.expectEqual(2, answer("What is 0 plus 2?"));
}

test "addition with a right hand zero" {
    try testing.expectEqual(3, answer("What is 3 plus 0?"));
}

test "more addition" {
    try testing.expectEqual(55, answer("What is 53 plus 2?"));
}

test "addition with negative numbers" {
    try testing.expectEqual(-11, answer("What is -1 plus -10?"));
}

test "large addition" {
    try testing.expectEqual(45801, answer("What is 123 plus 45678?"));
}

test "subtraction" {
    try testing.expectEqual(16, answer("What is 4 minus -12?"));
}

test "multiplication" {
    try testing.expectEqual(-75, answer("What is -3 multiplied by 25?"));
}

test "division" {
    try testing.expectEqual(-11, answer("What is 33 divided by -3?"));
}

test "multiple additions" {
    try testing.expectEqual(3, answer("What is 1 plus 1 plus 1?"));
}

test "addition and subtraction" {
    try testing.expectEqual(8, answer("What is 1 plus 5 minus -2?"));
}

test "multiple subtraction" {
    try testing.expectEqual(3, answer("What is 20 minus 4 minus 13?"));
}

test "subtraction then addition" {
    try testing.expectEqual(14, answer("What is 17 minus 6 plus 3?"));
}

test "multiple multiplication" {
    try testing.expectEqual(-12, answer("What is 2 multiplied by -2 multiplied by 3?"));
}

test "addition and multiplication" {
    try testing.expectEqual(-8, answer("What is -3 plus 7 multiplied by -2?"));
}

test "multiple division" {
    try testing.expectEqual(2, answer("What is -12 divided by 2 divided by -3?"));
}

test "Non math question" {
    try testing.expectError(ArgumentError.UnsupportedQuestion, answer("Who is the President of the United States?"));
}

test "reject problem missing an operand" {
    try testing.expectError(ArgumentError.SyntaxError, answer("What is 1 plus?"));
}

test "reject problem with no operands or operators" {
    try testing.expectError(ArgumentError.SyntaxError, answer("What is?"));
}

test "reject two operations in a row" {
    try testing.expectError(ArgumentError.SyntaxError, answer("What is 1 plus plus 2?"));
}

test "reject two numbers in a row" {
    try testing.expectError(ArgumentError.SyntaxError, answer("What is 1 plus 2 1?"));
}

test "reject postfix notation" {
    try testing.expectError(ArgumentError.SyntaxError, answer("What is 1 2 plus?"));
}

test "reject prefix notation" {
    try testing.expectError(ArgumentError.SyntaxError, answer("What is plus 1 2?"));
}

test "reject division by zero" {
    try testing.expectError(ArgumentError.DivisionByZero, answer("What is 76543 divided by 0?"));
}
