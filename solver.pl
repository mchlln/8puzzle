:- use_module(library(assoc)).

%goal state
goal([[0,1,2],[3,4,5],[6,7,8]]).

%Queue implementation
empty_queue([] / []).

enqueue(X, F / B, F / [X | B]).

dequeue(X, [X | F] / B, F / B).
dequeue(X, [] / B, F / []) :- reverse(B, [X | F]).

enqueue_all([], Queue, Queue).
enqueue_all([X|Xs], Queue, NewQueue) :-
    enqueue(X, Queue, TempQueue),
    enqueue_all(Xs, TempQueue, NewQueue).

 /*enqueue_all(List, Queue, Result) :-
    foldl(enqueue, List, Queue, Result).
*/

prepend_to(L, X, [X | L]).

%different moves
move_up([[X1,X2,X3],[0,X5,X6],Row3],[[0,X2,X3],[X1,X5,X6],Row3]).
move_up([[X1,X2,X3],[X4,0,X6],Row3],[[X1,0,X3],[X4,X2,X6],Row3]).
move_up([[X1,X2,X3],[X4,X5,0],Row3],[[X1,X2,0],[X4,X5,X3],Row3]).
move_up([Row1,[X1,X2,X3],[0,X5,X6]],[Row1,[0,X2,X3],[X1,X5,X6]]).
move_up([Row1,[X1,X2,X3],[X4,0,X6]],[Row1,[X1,0,X3],[X4,X2,X6]]).
move_up([Row1,[X1,X2,X3],[X4,X5,0]],[Row1,[X1,X2,0],[X4,X5,X3]]).

move_down([[0,X2,X3],[X4,X5,X6],Row3],[[X4,X2,X3],[0,X5,X6],Row3]).
move_down([[X1,0,X3],[X4,X5,X6],Row3],[[X1,X5,X3],[X4,0,X6],Row3]).
move_down([[X1,X2,0],[X4,X5,X6],Row3],[[X1,X2,X6],[X4,X5,0],Row3]).
move_down([Row1,[0,X2,X3],[X4,X5,X6]],[Row1,[X4,X2,X3],[0,X5,X6]]).
move_down([Row1,[X1,0,X3],[X4,X5,X6]],[Row1,[X1,X5,X3],[X4,0,X6]]).
move_down([Row1,[X1,X2,0],[X4,X5,X6]],[Row1,[X1,X2,X6],[X4,X5,0]]).

move_left([[X1,0,X3],Row2,Row3],[[0,X1,X3],Row2,Row3]).
move_left([[X1,X2,0],Row2,Row3],[[X1,0,X2],Row2,Row3]).
move_left([Row1,[X1,0,X3],Row3],[Row1,[0,X1,X3],Row3]).
move_left([Row1,[X1,X2,0],Row3],[Row1,[X1,0,X2],Row3]).
move_left([Row1,Row2,[X1,0,X3]],[Row1,Row2,[0,X1,X3]]).
move_left([Row1,Row2,[X1,X2,0]],[Row1,Row2,[X1,0,X2]]).

move_right([[0,X2,X3],Row2,Row3],[[X2,0,X3],Row2,Row3]).
move_right([[X1,0,X3],Row2,Row3],[[X1,X3,0],Row2,Row3]).
move_right([Row1,[0,X2,X3],Row3],[Row1,[X2,0,X3],Row3]).
move_right([Row1,[X1,0,X3],Row3],[Row1,[X1,X3,0],Row3]).
move_right([Row1,Row2,[0,X2,X3]],[Row1,Row2,[X2,0,X3]]).
move_right([Row1,Row2,[X1,0,X3]],[Row1,Row2,[X1,X3,0]]).

next(S, T) :-(  move_up(S, T)
            ;   move_down(S, T)
            ;   move_left(S, T)
            ;   move_right(S, T)
            ).


% Check if an element is in the visited set.
is_visited(Visited, Element) :-
    get_assoc(Element, Visited, _).


bfs(  Q, _, Goal, Path) :-
    dequeue([Goal | P1],Q,_),
    reverse([Goal | P1], Path),
    print_path(Path).

bfs( Q, Visited, Goal, Path) :-
    dequeue([State | P1], Q, Q2),
    findall(T, next(State, T), Neighbors),
    exclude(is_visited(Visited), Neighbors, UnvisitedNeighbors),
    maplist(prepend_to([State | P1]), UnvisitedNeighbors, NeighborsWithPaths),
    enqueue_all(NeighborsWithPaths, Q2, Q3),
    put_assoc(State, Visited, x, Visited2),
    bfs(Q3, Visited2, Goal, Path).

% Top-level entry point
bfs(Start, Goal, Path) :-
    empty_queue(EmptyQueue),
    enqueue([Start] , EmptyQueue, InitialQueue),
    empty_assoc(Assoc),
    put_assoc(Start, Assoc, x, Assoc2),
    bfs(InitialQueue, Assoc2, Goal, Path).


print_path([]).
print_path([State | Rest]) :-
    print_state(State),
    nl(),
    print_path(Rest).

print_state([]).
print_state([Row | Rows]) :-
    print_row(Row),
    print_state(Rows).

print_row([]) :- write('\n').
print_row([X | Xs]) :-
    write(X),
    write(' '),
    print_row(Xs).

solve(Start, N) :-
    goal(Goal),
    bfs(Start, Goal, Path),
    length(Path, L),
    N #= L-1,!.
