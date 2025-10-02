const std = @import("std");
const testing = std.testing;

pub const HighScores = struct {
    scores: []const i32,
    highest_scores: [3]i32,

    pub fn init(scores: []const i32) HighScores {
        var answer: [3]i32 = .{0} ** 3;

        for (scores) |s| {
            if (s >= answer[0]) {
                answer[2] = answer[1];
                answer[1] = answer[0];
                answer[0] = s;
            } else if (s >= answer[1]) {
                answer[2] = answer[1];
                answer[1] = s;
            } else if (s >= answer[2]) {
                answer[2] = s;
            }
        }

        return .{ .scores = scores, .highest_scores = answer };
    }

    pub fn latest(self: *const HighScores) ?i32 {
        const scores_length = self.scores.len;
        if (scores_length > 0) {
            return self.scores[scores_length - 1];
        }
        return null;
    }

    pub fn personalBest(self: *const HighScores) ?i32 {
        var result: i32 = 0;
        for (self.scores) |s| {
            result = @max(result, s);
        }
        return result;
    }

    pub fn personalTopThree(self: *const HighScores) []const i32 {
        return self.highest_scores[0..@min(3, self.scores.len)];
    }
};

test "Latest score" {
    const scores = &[_]i32{ 100, 0, 90, 30 };
    try testing.expectEqual(30, HighScores.init(scores).latest());
}

test "Personal best" {
    const scores = &[_]i32{ 40, 100, 70 };
    try testing.expectEqual(100, HighScores.init(scores).personalBest());
}

test "Top 3 scores-Personal top three from a list of scores" {
    const scores = &[_]i32{ 10, 30, 90, 30, 100, 20, 10, 0, 30, 40, 40, 70, 70 };
    try testing.expectEqualSlices(i32, &[_]i32{ 100, 90, 70 }, HighScores.init(scores).personalTopThree());
}

test "Top 3 scores-Personal top highest to lowest" {
    const scores = &[_]i32{ 20, 10, 30 };
    try testing.expectEqualSlices(i32, &[_]i32{ 30, 20, 10 }, HighScores.init(scores).personalTopThree());
}

test "Top 3 scores-Personal top when there is a tie" {
    const scores = &[_]i32{ 40, 20, 40, 30 };
    try testing.expectEqualSlices(i32, &[_]i32{ 40, 40, 30 }, HighScores.init(scores).personalTopThree());
}

test "Top 3 scores-Personal top when there are less than 3" {
    const scores = &[_]i32{ 30, 70 };
    try testing.expectEqualSlices(i32, &[_]i32{ 70, 30 }, HighScores.init(scores).personalTopThree());
}

test "Top 3 scores-Personal top when there is only one" {
    const scores = &[_]i32{40};
    try testing.expectEqualSlices(i32, &[_]i32{40}, HighScores.init(scores).personalTopThree());
}
