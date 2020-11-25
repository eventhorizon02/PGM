% print board to termianl utilities and IF time permints Javascript interface for GUI display and control.

% ********************* terminal print utilities *******************************
% display legend:
% p = White pawn
% r = White rook
% n = White knight
% b = White bishop
% q = White queen
% k = White king
% P = Black pawn
% R = Black rook
% N = Black knight
% B = Black bishop
% Q = Black queen
% K = Black king
% *******************************************************************************

% display a plain output of the board, used for debuging and testing only
display_plain([]).

display_plain([X|Xs]):-
	write(X),nl,
	display_plain(Xs).


% display a play version of the board.
print_board(Board):-	
	nl,	
	write('   A  B  C  D  E  F  G  H' ),nl,
	print_ranks(Board,8),nl,
	write('   A  B  C  D  E  F  G  H '),nl,!.

print_ranks(Board,1):-
	print_row(Board,1).

print_ranks(Board,Rank):-
	print_row(Board,Rank),nl,nl,
	Rank1 is Rank -1,
	print_ranks(Board,Rank1).

print_row(Board,Rank):-
	write(Rank),write(' '),
    write(' '),print_sq(Board,1,Rank),write(' '),
	write(' '),print_sq(Board,2,Rank),write(' '),
	write(' '),print_sq(Board,3,Rank),write(' '),
	write(' '),print_sq(Board,4,Rank),write(' '),
	write(' '),print_sq(Board,5,Rank),write(' '),
	write(' '),print_sq(Board,6,Rank),write(' '),
	write(' '),print_sq(Board,7,Rank),write(' '),
	write(' '),print_sq(Board,8,Rank),write(' '),
    write(' '),write(Rank).

	% print a single square
print_sq(Board,File,Rank):-
    get_piece(Board,File,Rank,Piece),
    atom_chars(Piece,L),
    get_sym(L,Symbol),
    write(Symbol).

% get the printable symbol of a piece
get_sym(['*'],'.').
    get_sym(['w'|T],X):-
    string_chars(X,T).
get_sym(['b'|T],X):-
    string_chars(Temp,T),
    string_upper(Temp, X).

show_moves(Board):- % show all legal moves of color to play.
	get_indx(11,Board,Color),
	generate_all_legal_moves(Board,Color,L),
	write(L),nl.
	



	
