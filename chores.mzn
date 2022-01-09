%%% Parameters %%%

enum Roommates = { Alexis, Hannah, Jacob, Jay, Martin };
enum Chores = { OutsideRecycling, InsideRecycling1, InsideRecycling2, Boilers1, Boilers2, Counters, Stove, Vacuum, Dust };
int: nWeeks = 7;
set of int: Weeks = 1..nWeeks;

% lower number = higher preference
array[Roommates,Chores] of int: preferences =
  [| 1, 7, 7, 5, 5, 4, 6, 3, 2
   | 2, 3, 3, 7, 7, 4, 5, 6, 1
   | 4, 6, 6, 1, 1, 7, 3, 2, 5
   | 1, 5, 5, 2, 2, 6, 7, 4, 3
   | 7, 5, 5, 6, 6, 3, 2, 4, 1 |];

%%% Decision variables %%%

array[Roommates, Weeks, Chores] of var bool: assignments;

%%% Constraints %%%

% Only one person per chore
constraint forall(w in Weeks, c in Chores)(sum(r in Roommates)(assignments[r,w,c]) = 1);

% Everyone should have close to the average chores per week - chores/roommates
par int: weeklyAverageChores = length(Chores) div length(Roommates);
constraint forall(r in Roommates, w in Weeks) (
                    sum(c in Chores)(assignments[r,w,c]) == weeklyAverageChores
                    \/ sum(c in Chores)(assignments[r,w,c]) = weeklyAverageChores + 1
                 );
 
% Everyone should have close to the overall average chores - weeks*chores/roommates
par int: overallAverageChores = (nWeeks * length(Chores)) div length(Roommates);
constraint forall(r in Roommates) (
                    sum(w in Weeks, c in Chores)(assignments[r,w,c]) = overallAverageChores
                    \/ sum(w in Weeks, c in Chores)(assignments[r,w,c]) = overallAverageChores + 1
                 );
                 
% The same person can't do both inside recycling chores in a given week
constraint forall(r in Roommates, w in Weeks)(not (assignments[r, w, InsideRecycling1] /\ assignments[r, w, InsideRecycling2]));

% The same person should do both boiler chores
constraint forall(r in Roommates, w in Weeks)(assignments[r, w, Boilers1] <-> assignments[r, w, Boilers2]);
           
% Can't have same chore two weeks in a row
constraint forall(r in Roommates, w in 1..nWeeks-1, c in Chores)(not (assignments[r, w, c] /\ assignments[r, w+1, c]));
constraint forall(r in Roommates, w in 1..nWeeks-1) (
                    not (assignments[r, w, InsideRecycling1]
                    /\ assignments[r, w+1, InsideRecycling2]
                 ));
constraint forall(r in Roommates, w in 1..nWeeks-1) (
                    not (assignments[r, w, InsideRecycling2]
                    /\ assignments[r, w+1, InsideRecycling1]
                 ));


%%% Optimization and solving %%%

array[Roommates] of var int: preferenceSum;
constraint forall(r in Roommates) (
                    preferenceSum[r] = sum(w in Weeks, c in Chores)(assignments[r,w,c]*preferences[r,c])
                 );

solve minimize max(preferenceSum);

%%% Output %%%
             
output  ["\(c), " | c in Chores] ++ ["\n"] ++
        [
          if fix(assignments[r,w,c]) then
            "\(r)" ++ if c = Dust then "\n" else ",\t\t" endif
          else "" endif
          | w in Weeks, c in Chores, r in Roommates
        ] ++
        [
          "\(r) has \(sum(w in Weeks, c in Chores)(assignments[r,w,c])) chores with preference sum \(fix(preferenceSum[r]))\n"
          | r in Roommates 
        ];
