friend(ahmed, samy).
friend(ahmed, fouad).
friend(samy, mohammed).
friend(samy, said).
friend(samy, omar).
friend(samy, abdullah).
friend(fouad, abdullah).
friend(abdullah, khaled).
friend(abdullah, ibrahim).
friend(abdullah, omar).
friend(mostafa, marwan).
friend(marwan, hassan).
friend(hassan, ali).

friend(hend, aisha).
friend(hend, mariam).
friend(hend, khadija).
friend(huda, mariam).
friend(huda, aisha).
friend(huda, lamia).
friend(mariam, hagar).
friend(mariam, zainab).
friend(aisha, zainab).
friend(lamia, zainab).
friend(zainab, rokaya).
friend(zainab, eman).
friend(eman, laila).


friendListcount(Name,Counter):-
    counter(Name,0,Counter).

counter(Name,X,Result):-
    friend(Name,Y),
    NewX is X + 1,
    counter(Y,NewX,Result).
counter(_,Count,Count).



peopleyoumayknow(X,Y):-
    not(friend(X,y)),
   friend(X,Z),
  (friend(Z,Y);friend(Y,Z)),
   X\=Y.


