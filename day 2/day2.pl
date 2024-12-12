% Reading Input
read_file_to_strings(Path, Strings) :- open(Path, read, Stream),
					read_stream_to_strings(Stream, Strings),
					close(Stream).

read_stream_to_strings(Stream, []) :- at_end_of_stream(Stream), !.

read_stream_to_strings(Stream, [Line | MoreLines]) :- read_line_to_string(Stream, Line), 
					read_stream_to_strings(Stream, MoreLines).



% Part 1
process_input(Path, SplitStrings) :- read_file_to_strings(Path, Strings), split_list_of_strings(Strings,SplitStrings).


%split_list_of_strings/2 Takes a list of strings and splits them each into digits.
split_list_of_strings([],[]).

split_list_of_strings([String|T], [SplitNumbers|MoreSplitStrings]) :- split_string(String, " ", " ", SplitString), maplist(atom_number,SplitString,SplitNumbers), split_list_of_strings(T, MoreSplitStrings).


%unsafe/1
% Unsafe if all terms are not ascending or descending.
unsafe(List) :- sort(0, @=<, List, List2), List2 \= List, sort(0, @>=, List, List3), List3 \= List, !.

% Unsafe if adjacent terms differ by 0 or more than 3.
unsafe([]) :- false, !.
unsafe([H1|[H2|_]]) :- Diff is abs(H1-H2), Diff = 0, !.
unsafe([H1|[H2|_]]) :- Diff is abs(H1-H2), Diff > 3, !.
unsafe([_|T]) :- unsafe(T).



calculate_part_1(Path, Count) :- process_input(Path,List), aggregate_all(count,in_list_and_safe(_,List), Count).

in_list_and_safe(X, List) :- member(X,List), \+ unsafe(X).



%Part 2
%check all sublists... Too extensive?

calculate_part_2(Path, Count) :- process_input(Path,List), aggregate_all(count,in_list_and_dampened_safe(_,List), Count).


dampened_unsafe(List) :- unsafe(List), all_sublists(List, AllSublists), maplist(unsafe, AllSublists).


in_list_and_dampened_safe(X, List) :- member(X,List), \+ dampened_unsafe(X).

remove_one_elem(List, Removed, Sublist) :- append(Before, [Removed|After], List), append(Before, After, Sublist).

all_sublists(List, AllSublists) :- findall(Sublist, remove_one_elem(List, _, Sublist), AllSublists).
