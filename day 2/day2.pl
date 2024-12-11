% Reading Input
read_file_to_strings(Path, Strings) :- open(Path, read, Stream),
					read_stream_to_strings(Stream, Strings),
					close(Stream).

read_stream_to_strings(Stream, []) :- at_end_of_stream(Stream), !.

read_stream_to_strings(Stream, [Line | MoreLines]) :- read_line_to_string(Stream, Line), 
					read_stream_to_strings(Stream, MoreLines).



% Part 1




process_input(Path, SplitStrings) :- read_file_to_strings(Path, Strings), split_list_of_strings(Strings,SplitStrings).


split_list_of_strings([],[]).

split_list_of_strings([String|T], [SplitNumbers|MoreSplitStrings]) :- split_string(String, " ", " ", SplitString), maplist(atom_number,SplitString,SplitNumbers), split_list_of_strings(T, MoreSplitStrings).


% Unsafe if all terms are not ascending or descending.
unsafe(List) :- sort(1, @=<, List, List2), List2 \= List, sort(1, @>=, List, List3), List3 \= List.


%calculate_answer(Path,) :- process_input(Path,L,R).





%Part 2
