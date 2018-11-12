peg :-
	writeln("\n---- Solution starting from Position #1 (please be patient) ----"),
	peg_1(Solutions), % find one solution beginning at position #1
	display(Solutions, [1], 1), % the last argument, with value 1, is just a sentinal value so the correct method is called
	
	writeln("\n---- Solution starting from Position #2 (please be patient) ----"),
	peg_2(Solutions2), % find one solution beginning at position #2
	display(Solutions2, [2], 1),
	
	writeln("\n---- Solution starting from Position #3 (please be patient) ----"),
	peg_3(Solutions3), % find one solution beginning at position #3
	display(Solutions3, [3], 1),
	
	writeln("\n---- Solution starting from Position #4 (please be patient) ----"),
	peg_4(Solutions4), % find one solution beginning at position #4
	display(Solutions4, [4], 1).

peg_1(Solutions) :-
	simulate([1], [2,3,4,5,6,7,8,9,10,11,12,13,14,15], [], Solutions). % find solutions starting at #1

peg_2(Solutions) :-
	simulate([2], [1,3,4,5,6,7,8,9,10,11,12,13,14,15], [], Solutions). % find solutions starting at #2

peg_3(Solutions) :-
	simulate([3], [1,2,4,5,6,7,8,9,10,11,12,13,14,15], [], Solutions). % find solutions starting at #3

peg_4(Solutions) :-
	simulate([4], [1,2,3,5,6,7,8,9,10,11,12,13,14,15], [], Solutions). % find solutions starting at #4

simulate(_, [_], List, Solutions) :- % reversed solutions are also solutions
	reverse(List, Solutions). % reversed solutions

simulate(Free, Occupied, List, Solutions) :- % simulate a play
	select(Start, Occupied, Occupied_2), % choose starting spots
	select(Occupied_1, Occupied_2, Occupied_3), % find occupied spots
	select(End, Free, Free_1), % select end spots
	possible_move(Start, Occupied_1, End), % store possible move (this is a solution)
	simulate([Start, Occupied_1 | Free_1], [End | Occupied_3], [possible_move(Start, Occupied_1, End) | List], Solutions), !. % recursive call, however the ! stops the backtracking after the first solution is found, because this is more similar to the python version's output

% on a 15-spot board, these are all of the possible moves, in both directions
possible_move(Start,2,End) :-
	member([Start, End], [[1,4], [4,1]]).
possible_move(Start,3,End) :-
	member([Start, End], [[1,6], [6,1]]).
possible_move(Start,4,End) :-
	member([Start, End], [[2,7], [7,2]]).
possible_move(Start,5,End) :-
	member([Start, End], [[2,9], [9,2]]).
possible_move(Start,5,End) :-
	member([Start, End], [[3,8], [8,3]]).
possible_move(Start,6,End) :-
	member([Start, End], [[3,10], [10,3]]).
possible_move(Start,5,End) :-
	member([Start, End], [[4,6], [6,4]]).
possible_move(Start,7,End) :-
	member([Start, End], [[4,11], [11,4]]).
possible_move(Start,8,End) :-
	member([Start, End], [[4,13], [13,4]]).
possible_move(Start,8,End) :-
	member([Start, End], [[5,12], [12,5]]).
possible_move(Start,9,End) :-
	member([Start, End], [[5,14], [14,5]]).
possible_move(Start,9,End) :-
	member([Start, End], [[6,13], [13,6]]).
possible_move(Start,10,End) :-
	member([Start, End], [[6,15], [15,6]]).
possible_move(Start,8,End) :-
	member([Start, End], [[9,7], [7,9]]).
possible_move(Start,9,End) :-
	member([Start, End], [[10,8], [8,10]]).
possible_move(Start,12,End) :-
	member([Start, End], [[11,13], [13,11]]).
possible_move(Start,13,End) :-
	member([Start, End], [[12,14], [14,12]]).
possible_move(Start,14,End) :-
	member([Start, End], [[15,13], [13,15]]).
 
process(Free, List, Peg) :- % process the list to determine which spots are free
	member(List, Free) -> Peg = 0; Peg = 1. % set free/occupied

display(Sol, Free, Start) :- % initialise the display methods -- the 3rd	
	forall(true, display(Sol, Free)). % forall processes the display and removes the need for the semicolon prompt

display([], Free) :-
	numlist(1,15, List), % get numbers 1-15
	maplist(process(Free), % process the list and set spot_X to correct value
		List, % all integers
		[Spot_1,Spot_2,Spot_3,Spot_4,Spot_5,Spot_6,Spot_7,Spot_8,Spot_9,Spot_10,Spot_11,Spot_12,Spot_13,Spot_14,Spot_15]), % spots
	format('    ~w        ~n', [Spot_1]),
	format('   ~w ~w      ~n', [Spot_2,Spot_3]),
	format('  ~w ~w ~w    ~n', [Spot_4,Spot_5,Spot_6]),
	format(' ~w ~w ~w ~w  ~n', [Spot_7,Spot_8,Spot_9,Spot_10]),
	format('~w ~w ~w ~w ~w~n', [Spot_11,Spot_12,Spot_13,Spot_14,Spot_15]),
	writeln(solved).

display([possible_move(Start, Middle, End) | Tail], Free) :- % display possible move
	numlist(1,15, List),
	maplist(process(Free),
		List,
		[Spot_1,Spot_2,Spot_3,Spot_4,Spot_5,Spot_6,Spot_7,Spot_8,Spot_9,Spot_10,Spot_11,Spot_12,Spot_13,Spot_14,Spot_15]),
	format('    ~w        ~n', [Spot_1]),
	format('   ~w ~w      ~n', [Spot_2,Spot_3]),
	format('  ~w ~w ~w    ~n', [Spot_4,Spot_5,Spot_6]),
	format(' ~w ~w ~w ~w  ~n', [Spot_7,Spot_8,Spot_9,Spot_10]),
	format('~w ~w ~w ~w ~w~n', [Spot_11,Spot_12,Spot_13,Spot_14,Spot_15]),
	format('Jumped from position ~w to ~w, over ~w~n~n~n', [Start, End, Middle]),
	select(End, Free, Free_1),
	display(Tail,  [Start, Middle | Free_1]).
