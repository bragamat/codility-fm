# Find the N-th element of a FibDigits sequence (in which each element is the sum of the separate digits of the two previous elements)."
# Represents a single spot in the street (can be a house, empty spot, or tank)
class Spot
  attr_accessor :type

  def initialize(type)
    @type = type
  end

  def house?
    @type == 'H'
  end

  def empty?
    @type == '-'
  end

  def tank?
    @type == 'T'
  end
end

# Represents a water tank and its behavior
class Tank
  def initialize; end

  # Handles the logic for placing a tank
  # Returns true if a tank is successfully placed
  def place_at_house(index, spots)
    # Attempt to place the tank to the right of the house
    if index < spots.length - 1 && spots[index + 1].empty?
      spots[index + 1].type = 'T'
      return true
    end

    # If placing to the right is not possible, attempt to place it to the left
    if index > 0 && spots[index - 1].empty?
      spots[index - 1].type = 'T'
      return true
    end

    # Return false if no valid placement is possible
    false
  end
end

# Represents the street layout and orchestrates tank placement
class Street
  def initialize(layout)
    @spots = layout.chars.map { |char| Spot.new(char) }
    @tanks = [] # Keep track of tanks placed
  end

  # Analyze if the layout allows all houses to be served
  def analyze_feasibility
    @spots.each_with_index do |spot, index|
      next unless spot.house?

      has_left_empty = index > 0 && @spots[index - 1].empty?
      has_right_empty = index < @spots.length - 1 && @spots[index + 1].empty?

      return false unless has_left_empty || has_right_empty
    end
    true
  end

  # Find the minimum number of tanks required
  def find_minimum_tanks
    return -1 unless analyze_feasibility

    tanks_count = 0
    tank = Tank.new

    @spots.each_with_index do |spot, index|
      next unless spot.house?

      # Skip if house is already covered
      next if index > 0 && @spots[index - 1].tank?

      # Use the Tank class to handle placement
      return -1 unless tank.place_at_house(index, @spots)

      tanks_count += 1

      # If placement fails, return -1
    end

    tanks_count
  end

  # Get the updated street layout as a string
  def result
    @spots.map(&:type).join
  end
end

# Entry point for solving the problem
class RainwaterTankSolver
  def self.solve(street_layout)
    street = Street.new(street_layout)
    street.find_minimum_tanks
  end
end

# Example Usage
puts RainwaterTankSolver.solve('-H-HH--')    # Output: 2
puts RainwaterTankSolver.solve('H')          # Output: -1
puts RainwaterTankSolver.solve('HH-HH')      # Output: -1
puts RainwaterTankSolver.solve('-H-H-H-H-H') # Output: 3
puts RainwaterTankSolver.solve('----')       # Output: 0
puts RainwaterTankSolver.solve('H-H-H-H-H')  # Output: 3
