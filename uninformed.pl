replace(I, L, E, R) :- %to change the value in specfic index
  nth1(I, L, _, W),
  nth1(I, R, E, W).

prepareInput(L,W,[Y1,X1],[Y2,X2],FState):- %to build intial state
    S is (L*W),
    length(State,S),
    I1 is ((Y1-1)*W)+ X1,
    I2 is ((Y2-1)*W)+ X2,
    maplist((=(-)),State),
    replace(I1,State,#,NState),
    replace(I2,NState,#,FState).

solve(L,W,[Y1,X1],[Y2,X2]):-
prepareInput(L,W,[Y1,X1],[Y2,X2],State),
nb_setval(width,W),nb_setval(length,L), %global variables
Opened = [[State|[]]],
search(Opened,[]).

search(Opened, Closed):-
    getState(Opened, Current , RestOpen),
    getAllValidChildren(Current, RestOpen,Closed, Children),
    addChildren(RestOpen, Children, NewOpen),
    append(Closed,[Current],NewClosed),
    getState(Current,State,_),
    write(State),nl,
    search(NewOpen, NewClosed).



getState([Current|Rest], Current ,Rest).

getNextState([State|_],Opened,Closed,[Next,State]):-
   move(State, Next),
   \+ member([Next,_],Opened),
   \+ member([Next,_], Closed).

getAllValidChildren(Node, Opened, Closed,Children):-
    findall(Next ,getNextState(Node, Opened, Closed, Next) ,Children).

addChildren(Opened, Children, NewOpen):-
    append(Opened , Children, NewOpen).


move(State, Next):-horizontal(State,Next); vertical(State,Next),!.

horizontal(State , New):-
nb_getval(width,W),
nth1(I,State,-,_),
not(0 is I mod W ),
I2 is I+1,
nth1(I2,State,-,_),
replace(I,State,h,N),
replace(I2,N,h,New) .

vertical(State , New):-
nb_getval(width,W),
nth1(I,State,-,_),
I2 is I+W,
nth1(I2,State,-,_),
replace(I,State,v,N),
replace(I2,N,v,New).

%solve(3,3,[1,3],[2,1]).
% solve(2,4,[2,2],[2,3]).

