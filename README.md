# ChoreScheduler
Assigns weekly chores to the roommates using constraint programming

Uses minizinc with google or-tools solver.

## Constraints
Only one roommate per chore

Every roommate should have close to the average chores per week: chores/roommates

Every roommate should have close to the overall average chores: weeks*chores/roommates
                 
The same roommate can't do both inside recycling chores in a given week

The same roommate should do both boiler chores in a given week
           
Any roommate can't have the same chore two weeks in a row

## Optimization
Given everyone's chore preferences from most to least enjoyed, with most enjoyed represented with smaller numbers, calculate each roommate's preference sum. A smaller sum means they were assigned more preferable chores.

Then minimize the maximum of the roommates' preference sums.

## Final Chore Chart
The generated chore chart can be found in the CSV.

Final result:

Alexis has 27 chores with preference sum 76

Hannah has 27 chores with preference sum 77

Jacob has 27 chores with preference sum 75

Jay has 27 chores with preference sum 73

Martin has 27 chores with preference sum 77

mzn-stat: objective=77

mzn-stat: objectiveBound=77

mzn-stat: boolVariables=680

mzn-stat: failures=314373

mzn-stat: propagations=41109882

mzn-stat: solveTime=524.173
