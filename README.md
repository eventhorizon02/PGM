# PGM
a chess engine in prolog
PGM - Prolog Grand Master is a Chess engine written in SWI prolog.
Author : Benny Abramovici eventhorizon02@gmail.com
License : Beer, buy me a beer if you meet me somewhere in the world and this thing helped you in one way or another, use it as you see fit.
PGM was compiled with SWI prolog and has not been tested with other versions.
This project was written as an assignment for a prolog and AI class at the Open university of Israel, taught by Prof. Roy Rachmany.

************************************************
            How to play
[pgm]. to compile.
Type 'game.' to start the game.
enter a move in the format: 'e2e4'
Type 'print' to display the current board position.
Type 'quit' to quit the game.

*********************************
The board.pl file holds the initial board position plus some test positions for testing
The board position is represented as a list of lists each representing a rank having pieces and/or blanks,
it also holds other important information such as castling rights, move counter, 3 fold move counter,
and side to play.

output.pl has terminal print utilities plus time permiitng the javascript GUI interface control.

The mv_generation.pl file defines the movement of the pieces and generates all the legal moves of a side.

The eval.pl file runs the heuristic function, when the max depth of search has been reached the board position is evaluated.
according to some criteria such as material balance passed pawns etc.

search.pl runs the search algorithm, the minimax with alpha-betta pruning.








