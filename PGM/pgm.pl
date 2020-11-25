%load some other rules and predicates.
:- [board].  % initial board position and some debug and test positions
:- [output]. % terminal print utilities and javascript GUI control
:- [utils]. % some usefull utilities
:- [mv_generation]. % piece movement definiton and moves generation
:- [eval]. % evaluate the position.
:- [search]. % search for the besst possible move.

game:-
	write('**********************************************************'),nl,
	write('*         Welcome to PGM - Prolog Grand Master           *'),nl,
	write('*                By Benny Abramovici                     *'),nl,
	write('*          enter a move in the format: e2e4              *'),nl,
	write('*    type print to display the current board position    *'),nl,
	write('*            Type quit to quit the game.                 *'),nl,
	write('**********************************************************'),nl,

	init_pos(Board),
	pick_side(Board,Board1),
	pick_level(Board1,Board2),
	play(Board2).

pick_side(Board, Board1):-
	write('choose side: w or b'),nl,
	read(X),
	((member(X,[b,w]),set_side(X,Board,Board1),!) ; (write('enter w or b'),nl,pick_side(Board,Board1) )).

set_side(Color,Board,Board1):-
	next_turn(Color,Color1),
	set_indx(Board,15,Color1,Board1).

pick_level(Board, Board1):-
	write('choose level: 1 - 3'),nl,
	read(X),
	((member(X,[1,2,3]), set_level(X,Board,Board1), !) ; (write('enter a number between 1 - 3'),nl, pick_level(Board, Board1) )).

set_level(Level,Board,Board1):-
	set_indx(Board,14,Level,Board1).
	

play(Board):-
	print_board(Board),
	get_indx(11,Board,Side), % who's side is it to move.
	generate_all_legal_moves(Board,Side,ML),
	\+ game_drawn(Board),
	\+ game_over(Board,Side),
	start_move(Board,Side,ML,NewBoard),
	play(NewBoard).

start_move(Board,Side,ML,NewBoard):-
	get_indx(15,Board,Color), % computer plays for what color.
	 Color == Side -> search_best(Board,NewBoard ); get_player_input(Board,ML,NewBoard).


	
% if is action i.e print, moves, etc, do action and read again.
% if is a move order, perform move.

% get player move or other instruction.
get_player_input(Board,ML,NewBoard):-
	read(Input),
	(process_player_input(Board,ML,NewBoard,Input)); (write('invalid input, try again'),nl,get_player_input(Board,ML,NewBoard),!).

process_player_input(Board,ML,NewBoard,Input):-
	(is_action(Board,Input), get_player_input(Board,ML,NewBoard));
	(parse_move(Board,Input,Pmove),is_legal(Pmove,ML),make_move(Board,Pmove,NewBoard)).
	
	
	
is_action(_,quit):-
	write('Thanks for playing, bye.'),nl,abort.

is_action(Board,print):-
	print_board(Board).

is_action(Board,moves):- % for debuging and testing only.
	show_moves(Board).

is_action(Board,plain):- % for debuging and testing only.
	display_plain(Board).

% perform the move, the move is in the compound form : move(ff,fr,tf,tr,mp,tp,wk,wq,bk,bq).
make_move(Board,Move,NewBoard):-
	% store the move in the 10th element of the new board(move history)
	perform_move(Board,Move,Board2),   % actually perform the move.
	finish_move(Board2,Move,Board3),    % castle second part, update casteling rights, pawn promotions, three fold repetion update, en-passant update, etc.
	% update who's turn it is to move
	get_indx(11,Board3,Side),
	next_turn(Side,NextSide),
	set_indx(Board3,11,NextSide,NewBoard).
	
% make the actually move
perform_move(Board,Move,NewBoard):-
	arg(1,Move,File),
	arg(2,Move,Rank),
	get_indx(Rank,Board,FR), %FR holds from Rank
	get_indx(File,FR,Piece), % Piece is the moving piece
	set_indx(FR,File,*,FR1),    % the piece vacated the square and now it's empty (*)
	set_indx(Board,Rank,FR1,Board1),
	arg(3,Move,ToFile),
	arg(4,Move,ToRank),
	get_indx(ToRank,Board1,TR),
	set_indx(TR,ToFile,Piece,TR1),   % set the traveling piece at the new file rank
	set_indx(Board1,ToRank,TR1,NewBoard).

% castle second part, update casteling rights, pawn promotions, three fold repetion counter update, en-passant update, etc.
finish_move(Board,Move,NewBoard):-
	arg(1,Move,FF),
	arg(3,Move,TF),
    arg(2,Move,FR),
	(is_double_pawn_start(Move) -> set_en_passant(Board,FF,Board1) ;clear_en_passant(Board,Board1)),
	% if it was an en-passant capture, remove the captured pawn.
	(was_en_passant_capture(Move) ->clear_sq(Board1,TF,FR,Board2); idle_board(Board1,Board2)),
	(did_rook_move(Board2,Move,Board3) ; idle_board(Board2,Board3)),
	(did_king_move(Board3,Move,Board4) ; idle_board(Board3,Board4)),
	(finish_castle(Board4,Move,Board5) ; idle_board(Board4,Board5)), % move rook, update casteling rights.
	(was_promotion(Board5,Move,Board6) ; idle_board(Board5,Board6)), % was this a pawn promotion move.
	three_fold_repeat(Board6,Move,NewBoard). % check and update the 3 fold repetition counter.
	

% was a move a casteling move
finish_castle(Board,move(5,1,7,1,wk,_,_,_,_,_),NewBoard):- %White king castled king side.
    sudo_move(Board,8,1,6,1,Board1),
	king_did_move(Board1,wk,Board2),
	set_indx(Board2,10,y,NewBoard).  % for eval, king security adds value

finish_castle(Board,move(5,8,7,8,bk,_,_,_,_,_),NewBoard):- %Black king castled king side.
    sudo_move(Board,8,8,6,8,Board1),
	king_did_move(Board1,bk,Board2),
	set_indx(Board2,12,y,NewBoard).  % for eval, king security adds value

finish_castle(Board,move(5,1,3,1,wk,_,_,_,_,_),NewBoard):- %White king castled queen side.
    sudo_move(Board,1,1,4,1,Board1),
	king_did_move(Board1,wk,Board2),
	set_indx(Board2,10,y,NewBoard).  % for eval, king security adds value

finish_castle(Board,move(5,8,3,8,bk,_,_,_,_,_),NewBoard):- %Black king castled queen side.
    sudo_move(Board,1,8,4,8,Board1),
	king_did_move(Board1,bk,Board2),
	set_indx(Board2,12,y,NewBoard).  % for eval, king security adds value


% is this move legal?
is_legal(Move,ML):-
	% move is in the format :  move(FF,FR,TF,TR,PM,TP,CRP)
	 arg(5,Move,PM),
	 arg(4,Move,TR),
	 arg(3,Move,TF),
	 arg(2,Move,FR),
	 arg(1,Move,FF),
	 push_front(TR,[],L1),
	 push_front(TF,L1,L2),
	 push_front(FR,L2,L3),
	 push_front(FF,L3,L4),
	 push_front(PM,L4,L5),
	 MyMv =.. L5, % now move is in the format piece(ff,fr,tf,tr)
	 member(MyMv, ML).

game_over(Board,b):-
	is_checkmate(Board),
	write('White wins, Game over'),nl,abort.


game_over(Board,w):-
	is_checkmate(Board),
	write('Black wins, Game over!') ,nl,abort.

game_drawn(Board):-
	is_draw(Board),
	write('Game over, Draw!!!'),nl,abort.


	 











	


	


	
	

	
	