# 8-Puzzle Solver in Prolog

The 8-puzzle, a sliding tile puzzle, challenges players to rearrange 8 tiles within a 3x3 grid. Tiles can be moved horizontally or vertically into an empty space, with the goal of reaching a specific configuration from a given starting position.

## Puzzle Representation

In Prolog, we represent the 8-puzzle as a list of lists of numbers, where 0 denotes the empty tile. For instance, the starting position could be represented as `[[3, 1, 2], [4, 7, 5], [6, 0, 8]]`.

## Predicate Specification

To solve the 8-puzzle, we define the Prolog predicate solve/2, which takes a starting configuration S and returns N, the smallest number of moves needed to reach a solution. Additionally, it prints out all positions in the solution, adhering to the specified format.

## Implementation Details

- The predicate utilizes breadth-first search to find the shortest path to the solution.
- An association list is used to hold the visited set and be more efficient than a simple list.
- A front to back queue is used to hold the current state and the path from the start.
- Various moves (move_up, move_down, move_left, move_right) simulate tile movements.
- The solution path is printed using print_path/1, print_state/1, and print_row/1 predicates.

## Example

``` prolog
?- solve([[3, 1, 2], [4, 7, 5], [6, 0, 8]], N).
3 1 2 
4 7 5 
6 0 8 

3 1 2 
4 0 5 
6 7 8 

3 1 2 
0 4 5 
6 7 8 

0 1 2 
3 4 5 
6 7 8 

N = 3.
```

## Optimization

This program is not optimized enough to work on 8 puzzles where you need a lot of states to reach the goal, you need to increase stack size or optimize the program.
