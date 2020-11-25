% This file runs the search algorithm, the minimax with alpha-beta prunning.

search_best(Board,NewBoard):-
    get_indx(14,Board,Depth), % max depth of search.
    alphabeta(Board,-100000,100000,NewBoard,_, Depth).



alphabeta(Pos, Alpha, Beta, GoodPos, Val, Depth):-
	Depth > 0,
	moves(Pos, PosList), !,
	boundedbest(PosList, Alpha, Beta, GoodPos, Val, Depth);
	get_pos_value(Pos,Val).								% static value of position

boundedbest([Pos | PosList], Alpha, Beta, GoodPos, GoodVal, Depth):-
	NewDepth is Depth - 1,
	alphabeta(Pos, Alpha, Beta,_,Val, NewDepth),
	goodenough(PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal, Depth).

goodenough([],_,_,Pos, Val, Pos, Val,_):- !.				% no other candidate

goodenough(_,Alpha,Beta, Pos, Val, Pos, Val,_) :-
	min_to_move(Pos), Val > Beta, !;					% Maximizer attainded upper bound
	max_to_move(Pos), Val < Alpha,!.					% Minimizer attained lower bound

goodenough(PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal, Depth):-
	newbounds(Alpha, Beta, Pos, Val, NewAlpha, NewBeta), % refine bounds
	boundedbest(PosList, NewAlpha, NewBeta, Pos1, Val1, Depth),
	betterof(Pos,Val, Pos1, Val1, GoodPos, GoodVal).

newbounds(Alpha, Beta, Pos, Val, Val, Beta):-
	min_to_move(Pos), Val > Alpha, !.					% Maximizer increased lower bound

newbounds(Alpha, Beta, Pos, Val, Alpha, Val):-
	max_to_move(Pos), Val < Beta, !.					% Minimizer decreased upper bound

newbounds(Alpha, Beta, _, _ , Alpha, Beta).				% otherwise bounds unchanged

betterof(Pos, Val,_, Val1, Pos, Val):-				% Pos better than Pos1
	min_to_move(Pos), Val > Val1,!;
	max_to_move(Pos), Val < Val1,!.

betterof(_,_,Pos1,Val1,Pos1,Val1).						% Otherwise Pos1 better




