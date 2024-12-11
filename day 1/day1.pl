% Reading Input
read_file_to_strings(Path, Strings) :- open(Path, read, Stream),
					read_stream_to_strings(Stream, Strings),
					close(Stream).

read_stream_to_strings(Stream, []) :- at_end_of_stream(Stream), !.

read_stream_to_strings(Stream, [Line | MoreLines]) :- read_line_to_string(Stream, Line), 
					read_stream_to_strings(Stream, MoreLines).



% Part 1
% First Attempt. 
% distance([],[],A,A) :- !.

% distance([A],[B],Z,C) :- !, C is abs(A - B) + Z.
 
% distance([H1|T1],[H2|T2],Z2,Z3) :- distance([H1],[H2],Z2,Z1), distance(T1,T2,Z1,Z3).


%Attempt 2
distance(L1, L2, Distance) :- sub_list(L1,L2,Diff_List), maplist(abs,Diff_List,Dist_List), sum_list(Dist_List, Distance).

sub_list([],[],[]).
sub_list([H1|T1], [H2|T2], [Diff|TDiff]) :- Diff is H1 - H2, sub_list(T1,T2,TDiff).



process_input(Path, L, R) :- read_file_to_strings(Path, Strings), split_list_of_strings(Strings, [], [], L, R).



separate_left_and_right([],[],[]).
separate_left_and_right(String, L, R) :- split_string(String, " ", " ", [L|[R|_]]).


split_list_of_strings([],L,R,L,R).

split_list_of_strings([String|T],L,R,L2,R2) :- separate_left_and_right(String,L1,R1), atom_number(L1,Z), atom_number(R1,W), append(L,[Z],X), append(R,[W],Y), split_list_of_strings(T,X,Y,L2,R2).



calculate_answer(Path,Distance) :- process_input(Path,L,R), msort(L,L_sorted), msort(R, R_sorted), distance(L_sorted, R_sorted, Distance).





%Part 2
occurance_count([],_,[]).
occurance_count([H|T], List, [Count|MoreCount]) :- aggregate_all(count, member(H, List), Count), occurance_count(T, List, MoreCount).


calculate_part_2(Path, Similarity) :- process_input(Path,L,R), find_count_and_multiply(L, R, X), sum_list(X, Similarity). 

find_count_and_multiply([],_,[]).
find_count_and_multiply([H|T], R, [X|MoreX]) :- occurance_count([H], R, Count), X is H * Count, find_count_and_multiply(T, R, MoreX).
