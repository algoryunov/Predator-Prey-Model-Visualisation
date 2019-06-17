# Welcome to 'Prey-Predator Model Visialisation' application!

My first try in Swift.

Inspired by:  [Lotka–Volterra equations](https://en.wikipedia.org/wiki/Lotka–Volterra_equations)

![Screenshot:](https://github.com/algoryunov/Predator-Prey-Model-Visualisation/blob/master/PP2/Support%20files/Screenshot.png)

- Closed area is filled by Preys and Predators. Population density and percentantage of particular creature types can be adjusted by 'Creatures Fill Coef' and 'Prey Fill Coef' (Predators fill coef is always equal to (1 - Preys_Fill_Coef))
- Creatures cannot neither leave the area, nor come inside to the area from the outer space.
- Every time you make a turn - all creatures moves to a random direction or stays at the same position.
- If predator is on the same position with prey - predator eats prey
- Predators have a 'Hunger Coef' (initial value can be adjusted in Settings). Each time predator eats a prey (or preys) - coef is increased, each time predator doesn't eat a prey - coef is decreased. If coef's value becomes <= 0 -> predators dies.
- Both predators and preys can 'create' new creatures. Possibility of this event can be adjusted by the Prey/Predator Born Coefs
- Maximum number of Creatures at single position is limited and can be adjusted by 'Max Creatures Num At Position' coef. If all border positions around creature are occupied - new creature is not appearing no matter which Born Coef you set. A number on the top right corner of creature's cell representes the current number of creatures at the same position.

# Note:

Pacman = Predator;

Ghosts = Preys
