//
//  Board.swift
//  chess
//
//  Created by Jessica Yang on 12/26/24.
//

import SwiftUI

enum PieceType {
    case pawn //P
    case rook //R
    case knight //N
    case bishop //B
    case queen //Q
    case king //K
    case none //N
}

enum PieceColor {
    case black
    case white
    case none
}

enum Turn {
    case one
    case two
    
    var value: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        }
    }
    
}


class Piece: ObservableObject {
    
    var pieceType: PieceType
    let colorOfPiece: PieceColor //shouldn't change
    var alreadyMoved: Bool //false whe init
    var x, y: Int
    
    var image: String
    
    init(pieceType: PieceType, colorOfPiece: PieceColor, alreadyMoved: Bool, x: Int, y: Int) {
        self.pieceType = pieceType
        self.colorOfPiece = colorOfPiece
        self.alreadyMoved = alreadyMoved
        self.x = x
        self.y = y
        
        
        //Set image
        switch pieceType {
        case .pawn:
            image = "chess-pawn-"
        case .rook:
            image = "chess-rook-"
        case .knight:
            image = "chess-knight-"
        case .bishop:
            image = "chess-bishop-"
        case .queen:
            image = "chess-queen-"
        case .king:
            image = "chess-king-"
        case .none:
            image = ""
        }
        
        switch colorOfPiece {
        case .black:
            image += "black"
        case .white:
            image += "white"
        case .none:
            image = ""
        }
    }
    
    //USE THIS INSTEAD OF THE CURRENT THING
    func setAlreadyMove() {
        self.alreadyMoved = false
    }
    
    func setPieceType(ptype: PieceType) {
        pieceType = ptype
    }
    
    func setImage() {
        switch pieceType {
        case .pawn:
            image = "chess-pawn-"
        case .rook:
            image = "chess-rook-"
        case .knight:
            image = "chess-knight-"
        case .bishop:
            image = "chess-bishop-"
        case .queen:
            image = "chess-queen-"
        case .king:
            image = "chess-king-"
        case .none:
            image = ""
        }
        
        switch colorOfPiece {
        case .black:
            image += "black"
        case .white:
            image += "white"
        case .none:
            image = ""
        }
    }
    
}

class Square: Identifiable, ObservableObject {
    let id = UUID()
    
    let x, y: Int
    var defaultColor: Color
    let name: String //like E6 or whatever
    var clicked: Bool //used to change color
    
    init(x: Int, y: Int, defaultColor: Color, name: String) {
        self.x = x
        self.y = y
        self.defaultColor = defaultColor
        self.name = name
        self.clicked = false
    }
    
    func choosePiece() {
        clicked.toggle()
    }
    
}

//for the whole board
class Board: ObservableObject {
    
    var whoseTurn: Turn
    
    var movePieceChosen: Bool = false
    var movePiece: Piece?
    var moveSquare: Square?
    var moveSquares: [Square] = []
    
    var promotePawn: Piece?
    @Published var promotePawnBool: Bool = false
    
    var endgame: Bool = false //determine if game is ended
    
    @Published var board: [[Square]] = []
    @Published var pieces: [[Piece]] = []

    init() {
        
        whoseTurn = .one
        
        //proper one
//        let startGrid: [[String]] = [
//            ["BR", "BN", "BB", "BQ", "BK", "BB", "BN", "BR"],
//            ["BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP"],
//            ["NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA"],
//            ["NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA"],
//            ["NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA"],
//            ["NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA"],
//            ["WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP"],
//            ["WR", "WN", "WB", "WQ", "WK", "WB", "WN", "WR"],
//        ]
        
        //test grid
        let startGrid: [[String]] = [
            ["BR", "BN", "BB", "BQ", "BK", "BB", "BN", "BR"],
            ["BP", "BP", "NA", "WP", "WP", "BP", "BP", "BP"],
            ["NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA"],
            ["NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA"],
            ["NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA"],
            ["NA", "NA", "NA", "BP", "NA", "NA", "NA", "NA"],
            ["WP", "WP", "WP", "NA", "NA", "WP", "WP", "WP"],
            ["WR", "NA", "NA", "NA", "WK", "NA", "NA", "WR"],
        ]
        
        //used to initialize squares
        let letters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H"]
        let flipnum: [String] = ["8", "7", "6", "5", "4", "3", "2", "1"]
        
        for i in startGrid.indices {
            
            var temp: [Square] = []
            var tempPiece: [Piece] = []
            
            for j in startGrid[i].indices {
                //square details
                let squareColor: Color = (((i + j) % 2 == 0) ? .white : .gray)
                let squarename: String = (letters[j] + flipnum[i])
                
                //piece details
                let letterArr: [String.SubSequence] = startGrid[i][j].split(separator: "")
                
                var pieceColor: PieceColor //colorOfPiece
                switch letterArr[0] {
                case "B": pieceColor = .black
                case "W": pieceColor = .white
                case "N": pieceColor = .none
                default:
                    pieceColor = .none
                }
                
                var piecetyp: PieceType //currPiece
                switch letterArr[1] {
                case "P": piecetyp = .pawn
                case "R": piecetyp = .rook
                case "N": piecetyp = .knight
                case "B": piecetyp = .bishop
                case "Q": piecetyp = .queen
                case "K": piecetyp = .king
                case "A": piecetyp = .none
                default:
                    piecetyp = .none
                }
                
                tempPiece.append(Piece(pieceType: piecetyp, colorOfPiece: pieceColor, alreadyMoved: false, x: j, y: i))
                
                temp.append(Square(x: j, y: i, defaultColor: squareColor, name: squarename))
                
            }
            
            board.append(temp)
            pieces.append(tempPiece)
        }
    }
    
    func printBoard() {
        for row in pieces {
            print(row[0].pieceType, row[1].pieceType, row[2].pieceType, row[3].pieceType, row[4].pieceType, row[5].pieceType, row[6].pieceType, row[7].pieceType)
        }
        print("x")
        
        print(whoseTurn, movePiece!.pieceType, "(",moveSquare!.x, moveSquare!.y,")")
        
//        print("x")
//        for sqr in moveSquares {
//            print(sqr.x, sqr.y)
//        }
        print("x")
    }
    
    //used for MOVES OF PIECES
    func getPieceAt(x: Int, y: Int) -> Piece {
        return pieces[y][x]
    }
    func getSquareAt(x: Int, y: Int) -> Square {
        return board[y][x]
    }
    
    //check if moves are valid
    func isValidCoord(x: Int, y: Int) -> Bool {
        if (x >= 0 && x <= 7) {
            return (y >= 0 && y <= 7)
        }
        return false
    }
    func isValidIndex(i: Int) -> Bool {
        return (i >= 0 && i <= 7)
    }
    
    func noPieceAt(x: Int, y: Int) -> Bool {
        return getPieceAt(x: x, y: y).pieceType == .none
    }
    
    //MOVES OF PIECES
    func pawnMoves(piece: Piece) -> [Square] {
        var moves: [Square] = []
        
        let offset: Int = ((piece.colorOfPiece == .white) ? -1 : 1)
        let pColor: PieceColor = piece.colorOfPiece
        
        let x: Int = piece.x
        let y: Int = piece.y
        let yOff: Int = piece.y + offset
        
        func isValidEmpty(y: Int) {
            if (isValidCoord(x: x, y: y)) {
                if (noPieceAt(x: x, y: y)) {
                    moves.append(getSquareAt(x: x, y: y))
                }
            }
        }
        
        func isValidEat(xOff: Int) {
            if (isValidCoord(x: xOff, y: yOff)) {
                let p: Piece = getPieceAt(x: xOff, y: yOff)
                if (p.pieceType != .none && p.colorOfPiece != pColor) {
                    moves.append(getSquareAt(x: xOff, y: yOff))
                }
            }
        }
            
        isValidEmpty(y: yOff)
        
        //eat left
        isValidEat(xOff: x - 1)
            
        //eat right
        isValidEat(xOff: x + 1)
            
        //forward two
        if (piece.alreadyMoved == false) {
            if (pColor == .white) {
                isValidEmpty(y: y - 2)
            } else {
                isValidEmpty(y: y + 2)
            }
        }
        
        return moves
    }
    
    func rookMoves(piece: Piece) -> [Square] {
        var moves: [Square] = []
        
        let x: Int = piece.x
        let y: Int = piece.y
        let color: PieceColor = piece.colorOfPiece
        
        func isValidMove(x: Int, y: Int, xInc: Int, yInc: Int) {
            var xCoor: Int = x
            var yCoor: Int = y
            
            while (isValidCoord(x: xCoor, y: yCoor)) {
                if (noPieceAt(x: xCoor, y: yCoor)) {
                    moves.append(getSquareAt(x: xCoor, y: yCoor))
                } else {
                    if (getPieceAt(x: xCoor, y: yCoor).colorOfPiece != color) {
                        moves.append(getSquareAt(x: xCoor, y: yCoor))
                    }
                    break
                }
                
                xCoor += xInc
                yCoor += yInc
                
            }
        }
        
        //right
        isValidMove(x: x + 1, y: y, xInc: 1, yInc: 0)
        
        //left
        isValidMove(x: x - 1, y: y, xInc: -1, yInc: 0)
        
        //up
        isValidMove(x: x, y: y + 1, xInc: 0, yInc: 1)
        
        //down
        isValidMove(x: x, y: y - 1, xInc: 0, yInc: -1)

        return moves
    }
    
    func knightMoves(piece: Piece) -> [Square] {
        var moves: [Square] = []
        
        let x: Int = piece.x
        let y: Int = piece.y
        let color: PieceColor = piece.colorOfPiece
        
        func isValidMove(x: Int, y: Int) {
            if (isValidCoord(x: x, y: y)) {
                if (getPieceAt(x: x, y: y).colorOfPiece != color) {
                    moves.append(getSquareAt(x: x, y: y))
                }
            }
        }
        
        //rightmost
        isValidMove(x: x + 1, y: y + 2)
        isValidMove(x: x + 1, y: y - 2)
        
        isValidMove(x: x + 2, y: y + 1)
        isValidMove(x: x + 2, y: y - 1)
        
        isValidMove(x: x - 1, y: y + 2)
        isValidMove(x: x - 1, y: y - 2)
        
        //leftmost
        isValidMove(x: x - 2, y: y + 1)
        isValidMove(x: x - 2, y: y - 1)
        
        return moves
    }
    
    func bishopMoves(piece: Piece) -> [Square] {
        var moves: [Square] = []
        
        let x: Int = piece.x
        let y: Int = piece.y
        let color: PieceColor = piece.colorOfPiece
        
        func isValidMove(x: Int, y: Int, xOff: Int, yOff: Int) {
            var xCoor: Int = x
            var yCoor: Int = y
            
            while (isValidCoord(x: xCoor, y: yCoor)) {
                if (noPieceAt(x: xCoor, y: yCoor)) {
                    moves.append(getSquareAt(x: xCoor, y: yCoor))
                } else {
                    if (getPieceAt(x: xCoor, y: yCoor).colorOfPiece != color) {
                        moves.append(getSquareAt(x: xCoor, y: yCoor))
                    }
                    break
                }
                
                xCoor += xOff
                yCoor += yOff
            }
        }
        
        //quad 1, top right
        isValidMove(x: x + 1, y: y + 1, xOff: 1, yOff: 1)
        
        //quad 2, top left
        isValidMove(x: x - 1, y: y + 1, xOff: -1, yOff: 1)
        
        //quad 3, bottom left
        isValidMove(x: x - 1, y: y - 1, xOff: -1, yOff: -1)
        
        //quad 4, bottom right
        isValidMove(x: x + 1, y: y - 1, xOff: 1, yOff: -1)

        return moves
    }
    
    func kingMoves(piece: Piece) -> [Square] {
        var moves: [Square] = []
        
        let x: Int = piece.x
        let y: Int = piece.y
        let color: PieceColor = piece.colorOfPiece
        
        func checkCastle() {
            if (piece.alreadyMoved == false) {
                
                //castle left
                var cornerP: Piece = self.getPieceAt(x: 0, y: 7)
                if (cornerP.pieceType == .rook && cornerP.alreadyMoved == false) {
                    var x2: Int = movePiece!.x - 1
                    var canCastle: Bool = true
                    
                    while (x2 > 0) {
                        if (self.getPieceAt(x: x2, y: y).pieceType != .none) {
                            canCastle = false
                            break
                        }
                        x2 -= 1
                    }

                    if canCastle {
                        moves.append(getSquareAt(x: 2, y: y))
                    }
                    
                }
                
                
                //castle right
                cornerP = self.getPieceAt(x: 7, y: 7)
                if (cornerP.pieceType == .rook && cornerP.alreadyMoved == false) {
                    
                    var x2: Int = movePiece!.x + 1
                    var canCastle: Bool = true

                    while (x2 < 7) {
                        if (self.getPieceAt(x: x2, y: y).pieceType != .none) {
                            canCastle = false
                            break
                        }
                        x2 += 1
                    }
                    
                    if canCastle {
                        moves.append(getSquareAt(x: 6, y: y))
                    }
                    
                }
            }
        }
        
        func isValidMove(x: Int, y: Int) {
            if (isValidCoord(x: x, y: y)) {
                if (getPieceAt(x: x, y: y).pieceType == .none) {
                    moves.append(getSquareAt(x: x, y: y))
                } else {
                    if (getPieceAt(x: x, y: y).colorOfPiece != color) {
                        moves.append(getSquareAt(x: x, y: y))
                    }
                }
            }
        }
        
        isValidMove(x: x + 1, y: y + 1) //NE
        isValidMove(x: x + 1, y: y) //E
        isValidMove(x: x + 1, y: y - 1) //SE
        isValidMove(x: x, y: y - 1) //S
        isValidMove(x: x - 1, y: y - 1) //SW
        isValidMove(x: x - 1, y: y) //W
        isValidMove(x: x - 1, y: y + 1) //NW
        isValidMove(x: x, y: y + 1) //N
        
        checkCastle()
        
        return moves
        
    }
    
    func queenMoves(piece: Piece) -> [Square] {
        var moves: [Square] = []
        
        let rookM = rookMoves(piece: piece)
        let queenM = bishopMoves(piece: piece)
        
        moves.append(contentsOf: rookM)
        moves.append(contentsOf: queenM)
        
        return moves
    }
    
    func possibleMoves(piece: Piece) {
        
        var moves: [Square] = []
        
        switch piece.pieceType {
        case .pawn:
            moves = pawnMoves(piece: piece)
        case .rook:
            moves = rookMoves(piece: piece)
        case .knight:
            moves = knightMoves(piece: piece)
        case .bishop:
            moves = bishopMoves(piece: piece)
        case .king:
            moves = kingMoves(piece: piece)
        case .queen:
            moves = queenMoves(piece: piece)
        case .none:
            break
        }
        
        moveSquares = moves
        
        for move in moves {
            print(move.x, move.y)
        }
        print("x")
    }
    
    
    //used to move pieces
    func isMoveToSquare(square: Square) -> Bool {
        for move in moveSquares {
            if (square.name == move.name) {
                return true
            }
        }
        return false
    }
    
    func setMovePiece(piece: Piece) {
        movePiece = piece
    }
    
    func setMoveSquare(square: Square) {
        moveSquare = square
    }
    
    //used to determine whether it's the right person's turn to move
    func isTurnPiece(piece: Piece) -> Bool {
        if (whoseTurn == .one) {
            return piece.colorOfPiece == .white
        } else {
            return piece.colorOfPiece == .black
        }
        
    }
    
    //check this
    func moveSquare(piece: Piece, square: Square) {
        
        func check(color: PieceColor) {
            if (piece.colorOfPiece == color) {
                    setMovePiece(piece: piece)
                    setMoveSquare(square: square)
                    possibleMoves(piece: piece)
            } else if (isMoveToSquare(square: square) && isTurnPiece(piece: movePiece!)) {
                
                //to move rook if castling
                if (movePiece?.pieceType == .king && movePiece?.alreadyMoved == false) {
                    if (square.x == 2) {
                        let moveRook: Piece = getPieceAt(x: 0, y: movePiece!.y)
                        moveCastledRook(rook: moveRook, movetoX: 3)
                    } else if (square.x == 6) {
                        let moveRook: Piece = getPieceAt(x: 7, y: movePiece!.y)
                        moveCastledRook(rook: moveRook, movetoX: 5)
                    }
                }
                
                movePiece(square: square)
                changeTurn()
                checkPromotePawn(piece: getPieceAt(x: square.x, y: square.y)) //pawn promotion
                endGame(piece: piece) //ends game if king gets eaten
                
            }
        
        }
        
        //move based on which turn
        if (self.whoseTurn == .one) {
            check(color: .white)
        } else {
            check(color: .black) //whoseTurn == 2
        }
                
    }
    
    //used to move castle during castling
    func moveCastledRook(rook: Piece, movetoX: Int) {
        pieces[rook.y][rook.x] = Piece(pieceType: .none, colorOfPiece: .none, alreadyMoved: false, x: movePiece!.x, y: movePiece!.y)
        pieces[rook.y][movetoX] = Piece(pieceType: rook.pieceType, colorOfPiece: rook.colorOfPiece, alreadyMoved: true, x: movetoX, y: rook.y)
    }
    
    //square = square piece is moving to
    func movePiece(square: Square) {
        pieces[movePiece!.y][movePiece!.x] = Piece(pieceType: .none, colorOfPiece: .none, alreadyMoved: false, x: movePiece!.x, y: movePiece!.y)
        pieces[square.y][square.x] = Piece(pieceType: movePiece!.pieceType, colorOfPiece: movePiece!.colorOfPiece, alreadyMoved: true, x: square.x, y: square.y)
    }
    
    //game logic
    func changeTurn() {
        self.whoseTurn = (self.whoseTurn == .one ? .two : .one)
    }
    
    func endGame(piece: Piece) {
        if (piece.pieceType == .king) {
            endgame = true
        }
    }
    
    
    //pawn promotion
    func setPawnPromote(piece: Piece) {
        promotePawn = piece
    }
    
    func checkPromotePawn(piece: Piece) {
        if (piece.pieceType == .pawn) {
            if (piece.colorOfPiece == .white) {
                if (piece.y == 0) {
                    setPawnPromote(piece: piece)
                    promotePawnBool = true
                }
            } else if (piece.colorOfPiece == .black) {
                if (piece.y == 7) {
                    setPawnPromote(piece: piece)
                    promotePawnBool = true
                }
            }
            
        }
    }
    
}
