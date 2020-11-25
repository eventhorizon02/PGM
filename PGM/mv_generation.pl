% piece movment definitions and move generation.

% define knight movement:
legal_mv(Board,wn,FFile,FRank,TFile,TRank):-
    knight_mv(FFile,FRank,TFile,TRank), %knight actually moves that way
    \+ occupied_by(Board,TFile,TRank,w). % also landing square is not occupied by one of my own pieces.
    

legal_mv(Board,bn,FFile,FRank,TFile,TRank):-
    knight_mv(FFile,FRank,TFile,TRank), %knight actually moves that way
    \+ occupied_by(Board,TFile,TRank,b). % also landing square is not occupied by one of my own pieces.
    

% define king movement:
legal_mv(Board,wk,FFile,FRank,TFile,TRank):-
    king_mv(FFile,FRank,TFile,TRank),
    \+ occupied_by(Board,TFile,TRank,w). % also landing square is not occupied by one of my own pieces.
   

% define king movement:
legal_mv(Board,bk,FFile,FRank,TFile,TRank):-
    king_mv(FFile,FRank,TFile,TRank),
    \+ occupied_by(Board,TFile,TRank,b). % also landing square is not occupied by one of my own pieces.
    

% define casteling movement, which is king movement, the rook will be move in the finish_move predicate.
legal_mv(Board,wk,5,1,7,1):- % White king, castle king side.
    castle_king_side(Board,w), % casteling still allowed.
    is_vacant(Board,6,1),
    is_vacant(Board,7,1),
    \+ is_attacking(Board,b,5,1),
    \+ is_attacking(Board,b,6,1),
    \+ is_attacking(Board,b,7,1).

legal_mv(Board,bk,5,8,7,8):- % Black king, castle king side.
    castle_king_side(Board,b), % casteling still allowed.
    is_vacant(Board,6,8),
    is_vacant(Board,7,8),
    \+ is_attacking(Board,w,5,8),
    \+ is_attacking(Board,w,6,8),
    \+ is_attacking(Board,w,7,8).

legal_mv(Board,wk,5,1,3,1):- % White king, castle queen side.
    castle_queen_side(Board,w), % casteling still allowed.
    is_vacant(Board,4,1),
    is_vacant(Board,3,1),
    \+ is_attacking(Board,b,5,1), % not in check.
    \+ is_attacking(Board,b,4,1),
    \+ is_attacking(Board,b,3,1). % will not put myself in check.

legal_mv(Board,bk,5,8,3,8):- % Black king, castle queen side.
    castle_queen_side(Board,b), % casteling still allowed.
    is_vacant(Board,4,8),
    is_vacant(Board,3,8),
    \+ is_attacking(Board,w,5,8), % not in check.
    \+ is_attacking(Board,w,4,8),
    \+ is_attacking(Board,w,3,8). % will not put myself in check.


% define pawn movement:
legal_mv(Board,wp,FFile,FRank,FFile,TRank):- % white pawn move one square up.
    add_one(FRank,TRank),
    is_vacant(Board,FFile,TRank).
    

legal_mv(Board,bp,FFile,FRank,FFile,TRank):- % black pawn move one square down.
    add_one(TRank,FRank),
    is_vacant(Board,FFile,TRank).
    

legal_mv(Board,wp,FFile,2,FFile,4):-   % white pawn double step
    is_vacant(Board,FFile,3),
    is_vacant(Board,FFile,4).
    

legal_mv(Board,bp,FFile,7,FFile,5):-  %black pawn double step.
    is_vacant(Board,FFile,6),
    is_vacant(Board,FFile,5).
    

legal_mv(Board,wp,FFile,FRank,TFile,TRank):- % white pawn capture.
    occupied_by(Board,TFile,TRank,b),
    add_one(FRank,TRank),
    (add_one(FFile,TFile) ; add_one(TFile,FFile)).
    

legal_mv(Board,bp,FFile,FRank,TFile,TRank):- % black pawn capture.
    occupied_by(Board,TFile,TRank,w),
    add_one(TRank,FRank),
    (add_one(FFile,TFile) ; add_one(TFile,FFile)).
    

legal_mv(Board,wp,FFile,5,TFile,6):- % white pawn en-passant capture.
    is_en_passent(Board,TFile), % a black en-passant square
    (add_one(FFile,TFile) ; add_one(TFile,FFile)).

legal_mv(Board,bp,FFile,4,TFile,3):- % black pawn  en-passant capture.
    is_en_passent(Board,TFile), % a black en-passant square
    (add_one(FFile,TFile) ; add_one(TFile,FFile)).
    

% define movement of silder pieces, pieces that can move on many sqaure, bishop, rook and queen.
legal_mv(Board,wb,FFile,FRank,TFile,TRank):- % White bishop movement
    same_diagonal(FFile,FRank,TFile,TRank,FD,RD),
    Next_file is FFile + FD, % the check does not include the staring square
    Next_rank is FRank + RD,
    diagonal_free(Board,Next_file,Next_rank,TFile,TRank,w,FD,RD). % is the path clear for the bishop to move, final sq can be occupied by opponent.
    

legal_mv(Board,bb,FFile,FRank,TFile,TRank):- % Black bishop movement
    same_diagonal(FFile,FRank,TFile,TRank,FD,RD),
    Next_file is FFile + FD, 
    Next_rank is FRank + RD,
    diagonal_free(Board,Next_file,Next_rank,TFile,TRank,b,FD,RD).
    

legal_mv(Board,wr,FFile,FRank,FFile,TRank):- % White rook vertical movement
   ( (TRank > FRank -> D = 1) ; D = -1 ),
   Next_rank is FRank + D,
   col_free(Board,FFile,Next_rank,TRank,w,D).
   

legal_mv(Board,wr,FFile,FRank,TFile,FRank):- % White rook horizontal movement
    ((TFile > FFile -> D = 1) ; D = -1 ),
    Next_file is FFile + D,
    row_free(Board,Next_file,FRank,TFile,w,D).
    

legal_mv(Board,br,FFile,FRank,FFile,TRank):- % Black rook vertical movement
     ( (TRank > FRank -> D = 1) ; D = -1 ),
      Next_rank is FRank + D,
      col_free(Board,FFile,Next_rank,TRank,b,D).
    

legal_mv(Board,br,FFile,FRank,TFile,FRank):- % Black rook horizontal movement
    ((TFile > FFile -> D = 1) ; D = -1 ),
    Next_file is FFile + D,
    row_free(Board,Next_file,FRank,TFile,b,D).
    

% queen movement, it's basicaly a combo of bishop and rook.
legal_mv(Board,wq,FFile,FRank,TFile,TRank):- % White queen movement.
    legal_mv(Board,wb,FFile,FRank,TFile,TRank);
    legal_mv(Board,wr,FFile,FRank,TFile,TRank).
    

legal_mv(Board,bq,FFile,FRank,TFile,TRank):- % Black queen movement.
    legal_mv(Board,bb,FFile,FRank,TFile,TRank);
    legal_mv(Board,br,FFile,FRank,TFile,TRank).
    


% defines how knigt moves
knight_mv(File,Rank,TFile,TRank):-
    (add_two(Rank,TRank),add_one(File,TFile));
    (add_two(File,TFile),add_one(Rank,TRank));
    (add_two(File,TFile),add_one(TRank,Rank));
    (add_two(TRank,Rank),add_one(File,TFile));
    (add_two(TRank,Rank),add_one(TFile,File));
    (add_two(TFile,File),add_one(TRank,Rank));
    (add_two(TFile,File),add_one(Rank,TRank));
    (add_two(Rank,TRank),add_one(TFile,File)).

king_mv(File,Rank,TFile,TRank):-
    (add_one(Rank,TRank),TFile = File);
    (add_one(Rank,TRank),add_one(File,TFile));
    (add_one(File,TFile),TRank = Rank);
    (add_one(File,TFile),add_one(TRank,Rank));
    (add_one(TRank,Rank),TFile = File);
    (add_one(TFile,File),add_one(TRank,Rank));
    (add_one(TFile,File),TRank = Rank);
    (add_one(TFile,File),add_one(Rank,TRank)).

    % is color attacking this squrare
is_attacking(Board,Color,File,Rank):-
    get_all_pieces(Board,Color,L),!,
    is_attacked(Board,L,File,Rank),!.

is_attacked(Board,[piece(PT,FFile,FRank)|Tail],File,Rank):-
    legal_mv(Board,PT,FFile,FRank,File,Rank),!;
    is_attacked(Board,Tail,File,Rank).

% is color in check by opposite color?
is_in_check(Board,MyColor):-
    next_turn(MyColor,Color),!,
    get_all_pieces(Board,MyColor,L),!,
    find_king(MyColor,L,File,Rank),!,
    is_attacking(Board,Color,File,Rank),!.

% generate all the legal moves of a single piece.

% generate pawn moves.
generate_piece_moves(Board,piece(wp,F,R),L):-
    findall(wp(F,R,TF,TR), (legal_mv(Board,wp,F,R,TF,TR),try_move(Board,F,R,TF,TR,w)), L).

generate_piece_moves(Board,piece(bp,F,R),L):-
    findall(bp(F,R,TF,TR), (legal_mv(Board,bp,F,R,TF,TR),try_move(Board,F,R,TF,TR,b)) ,L).

% generate knight moves.
generate_piece_moves(Board,piece(wn,F,R),L):-
    findall(wn(F,R,TF,TR), (legal_mv(Board,wn,F,R,TF,TR),try_move(Board,F,R,TF,TR,w)), L).

generate_piece_moves(Board,piece(bn,F,R),L):-
    findall(bn(F,R,TF,TR), (legal_mv(Board,bn,F,R,TF,TR),try_move(Board,F,R,TF,TR,b)), L).

%generate king moves
generate_piece_moves(Board,piece(wk,F,R),L):-
    findall(wk(F,R,TF,TR), (legal_mv(Board,wk,F,R,TF,TR),try_move(Board,F,R,TF,TR,w)), L).

generate_piece_moves(Board,piece(bk,F,R),L):-
    findall(bk(F,R,TF,TR), (legal_mv(Board,bk,F,R,TF,TR),try_move(Board,F,R,TF,TR,b)), L).

% generate slider pieces moves
% generate bishop moves.
generate_piece_moves(Board,piece(wb,F,R),L):-
    findall(wb(F,R,TF,TR), (member(TF,[1,2,3,4,5,6,7,8]),member(TR,[1,2,3,4,5,6,7,8]),legal_mv(Board,wb,F,R,TF,TR),try_move(Board,F,R,TF,TR,w)), L).

generate_piece_moves(Board,piece(bb,F,R),L):-
    findall(bb(F,R,TF,TR), (member(TF,[1,2,3,4,5,6,7,8]),member(TR,[1,2,3,4,5,6,7,8]),legal_mv(Board,bb,F,R,TF,TR),try_move(Board,F,R,TF,TR,b)), L).

% generate rook moves.
generate_piece_moves(Board,piece(wr,F,R),L):-
    findall(wr(F,R,TF,TR), (member(TF,[1,2,3,4,5,6,7,8]),member(TR,[1,2,3,4,5,6,7,8]),legal_mv(Board,wr,F,R,TF,TR),try_move(Board,F,R,TF,TR,w)), L).

generate_piece_moves(Board,piece(br,F,R),L):-
    findall(br(F,R,TF,TR), (member(TF,[1,2,3,4,5,6,7,8]),member(TR,[1,2,3,4,5,6,7,8]),legal_mv(Board,br,F,R,TF,TR),try_move(Board,F,R,TF,TR,b)), L).

% generate queen moves.
generate_piece_moves(Board,piece(wq,F,R),L):-
    findall(wq(F,R,TF,TR), (member(TF,[1,2,3,4,5,6,7,8]),member(TR,[1,2,3,4,5,6,7,8]),legal_mv(Board,wq,F,R,TF,TR),try_move(Board,F,R,TF,TR,w)), L).

generate_piece_moves(Board,piece(bq,F,R),L):-
    findall(bq(F,R,TF,TR), (member(TF,[1,2,3,4,5,6,7,8]),member(TR,[1,2,3,4,5,6,7,8]),legal_mv(Board,bq,F,R,TF,TR),try_move(Board,F,R,TF,TR,b)), L).
 
 
% get all moves from piece list
get_moves(_,[],[]).

get_moves(Board,[Piece|Pieces],L):-
   generate_piece_moves(Board,Piece,PML),
   get_moves(Board,Pieces,L1),
   append(PML,L1,L).

%sudo try a move to make sure a move does not put self into illegal check.
try_move(Board,FFile,FRank,TFile,TRank,Color):-
     sudo_move(Board,FFile,FRank,TFile,TRank,NewBoard),
    \+ is_in_check(NewBoard,Color).  % cannot put myself in check.

   
  
% get a list of all the legal moves for a color
% moves in the list eg: wq(5,2,5,4), white queen e2 to e4.
    generate_all_legal_moves(Board,Color,ML):-
        get_all_pieces(Board,Color,L),
        get_moves(Board,L,ML).
        
        

   