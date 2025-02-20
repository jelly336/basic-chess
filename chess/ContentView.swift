//
//  ContentView.swift
//  chess
//
//  Created by Jessica Yang on 12/25/24.
//

import SwiftUI

struct ContentView: View {
    
    var boxLength: CGFloat = 38 //if change this, change framenLength too
    var roundedCorners: CGFloat = 5
    var spacing: CGFloat = 3 //if change this, change framenLength too
    var frameLength: CGFloat = (38 + 3) * 9
    
    @StateObject var brd: Board = Board()
        
    var body: some View {
        
        let board: [[Square]] = brd.board
        let pieces: [[Piece]] = brd.pieces
        
        ZStack {
            
            RoundedRectangle(cornerRadius: roundedCorners)
                .frame(width: frameLength, height: frameLength)
            
            Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                ForEach(board.indices, id: \.self) { i in
                    GridRow {
                        ForEach(board[i].indices) { j in
                            
                            let sqr: Square = board[i][j]
                            let piece: Piece = pieces[i][j]
                            
                            ZStack {
                                squareButton1(board: brd, square: sqr, piece: piece, boxLength: self.boxLength, roundedCorners: self.roundedCorners)
                                
//                                    Text("\(piece.x), \(piece.y)")
                            }
                        }
                    }
                }
            }
            
            //pawn promotion
            if (brd.promotePawnBool && brd.promotePawn != nil) {
                PawnPromotionView(piece: brd.promotePawn!, board: brd)
            }
            
            //if game end
            if (brd.endgame == true) {
                Text("Done")
            }
            
            
        }
        .animation(.bouncy, value: brd.promotePawnBool)
        
    }
    
}


struct squareButton1: View {
    
    //add more logic so only one square can be turned into green
    @ObservedObject var board: Board
    @ObservedObject var square: Square
    @ObservedObject var piece: Piece
    
    let boxLength: CGFloat
    let roundedCorners: CGFloat
        
    var body: some View {
        
        Button {
            board.moveSquare(piece: piece, square: square)
            if (board.movePiece != nil && board.moveSquare != nil) {
//                board.printBoard()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: roundedCorners)
                    .fill(square.defaultColor)
                    .frame(width: boxLength, height: boxLength)
                
                Image(piece.image)
                    .resizable()
                    .frame(width: boxLength, height: boxLength)
                    .allowsHitTesting(false) //ignores touch of the image
            }
        }
        
    }
}


struct PawnPromotionView: View {
    
    @ObservedObject var piece: Piece
    @ObservedObject var board: Board
    
    var body: some View {
        ZStack {
            
            Color.clear.ignoresSafeArea()
                .background(.thinMaterial)
            
            VStack {
                PieceButton(piece: piece, board: board, piecename: "Queen", piecetype: .queen)
                PieceButton(piece: piece, board: board, piecename: "Rook", piecetype: .rook)
                PieceButton(piece: piece, board: board, piecename: "Knight", piecetype: .knight)
                PieceButton(piece: piece, board: board, piecename: "Bishop", piecetype: .bishop)
            }
        }
        
        

    }
    
    
    struct PieceButton: View {
        @ObservedObject var piece: Piece
        @ObservedObject var board: Board
        
        var piecename: String
        var piecetype: PieceType
        
        var body: some View {
            
            Button {
                piece.setPieceType(ptype: piecetype)
                piece.setImage()
                board.promotePawnBool = false
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 200, height: 50)
                    
                    Text(piecename)
                        .foregroundStyle(Color.white)
                }
            }

            
            
        }
    }
}

#Preview {
    ContentView()
}
