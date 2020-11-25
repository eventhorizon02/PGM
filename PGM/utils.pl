% utilities and some definitions

% defenitions:
next_turn(w,b).
next_turn(b,w). % who's turn is it next.

% check if a list is empty
is_empty([]).

% convert move from letter/number to number/number
move_in_num([X,A,Y,B],[X1,A,Y1,B]):-
    file(X,X1),file(Y,Y1).

% add element to head of list
push_front(X,List,[X|List]).

file(a,1).
file(b,2).
file(c,3).
file(d,4).
file(e,5).
file(f,6).
file(g,7).
file(h,8).

% to make sure moves are still remaining on the board
add_one(1,2).
add_one(2,3).
add_one(3,4).
add_one(4,5).
add_one(5,6).
add_one(6,7).
add_one(7,8).
% add two if for knight movement.
add_two(1,3).
add_two(2,4).
add_two(3,5).
add_two(4,6).
add_two(5,7).
add_two(6,8).

% utilites:

% set value of element in list by index
set_indx([_|T],1,X,[X|T]).

set_indx([H|T],I,X,[H|R]):-
    I > 1,
    I1 is I-1, 
    set_indx(T,I1,X,R).


% get element from a list by index (only valid from indices 1 to 16), used mainly to access element in the board structure
get_indx(1,[X|_],X).
get_indx(2,[_,X|_],X).
get_indx(3,[_,_,X|_],X).
get_indx(4,[_,_,_,X|_],X).
get_indx(5,[_,_,_,_,X|_],X).
get_indx(6,[_,_,_,_,_,X|_],X).
get_indx(7,[_,_,_,_,_,_,X|_],X).
get_indx(8,[_,_,_,_,_,_,_,X|_],X).
get_indx(9,[_,_,_,_,_,_,_,_,X|_],X).
get_indx(10,[_,_,_,_,_,_,_,_,_,X|_],X).
get_indx(11,[_,_,_,_,_,_,_,_,_,_,X|_],X).
get_indx(12,[_,_,_,_,_,_,_,_,_,_,_,X|_],X).
get_indx(13,[_,_,_,_,_,_,_,_,_,_,_,_,X|_],X).
get_indx(14,[_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],X).
get_indx(15,[_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],X).
get_indx(16,[_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X|_],X).

% get the piece at file, rank
get_piece(Board,File,Rank,Piece):-
    get_indx(Rank,Board,L),
    get_indx(File,L,Piece).

% convert a move in the format frfr to move(FF,FR,TF,TR,PM,TP,CRP)
parse_move(Board,Move,Pmove):-
    atom_chars(Move,X),
    move_in_num(X,X1),
    get_indx(1,X1,D1),
    get_indx(2,X1,D2S),
    atom_number(D2S, D2),
    get_indx(3,X1,D3),
    get_indx(4,X1,D4S),
    atom_number(D4S, D4),
    get_piece(Board,D1,D2,Fpiece),
    get_piece(Board,D3,D4,Tpiece),
    get_indx(9,Board,Crp), % get the casteling right prior to move
    % append all the element to one list
    push_front(Tpiece,Crp,L1),
    push_front(Fpiece,L1,L2),
    push_front(D4,L2,L3),
    push_front(D3,L3,L4),
    push_front(D2,L4,L5),
    push_front(D1,L5,L6),
    push_front('move',L6,L7),
    Pmove =.. L7.

    % is square occupied by piece of color X
    occupied_by(Board,File,Rank,w):-
        get_piece(Board,File,Rank,Piece),
        member(Piece,[wp,wr,wn,wb,wq,wk]).

    occupied_by(Board,File,Rank,b):-
        get_piece(Board,File,Rank,Piece),
        member(Piece,[bp,br,bn,bb,bq,bk]).

    % is this square not occupied.
    is_vacant(Board,File,Rank):-
        get_piece(Board,File,Rank,*).


% are two squares on the same diagonal and if so which direction
    same_diagonal(FFile,FRank,TFile,TRank,FD,RD):-
        abs(TFile - FFile,DX),
        abs(TRank - FRank,DY),
        DX = DY,!,
       ((TFile > FFile -> FD = 1) ; FD = -1), % FD and RD are the direction the diagonal is going.
       ((TRank > FRank -> RD = 1) ; RD = -1).

% is a diagonal path free from start to end
diagonal_free(Board,FFile,FRank,FFile,FRank,Color,_,_):-
    \+ occupied_by(Board,FFile,FRank,Color),!.

diagonal_free(Board,FFile,FRank,TFile,TRank,Color,FD,RD):-
    is_vacant(Board,FFile,FRank),
    Next_file is FFile + FD,
    Next_rank is FRank + RD,
    diagonal_free(Board,Next_file,Next_rank,TFile,TRank,Color,FD,RD).

% is the vertical path free? from start to end, in direction.
col_free(Board,File,TRank,TRank,Color,_):-
    \+ occupied_by(Board,File,TRank,Color),!.

col_free(Board,File,FRank,TRank,Color,D):-
    is_vacant(Board,File,FRank),
    Next_rank is FRank + D,
    col_free(Board,File,Next_rank,TRank,Color,D).

% is the horizontal path clear from start to end, in direction.
row_free(Board,File,Rank,File,Color,_):-
    \+ occupied_by(Board,File,Rank,Color),!.
    
row_free(Board,FFile,Rank,TFile,Color,D):-
    is_vacant(Board,FFile,Rank),
    Next_file is FFile + D,
    row_free(Board,Next_file,Rank,TFile,Color,D).

% get all pieces of a color on board in the format 'piece(piecetype,file,rank)'
get_all_pieces(Board,Color,L):-
    findall(X, (between(1,8,Rank),get_row_pieces(Board,Rank,Color,X)), L1),
    flatten2(L1,L).
    

% get a list of all the pieces of a color on in a row, in a format 'piece(piecetype,file,rank)'.
get_row_pieces(Board,Rank,w,L):-
    get_indx(Rank,Board,Row),
    find_pieces(Row,Rank,L1,1),!,
    findall(piece(P,X,Y),(member(piece(P,X,Y),L1),member(P,[wp,wr,wn,wb,wq,wk])),L).

get_row_pieces(Board,Rank,b,L):-
    get_indx(Rank,Board,Row),
    find_pieces(Row,Rank,L1,1),!,
    findall(piece(P,X,Y),(member(piece(P,X,Y),L1),member(P,[bp,br,bn,bb,bq,bk])),L).
    
  
% get everything thats in a row.

find_pieces([X],Rank,[piece(X,8,Rank)],8).

find_pieces([X|Xs],Rank,[piece(X,I,Rank)|Tail],I):-
    I < 8,
    I1 is I + 1,
    find_pieces(Xs,Rank,Tail,I1).

 
% get the file/rank of king position
find_king(w,[piece(wk,File,Rank)|_],File,Rank):- !.
find_king(w,[_|Tail],File,Rank):-
    find_king(w,Tail,File,Rank).

find_king(b,[piece(bk,File,Rank)|_],File,Rank):- !.
find_king(b,[_|Tail],File,Rank):-
    find_king(b,Tail,File,Rank).

% is casteling still permited, (just get the casteling rights, don't check if it's possible)
castle_king_side(Board,w):-
    get_indx(9,Board,CP),
    get_indx(1,CP,X),
    X = wk.

castle_king_side(Board,b):-
    get_indx(9,Board,CP),
    get_indx(3,CP,X),
    X = bk.

castle_queen_side(Board,w):-
    get_indx(9,Board,CP),
    get_indx(2,CP,X),
    X = wq.

castle_queen_side(Board,b):-
    get_indx(9,Board,CP),
    get_indx(4,CP,X),
    X = bq.

% a simple move making, just replacing the pieces per move, needed to see if a legal move puts side to play in check or to finish casteling and en-passant.
sudo_move(Board,FFile,FRank,TFile,TRank,NewBoard):-
    get_indx(FRank,Board,FR), %FR holds from Rank
	get_indx(FFile,FR,Piece), % Piece is the moving piece
	set_indx(FR,FFile,*,FR1),    % the piece vacated the square and now it's empty (*)
	set_indx(Board,FRank,FR1,Board1),
    get_indx(TRank,Board1,TR),
	set_indx(TR,TFile,Piece,TR1),   % set the traveling piece at the new file rank
	set_indx(Board1,TRank,TR1,NewBoard).

% is current square an en passant square
is_en_passent(Board,File):-
    get_indx(16,Board,File).

% set en-passant file
set_en_passant(Board,File,NewBoard):-
    set_indx(Board,16,File,NewBoard).

% clear the en-passant file.
clear_en_passant(Board,NewBoard):-
    set_indx(Board,16,0,NewBoard).

% is move pawn double start, needed to set en-passant square
%move(ff,fr,tf,tr,mp,tp,wk,wq,bk,bq).
is_double_pawn_start(move(F,2,F,4,wp,_,_,_,_,_)).
is_double_pawn_start(move(F,7,F,5,bp,_,_,_,_,_)).


% was move an en-passant capture?, if pawn moved diagonaly into a vacant square it was an en-passant capture.
was_en_passant_capture(move(FF,FR,TF,TR,wp,*,_,_,_,_)):-
    (add_one(FF,TF) ; add_one(TF,FF)),
     add_one(FR,TR).

was_en_passant_capture(move(FF,FR,TF,TR,bp,*,_,_,_,_)):-
    (add_one(FF,TF) ; add_one(TF,FF)),
     add_one(TR,FR).

% do nothing to board, yeah, I actually need this!
idle_board(Board,Board).

% set a square to vacant.
clear_sq(Board,File,Rank,NewBoard):-
    get_indx(Rank,Board,Row),
    set_indx(Row,File,*,Row1),
    set_indx(Board,Rank,Row1,NewBoard).

% king has moved cancel casteling rights.
king_did_move(Board,wk,NewBoard):-
    get_indx(9,Board,CR),
    set_indx(CR,1,*,CR1), %revoke both casteling rights.
    set_indx(CR1,2,*,CR2),
    set_indx(Board,9,CR2,NewBoard).

king_did_move(Board,bk,NewBoard):-
    get_indx(9,Board,CR),
    set_indx(CR,3,*,CR1), %revoke both casteling rights.
    set_indx(CR1,4,*,CR2),
    set_indx(Board,9,CR2,NewBoard).

% has king moved
did_king_move(Board,move(5,1,_,_,wk,_,_,_,_,_),NewBoard):-
    king_did_move(Board,wk,NewBoard).

did_king_move(Board,move(5,8,_,_,bk,_,_,_,_,_),NewBoard):-
    king_did_move(Board,bk,NewBoard).

% has rook moved
did_rook_move(Board,move(1,1,_,_,wr,_,_,_,_,_),NewBoard):-
    get_indx(9,Board,CR),
    set_indx(CR,2,*,CR1), %revoke White king castle queen side rights
    set_indx(Board,9,CR1,NewBoard).

did_rook_move(Board,move(8,1,_,_,wr,_,_,_,_,_),NewBoard):-
    get_indx(9,Board,CR),
    set_indx(CR,1,*,CR1), %revoke White king castle king side rights
    set_indx(Board,9,CR1,NewBoard).

did_rook_move(Board,move(1,8,_,_,br,_,_,_,_,_),NewBoard):-
    get_indx(9,Board,CR),
    set_indx(CR,4,*,CR1), %revoke Black king castle queen side rights
    set_indx(Board,9,CR1,NewBoard).

did_rook_move(Board,move(8,8,_,_,br,_,_,_,_,_),NewBoard):-
    get_indx(9,Board,CR),
    set_indx(CR,3,*,CR1), %revoke Black king castle king side rights
    set_indx(Board,9,CR1,NewBoard).

was_promotion(Board,move(FF,7,TF,8,wp,_,_,_,_,_),NewBoard):- % white pawn promoted, for now only queen option available.
    get_indx(7,Board,Frow),
    set_indx(Frow,FF,*,Frow1),
    set_indx(Board,7,Frow1,Board1),
    get_indx(8,Board1,Trow),
    set_indx(Trow,TF,wq,Trow1),
    set_indx(Board1,8,Trow1,NewBoard).

was_promotion(Board,move(FF,2,TF,1,bp,_,_,_,_,_),NewBoard):- % Black pawn promoted
    get_indx(2,Board,Frow),
    set_indx(Frow,FF,*,Frow1),
    set_indx(Board,2,Frow1,Board1),
    get_indx(1,Board1,Trow),
    set_indx(Trow,TF,bq,Trow1),
    set_indx(Board1,1,Trow1,NewBoard).

 % check and update the 3 fold repetition counter.
 three_fold_repeat(Board,_,Board).
% TODO

% flatten nested list.
flatten2([], []) :- !.
flatten2([L|Ls], FlatL) :-
    !,
    flatten2(L, NewL),
    flatten2(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten2(L, [L]).

% convert the format of move from:
% wq(5,2,5,4) to move(5,2,5,4,wq,bb,wk,wq,bk,bq).
convert_mv_format(Board,Move,NewFormat):-
    Move =.. L,
    arg(3,Move,TF),
    arg(4,Move,TR),
    functor(Move, PM, 4),
    set_indx(L,1,move,L1),
    get_piece(Board,TF,TR,TP),
    append(L1,[PM,TP,wk,wq,bk,bq],L2),
    NewFormat =.. L2.

% a helper utility for the minimax
min_to_move(Board):-
    get_indx(11,Board,b). % who's side is it to move.
    

max_to_move(Board):-
    get_indx(11,Board,w). % who's side is it to move.
    

% get all the successor positions legally possible from a given position
moves(Board,PosList):-
    get_indx(11,Board,Side), % who's side is it to move.
    generate_all_legal_moves(Board,Side,MoveList),
    \+ is_empty(MoveList),!,         % moves is assumes to fail if there are no legal moves available.
    get_positions(Board,MoveList,PosList).


get_positions(Board,[Move],[NewBoard]):-
    convert_mv_format(Board,Move,PMove),
    make_move(Board,PMove,NewBoard),!.


get_positions(Board,[Move|Rest],[NewBoard|Boards]):-
    convert_mv_format(Board,Move,PMove),
    make_move(Board,PMove,NewBoard),
    get_positions(Board,Rest,Boards),!.

% count occurences of an element in a list.
count([],_,0).
count([X|T],X,Y):- 
    count(T,X,Z),
     Y is 1+Z.

count([X1|T],X,Z):- 
    X1\=X,
    count(T,X,Z).



    
    







    
    



    

    

