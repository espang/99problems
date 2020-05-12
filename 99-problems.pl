% This file contains exercises from:
% https://www.ic.unicamp.br/~meidanis/courses/mc336/2009s2/prolog/problemas/


% p01: find the last element of a list.
my_last(X, [X | []]).
my_last(X, [_ | Y]) :- my_last(X, Y).


% p02: find the last but one element of a list.
second_last(X, [X, _ | []]).
second_last(X, [_ | Y]) :- second_last(X, Y).

% p03: find the k'th element of a list.
element_at(X, [X | _], 1).
element_at(X, [_ | Y], I) :-
    NewI is I - 1,
    element_at(X, Y, NewI).

% p04: count
count(0, []).
count(X, [_ | Ys]) :- count(X1, Ys), X is X1 + 1.

% p05: reverse
reverse(X, [], X).
reverse(Acc, [X | Xs], Z) :-
    reverse([X | Acc], Xs, Z).
reverse(X, Y) :- reverse([], Y, X).

% p06: palindrome?
is_palindrome(X) :- reverse(R, X), X = R.

% p07: flatten
my_flatten([], []).
my_flatten([X | Xs], Out) :-
    is_list(X),
    my_flatten(X, Y1),
    my_flatten(Xs,Y2),
    append(Y1, Y2, Out).
my_flatten([X | Xs], Out) :-
    my_flatten(Xs, Out2),
    append([X], Out2, Out).

% p08: compress by eliminating consecutive duplicates of list elements
compress([X | Xs], Out) :-
    my_compress(Xs, Result, X),
    append([X], Result, Out).
my_compress([], [], _).
my_compress([X | Xs], Out, X) :-
    my_compress(Xs, Out, X).
my_compress([X | Xs], Out, Y) :-
    X \= Y,
    my_compress(Xs, Result, X),
    append([X], Result, Out).

% p09: pack
pack([X | Xs], Out) :-
    pack(Xs, Out, X, [X]).
pack([], [Sublist], _, Sublist).
pack([X | Xs], Out, X, Sublist) :-
    pack(Xs, Out, X, [X | Sublist]).
pack([X | Xs], Out, Y, Sublist) :-
    X \= Y,
    pack(Xs, PrevOut, X, [X]),
    append([Sublist], PrevOut, Out).


% p10: run-length-encoding
first([X | _], X).
run_length_packed([], []).
run_length_packed([X | Xs], Out) :-
    count(C, X), % count elements in list X
    first(X, Element),
    run_length_packed(Xs, PrevOut),
    append([[C, Element]], PrevOut, Out).
run_length(In, Out) :-
    pack(In, Packed),
    run_length_packed(Packed, Out).

% p11: 
encode_modified_rec([], []).
encode_modified_rec([X | Xs], Out) :-
    count(C, X),
    first(X, Element),
    encode_modified_rec(Xs, Prev),
    (C = 1 ->
         append([Element], Prev, Out)
    ;
         append([[C, Element]], Prev, Out)
    ).
encode_modified(In, Out) :-
    pack(In, Packed),
    encode_modified_rec(Packed, Out).

% p12:
repeat(0, _, []).
repeat(C, Element, [Element | Acc]) :-
    NewC is C - 1,
    repeat(NewC, Element, Acc).

decode_tuple([ C, Element | []], Out) :-
    repeat(C, Element, Out).

decode_element(In, Out) :-
    is_list(In),
    decode_tuple(In, Out).
decode_element(In, [In]).

decode([], []).
decode([X | Xs], Out) :-
    decode_element(X, Sublist),
    decode(Xs, Acc),
    append(Sublist, Acc, Out).

% p13:

encode_direct([], X, 1, [X]).
encode_direct([], X, C, [[C, X]]).
% repeated element. Increase the counter
encode_direct([X | Xs], X, C, Prev) :-
    NewC is C + 1,
    encode_direct(Xs, X, NewC, Prev).
% changed element. Previous count was 1. Add single element
encode_direct([X | Xs], Y, 1, [Y | Prev]) :- 
    encode_direct(Xs, X, 1, Prev).
% changed element. Previous element has repeatition. Add tuple
encode_direct([X | Xs], Y, C, [[C, Y] | Prev]) :-
    encode_direct(Xs, X, 1, Prev).
encode_direct([X | Xs], Out) :-
    encode_direct(Xs, X, 1, Out). 

% p14:
% takes a list and duplicates every element
dupli([], []).
dupli([X | Xs], [X, X| P]) :-
    dupli(Xs, P).

% p15:
dupli([], _, []).
dupli([X | Xs], C, Out) :-
    repeat(C, X, Sub),
    dupli(Xs, C, Prev),
    append(Sub, Prev, Out).

% p16:
drop_nth([], _, _, []).
drop_nth([_ | Xs], N, N, O) :-
    drop_nth(Xs, N, 1, O).
drop_nth([X | Xs], N, C, [X | O]) :-
    NewC is C + 1,
    drop_nth(Xs, N, NewC, O).
drop_nth(ListIn, N, ListOut) :-
    drop_nth(ListIn, N, 1, ListOut).

% p17:
split([X | Xs], Idx, Idx, [X], Xs).
split([X | Xs], Idx, C, [X | Pre], Post) :-
    NewC is C + 1,
    split(Xs, Idx, NewC, Pre, Post).
split(ListIn, Idx, Pre, Post) :-
    split(ListIn, Idx, 1, Pre, Post).

% p18:
subs(_, 1, 0, []).
subs([X | Xs], 1, K, [X | Ys]) :-
    K > 0, K1 is K - 1, 
    subs(Xs, 1, K1, Ys).
subs([_ | Xs], Start, End, ListOut) :-
    Start > 1,
    End > Start,
    S1 is Start - 1,
    E1 is End - 1,
    subs(Xs, S1, E1, ListOut).

% p19:
rotate(ListIn, Idx, ListOut) :-
    length(ListIn, L),
    L > Idx,
    split(ListIn, Idx, Pre, Post),
    append(Post, Pre, ListOut).
rotate(ListIn, Idx, ListOut) :-
    length(ListIn, L),
    Idx < 0,
    NewIdx is L + Idx,
    rotate(ListIn, NewIdx, ListOut).

% p20:
remove_at([X | Xs], 1, X, Xs).
remove_at([X | Xs], Idx, Element, [X | Prev]) :-
    Idx > 1,
    NewIdx is Idx - 1,
    remove_at(Xs, NewIdx, Element, Prev).

% p21:
insert_at([], Element, _, [Element]).
insert_at(Xs, Element, 1, [Element | Xs]).
insert_at([X | Xs], Element, Idx, [X | Prev]) :-
    Idx > 1,
    NewIdx is Idx - 1,
    insert_at(Xs, Element, NewIdx, Prev).

% p22:
range(E, E, [E]).
range(S, E, [S | P]) :-
    S < E,
    NewS is S + 1,
    range(NewS, E, P).
    
% p23:
rnd_select(_, 0, []).
rnd_select(ListIn, N, [E | O]) :-
    N > 0,
    length(ListIn, L),
    L1 is L + 1,
    random(1, L1, R),
    remove_at(ListIn, R, E, Rest),
    N1 is N - 1,
    rnd_select(Rest, N1, O).
    
% p24:
select_n_from_k(N, K, O) :-
    range(1, K, All),
    rnd_select(All, N, O).

% p25:
rnd_perm(In, Out) :-
    length(In, L),
    rnd_select(In, L, Out).

% p26:
combinations(0, _, []).
combinations(N, ListIn, ListIn) :-
    N > 0,
    length(ListIn, L),
    L = N.
combinations(N, [X|Xs], [X|Combs]) :-
    N > 0,
    length(Xs, L),
    L >= N,
    N1 is N - 1,
    combinations(N1, Xs, Combs).
combinations(N, [_|Xs], Combs) :-
    N > 0,
    length(Xs, L), 
    L >= N,
    combinations(N, Xs, Combs).

combinations_alt(0, _, []).
combinations_alt(N, [X|Xs], Out) :-
    N > 0,
    length(Xs, L1),
    succ(L1, L),
    (L = N ->
         append([X], Xs, Out);
     L > N ->
         (N1 is N - 1,
          combinations_alt(N1, Xs, Combs),
          append([X], Combs, Out);
          combinations_alt(N, Xs, Out)
         )
    ).
     
% p27 part 1: group of 9 people into disjoint subgroups of 2, 3 and 4
remove(_, [], []).
remove([], L, L).
remove([X|Xs], ListIn, ListOut) :- 
    remove(X, ListIn, O),
    remove(Xs, O, ListOut).
remove(Element, [X|Xs], [X|Out]) :- X \= Element, remove(Element, Xs, Out).
remove(Element, [Element|Xs], Out) :- remove(Element, Xs, Out).
group3(All, G1, G2, G3) :-
    combinations(2, All, G1),
    remove(G1, All, NotG1),
    combinations(3, NotG1, G2),
    remove(G2, NotG1, G3).
