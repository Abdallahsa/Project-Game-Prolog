replace(I, L, E, R) :- %to change the value in specfic index
  nth1(I, L, _, W),
  nth1(I, R, E, W).

prepareInput(L,W,[Y1,X1],[Y2,X2],FState):- %to build intial state
    S is (L*W),
    length(State,S),
    I1 is ((Y1-1)*W)+ X1,
    I2 is ((Y2-1)*W)+ X2,
    maplist((=(-)),State),
    replace(I1,State,#,NState),% [state,parent,G,H,F]
    replace(I2,NState,#,FState).

solve(L,W,[Y1,X1],[Y2,X2]):-
prepareInput(L,W,[Y1,X1],[Y2,X2],State),
nb_setval(width,W),nb_setval(length,L), %global variables
Opened = [[State,[],0,0,0]],
search(Opened,[],[]).

/*
search([], Closed):-%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	getBestState([], [CurrentState,Parent,G,H,F], _), % Step 1
	%CurrentState = Goal, % Step 2
	write("Search is complete!"), nl,
	printSolution([CurrentState,Parent,G,H,F], Closed), !.
*/
search(Open, Closed,Nums):-
	getBestState(Open, CurrentNode, TmpOpen),
	getAllValidChildren(CurrentNode,TmpOpen,Closed,Children), % Step3
	addChildren(Children, TmpOpen, NewOpen), % Step 4
	append(Closed, [CurrentNode], NewClosed), % Step 5.1
	getDom(CurrentNode,2,Dom,Nums),
        %checkPrint(Dom,Nums),
        write(Dom),nl,
        search(NewOpen, NewClosed,Nums).
        %(search(NewOpen, NewClosed,Nums)).
getDom([State,_,_,_,_],Bombs,F,Nums):-
	length(State,Len),
	countEmptyCells(State,0,C),
        (   X is Bombs+C),
	(   B is (Len-X)),
        (   F is (B/2)),
        checkPrint(F,Nums).
	%write(F),nl.
checkPrint(Max, Nums):-
  (   member(Max,Nums) -> (write(Max),!) ; true).

countEmptyCells([],Temp,Temp):-!.
countEmptyCells([H|T],Temp,Count):-
	((   H = '-',
	C1 is Temp+1,
	countEmptyCells(T,C1,Count));
       (countEmptyCells(T,Temp,Count)  ) ),
        !.
% Implementation of step 3 to get the next states
getAllValidChildren(Node, Open, Closed, Children):-
	findall(Next, getNextState(Node,Open,Closed,Next),Children).

getNextState([State,_,G,_,_],Open,Closed,[Next,State,NewG,NewH,NewF]):-
	move(State, Next, MoveCost),
	isOkay(Next),
	calculateH(Next, NewH),%[#,1,3,4]
	NewG is G + MoveCost,
	NewF is NewG + NewH,
	not(member([Next,_,_,_,_], Open)),
	not(member([Next,_,_,_,_], Closed)).

% Implementation of addChildren and getBestState
addChildren(Children, Open, NewOpen):-
	append(Open, Children, NewOpen).

getBestState(Open, BestChild, Rest):-
	findMax(Open, BestChild),
	delete(Open, BestChild, Rest).

% Implementation of findMax in getBestState determines the search alg.
% Greedy best-first search
findMax([X], X):- !.
findMax([Head|T], Max):-
	findMax(T, TmpMax),
	Head = [_,_,_,HeadH,_],
	TmpMax = [_,_,_,TmpH,_],
	(TmpH > HeadH -> (Max = TmpMax,!); (Max = Head)).

% Instead of adding children at the end and searching for the best
% each time using getBestState, we can make addChildren add in the
% right place (sorted open list) and getBestState just returns the
% head of open.
% Implementation of printSolution to print the actual solution path
printSolution([State, null, G, H, F],_):-
	write([State, G, H, F]), nl.

printSolution([State, Parent, G, H, F], Closed):-
	member([Parent, GrandParent, PrevG, Ph, Pf], Closed),
	printSolution([Parent, GrandParent, PrevG, Ph, Pf], Closed),
	write([State, G, H, F]), nl.


calculateH(State, Hvalue):-
	nb_getval(length,L),

	adjacentRight(State,0,L,0,Right),
	adjacentDown(State,0,L,0,Down),
	(Right > Down -> Hvalue = Right ; Hvalue = Down).

adjacentRight(State,I,_,CNum,CNum):-
	length(State,Len),
	I >= Len,
	!.
adjacentRight(State,I,L,CNum,Num):-
	nth0(I,State,Val),%[-,#,-,-,-,#,-,-,-]
	NextI is I+1,
	(   (Val = '-',
	not(0 is (NextI mod L)),
	nth0(NextI,State,Adj),
	Adj = '-',
	NNum is CNum+1,
	adjacentRight(State,NextI,L,NNum,Num));
	adjacentRight(State,NextI,L,CNum,Num))
	,!.




adjacentDown(State,I,_,CNum,CNum):-
	length(State,Len),
	I >= Len,
	!.

adjacentDown(State,I,L,CNum,Num):-
	nth0(I,State,Val),%[-,#,-,-,-,#,-,-,-]
	NextI is I+L,
	I1 is I+1,
	length(State,Len),
	(
        (Val = -,
	not(((I < Len),(I >= Len-L))), % if index is not between the laset row
	nth0(NextI,State,Adj),
	Adj = -,
	NNum is CNum+1,
	adjacentDown(State,I1,L,NNum,Num));
	(adjacentDown(State,I1,L,CNum,Num))).

isOkay(_):- true. % This problem has no rules






move(State, Next,1):-horizontal(State,Next); vertical(State,Next),!.

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
%solve(2,4,[2,2],[2,3]).

