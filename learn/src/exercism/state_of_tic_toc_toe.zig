const std = @import("std");
const testing = std.testing;

pub const GameState = enum {
    win,
    draw,
    ongoing,
    impossible,
};

const GameInfo = struct {
    moves: usize,
    win: bool,
};

fn check(board: []const []const u8, value: u8) GameInfo {
    var game: GameInfo = .{ .moves = 0, .win = false };

    for (0..3) |row| {
        if (!game.win and (value == board[row][0] and value == board[row][1] and value == board[row][2])) {
            game.win = true;
        }

        for (0..3) |col| {
            if (!game.win and (value == board[0][col] and value == board[1][col] and value == board[2][col])) {
                game.win = true;
            }

            if (board[row][col] == value) {
                game.moves += 1;
            }
        }

        if (!game.win and (value == board[0][0] and value == board[1][1] and value == board[2][2]) or
            (value == board[0][2] and value == board[1][1] and value == board[2][0]))
        {
            game.win = true;
        }
    }

    return game;
}

pub fn gameState(board: []const []const u8) GameState {
    const x: GameInfo = check(board, 'X');
    const o: GameInfo = check(board, 'O');

    if ((!x.win and !o.win) and (x.moves + o.moves < 9) and (x.moves == o.moves or x.moves == o.moves + 1)) {
        return .ongoing;
    } else if ((x.win and !o.win) or (o.win and !x.win)) {
        return .win;
    } else if (!x.win and !o.win and (x.moves + o.moves) == 9) {
        return .draw;
    }

    return .impossible;
}

test "Won games-Finished game where X won via left column victory" {
    const board = [_][]const u8{
        "XOO",
        "X  ",
        "X  ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where X won via middle column victory" {
    const board = [_][]const u8{
        "OXO",
        " X ",
        " X ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where X won via right column victory" {
    const board = [_][]const u8{
        "OOX",
        "  X",
        "  X",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where O won via left column victory" {
    const board = [_][]const u8{
        "OXX",
        "OX ",
        "O  ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where O won via middle column victory" {
    const board = [_][]const u8{
        "XOX",
        " OX",
        " O ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where O won via right column victory" {
    const board = [_][]const u8{
        "XXO",
        " XO",
        "  O",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where X won via top row victory" {
    const board = [_][]const u8{
        "XXX",
        "XOO",
        "O  ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where X won via middle row victory" {
    const board = [_][]const u8{
        "O  ",
        "XXX",
        " O ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where X won via bottom row victory" {
    const board = [_][]const u8{
        " OO",
        "O X",
        "XXX",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where O won via top row victory" {
    const board = [_][]const u8{
        "OOO",
        "XXO",
        "XX ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where O won via middle row victory" {
    const board = [_][]const u8{
        "XX ",
        "OOO",
        "X  ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where O won via bottom row victory" {
    const board = [_][]const u8{
        "XOX",
        " XX",
        "OOO",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where X won via falling diagonal victory" {
    const board = [_][]const u8{
        "XOO",
        " X ",
        "  X",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where X won via rising diagonal victory" {
    const board = [_][]const u8{
        "O X",
        "OX ",
        "X  ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where O won via falling diagonal victory" {
    const board = [_][]const u8{
        "OXX",
        "OOX",
        "X O",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where O won via rising diagonal victory" {
    const board = [_][]const u8{
        "  O",
        " OX",
        "OXX",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where X won via a row and a column victory" {
    const board = [_][]const u8{
        "XXX",
        "XOO",
        "XOO",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Won games-Finished game where X won via two diagonal victories" {
    const board = [_][]const u8{
        "XOX",
        "OXO",
        "XOX",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.win, actual);
}

test "Drawn games-Draw" {
    const board = [_][]const u8{
        "XOX",
        "XXO",
        "OXO",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.draw, actual);
}

test "Drawn games-Another draw" {
    const board = [_][]const u8{
        "XXO",
        "OXX",
        "XOO",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.draw, actual);
}

test "Ongoing games-Ongoing game: one move in" {
    const board = [_][]const u8{
        "   ",
        "X  ",
        "   ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.ongoing, actual);
}

test "Ongoing games-Ongoing game: two moves in" {
    const board = [_][]const u8{
        "O  ",
        " X ",
        "   ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.ongoing, actual);
}

test "Ongoing games-Ongoing game: five moves in" {
    const board = [_][]const u8{
        "X  ",
        " XO",
        "OX ",
    };
    const actual = gameState(&board);
    try testing.expectEqual(GameState.ongoing, actual);
}

test "Invalid boards-Invalid board: X went twice" {
    const board = [_][]const u8{
        "XX ",
        "   ",
        "   ",
    };
    const actual = gameState(&board);
    // Wrong turn order: X went twice
    try testing.expectEqual(GameState.impossible, actual);
}

test "Invalid boards-Invalid board: O started" {
    const board = [_][]const u8{
        "OOX",
        "   ",
        "   ",
    };
    const actual = gameState(&board);
    // Wrong turn order: O started
    try testing.expectEqual(GameState.impossible, actual);
}

test "Invalid boards-Invalid board: X won and O kept playing" {
    const board = [_][]const u8{
        "XXX",
        "OOO",
        "   ",
    };
    const actual = gameState(&board);
    // Impossible board: game should have ended after the game was won
    try testing.expectEqual(GameState.impossible, actual);
}

test "Invalid boards-Invalid board: players kept playing after a win" {
    const board = [_][]const u8{
        "XXX",
        "OOO",
        "XOX",
    };
    const actual = gameState(&board);
    // Impossible board: game should have ended after the game was won
    try testing.expectEqual(GameState.impossible, actual);
}
