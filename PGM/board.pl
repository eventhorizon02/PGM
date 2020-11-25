
% This file holds the board start up board position plus some additional test positions
% The board position is held in a list of eight lists each representing a rank.
% additional lists held after the rank lists are casteling rights and move history list
% * = vacant square
% wp = White pawn
% wr = White rook
% wn = White knight
% wb = White bishop
% wq = White queen
% wk = White king
% bp = Black pawn
% br = Black rook
% bn = Black knight
% bb = Black bishop
% bq = Black queen
% bk = Black king

init_pos([
		  [wr,wn,wb,wq,wk,wb,wn,wr],
		  [wp,wp,wp,wp,wp,wp,wp,wp],
		  [* ,*, *, *, *, *, *, * ],
		  [* ,*, *, *, *, *, *, * ],
		  [* ,*, *, *, *, *, *, * ],
		  [* ,*, *, *, *, *, *, * ],
		  [bp,bp,bp,bp,bp,bp,bp,bp],
		  [br,bn,bb,bq,bk,bb,bn,br],
		  [wk,wq,bk,bq],                   % castle permits, will be '*' for each permit lost
		   n,                              % for huristics, will have a y if white has casteled
		   w,							   % holds the side to move
		   n,							   % for huristics will have a y if black has casteled
		   0,							   % three fold counter.
		   2,							   % depth of search or level
		   b,							   % computer plays for b/w side.
		   0							   % the current en-passnt file, 0 means there isn't.
		   
									]).
					


	init_pos2([
		  [* ,*, *, *, *, *, *,wk ],
		  [bq,*, *, *, *, *, *, * ],
		  [* ,*, *, *, *, *, *, * ],
		  [* ,*, *, *, *, *, *, * ],
		  [* ,*, *, *, *, *, *, * ],
		  [* ,*, *, *, *, *, *, * ],
		  [* ,*, *, *, *, *, *, * ],
		  [*,br, *, *, bk,*, *, * ],
		  [*,*,*,*],                   
		   n,                           
		   w,							   
		   n,							   
		   0,							   
		   2,							   
		   b,							   
		   0							   
									]).

init_pos3([
		  [wr,wn,wb,* ,wk,* ,wn,wr],
		  [wp,wp,wp,wp,* ,wp,wp,wp],
		  [* ,*, *, *, *, *, *, * ],
		  [* ,bn,wb,*, *, *, *, * ],
		  [* ,*, *, *,wp, *, *,wq ],
		  [* ,*, *, *, *, *, *, * ],
		  [bp,bp,bp,bp,bp,bp,bp,bp],
		  [br,bn,bb,bq,bk,bb,br,* ],
		  [wk,wq,bk,bq],                   
		   n,                           
		   w,							   
		   n,							   
		   0,							   
		   2,							   
		   b,							   
		   0
		  							 ]).		

init_pos4([
		  [*, *, *, *, wk,*, *, * ],
		  [*, *, *, *, *, *, *, * ],
		  [* ,*, *, *, *, *, *, * ],
		  [* ,bn,wb,*, *, *, *, * ],
		  [* ,*, *, *, *, *, *,wq ],
		  [* ,*, *, *, *, *, *, * ],
		  [*, *, *, * ,*,bp, *, * ],
		  [*, *, *, br,bk,*, *, * ],
		  [*,*,*,*],                   
		   n,                           
		   w,							   
		   n,							   
		   0,							   
		   2,							   
		   w,							   
		   0
		  							 ]).						   

								