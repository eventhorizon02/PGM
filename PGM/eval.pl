% this the evaluation file or the hueristic fucnction.
% a board position is evaluated and given a score according to a few criteria such as
% material balance, passed pawns, half passed pawns, king security, etc.
% here are also checks for checkmate and draw.

value(wk,10000).
value(wq,900).
value(wr,500).
value(wn,300).
value(wb,300).
value(wp,100).

value(bk,-10000).
value(bq,-900).
value(br,-500).
value(bn,-300).
value(bb,-300).
value(bp,-100).

checkmate(w,-100000).
checkmate(b,100000).


% checkmate is defined as being in check with no legal moves.
is_checkmate(Board):- % ML is the list of all legal moves
    get_indx(11,Board,Side), % who's side is it to move.
    generate_all_legal_moves(Board,Side,MoveList),
    is_empty(MoveList), % no legal moves available.
    is_in_check(Board,Side).

is_draw(Board):-
    is_draw1(Board);   % draw1 is the type that side to move has no legal moves but is not in check.
    is_draw2(Board);      % draw2 is 3 fold repetition draw.
    is_draw3(Board).      % draw 3 is due to insufficient material.


is_draw1(Board):-
    get_indx(11,Board,Side), % who's side is it to move.
    generate_all_legal_moves(Board,Side,MoveList),
    is_empty(MoveList), % no legal moves available.
    \+ is_in_check(Board,Side).

is_draw2(Board):-  % three fold repetition draw
    get_indx(13,Board,X),
    X >= 3.

is_draw3(Board):-  % insufficient material
    \+ could_mate(Board,w),
    \+ could_mate(Board,b).


 % evaluate the position and give it a score.

get_pos_value(Board,CMV):-
    get_indx(11,Board,Side), % who's side is it to move.
     checkmate(Side,CMV),
     is_checkmate(Board),!.

get_pos_value(Board,0):-
     is_draw(Board),!.

 get_pos_value(Board,Value):-
     % first just straight out material balance.
     get_all_pieces(Board,w,L),
     material_value(L,w,VW),
     get_all_pieces(Board,b,L1),
     material_value(L1,b,VB),
     castle_value(Board,w,WCV), % white caste value
     castle_value(Board,b,BCV),
     Value is VW + VB + WCV + BCV.


material_value([],_,0).

material_value([CP|Rest],Color,Value):-  % add the values of all the pieces of color, cp is the compud piece: piece(f,r).
    arg(1,CP,Name),
    value(Name,Value1),
    material_value(Rest,Color,Value2),
    Value is Value1 + Value2.

% does color have sufficient material to force a mate?
could_mate(Board, w):-
    get_all_pieces(Board,w,L),
   ( member(piece(wp,_,_),L); % has at least a pawm
    member(piece(wr,_,_),L); % or has a rook
    member(piece(wq,_,_),L); % or has a a queen.
    count_bishops(L,X,w), % or has more than one bishop
    X > 1),!.
    
   
could_mate(Board, b):-
    get_all_pieces(Board,b,L),
    (member(piece(bp,_,_),L); % has at least a pawm
    member(piece(br,_,_),L); % or has a rook
    member(piece(bq,_,_),L); % or has a a queen.
    count_bishops(Board,X,b),   % or has more than one bishop
    X > 1),!.


% how many bishops does color have

count_bishops(Board,X,w):-
    get_indx(1,Board,R1),
    get_indx(2,Board,R2),
    get_indx(3,Board,R3),
    get_indx(4,Board,R4),
    get_indx(5,Board,R5),
    get_indx(6,Board,R6),
    get_indx(7,Board,R7),
    get_indx(8,Board,R8),
    count(R1,wb,N1),
    count(R2,wb,N2),
    count(R3,wb,N3),
    count(R4,wb,N4),
    count(R5,wb,N5),
    count(R6,wb,N6),
    count(R7,wb,N7),
    count(R8,wb,N8),
    X is N1 + N2 + N3 + N4 + N5 + N6 + N7 + N8, !.


count_bishops(Board,X,b):-
    get_indx(1,Board,R1),
    get_indx(2,Board,R2),
    get_indx(3,Board,R3),
    get_indx(4,Board,R4),
    get_indx(5,Board,R5),
    get_indx(6,Board,R6),
    get_indx(7,Board,R7),
    get_indx(8,Board,R8),
    count(R1,bb,N1),
    count(R2,bb,N2),
    count(R3,bb,N3),
    count(R4,bb,N4),
    count(R5,bb,N5),
    count(R6,bb,N6),
    count(R7,bb,N7),
    count(R8,bb,N8),
    X is N1 + N2 + N3 + N4 + N5 + N6 + N7 + N8, !.

    % add king security to value calculations, check if king has casteled.
    castle_value(Board,w,700):-
        get_indx(10,Board,Val),
        Val = y.

    castle_value(Board,w,0):-
         get_indx(10,Board,Val),
         Val = n.

    castle_value(Board,b,-700):-
         get_indx(12,Board,Val),
         Val = y.

    castle_value(Board,b,0):-
         get_indx(12,Board,Val),
         Val = n.



    








    

    