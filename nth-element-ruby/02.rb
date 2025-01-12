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

# Represents the street layout and handles finding the minimum number of tanks
class Street
  def initialize(layout)
    @spots = layout.chars.map { |char| Spot.new(char) }
  end

  # Find the minimum number of tanks required to cover all houses
  def find_minimum_tanks
    tanks_count = 0
    index = 0

    while index < @spots.length
      if @spots[index].house?
        # If this house is already covered by a tank, skip
        if index > 0 && @spots[index - 1].tank?
          index += 1
          next
        end

        # Place a tank to the right if possible
        if index < @spots.length - 1 && @spots[index + 1].empty?
          @spots[index + 1].type = 'T'
          tanks_count += 1
        elsif index > 0 && @spots[index - 1].empty?
          # Otherwise, place a tank to the left
          @spots[index - 1].type = 'T'
          tanks_count += 1
        else
          # If no valid placement is possible, return -1
          return -1
        end
      end

      index += 1
    end

    tanks_count
  end

  # Return the updated street layout as a string
  def result
    @spots.map(&:type).join
  end
end

# Entry point to solve the problem
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
