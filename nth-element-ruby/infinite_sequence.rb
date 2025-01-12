# Find the N-th element of a FibDigits sequence (in which each element is the sum of the separate digits of the two previous elements)."
# Today our world is approaching an ecological crisis. Due to global warming, the sea level is rising.
# At the same time, the amount of drinkable water is decreasing. One idea about preventing the los:
# of drinkable water is the propagation of rainwater storage, in other words, equipping houses with :
# water tank for rainwater.
#
# You are given a string S describing a street, in which 'H' denotes a house and'-' denotes an empty
# plot. You may place water tanks in empty plots to collect rainwater from nearby houses. A house
# can collect its own rainwater if there is a tank next to it (on either the left or the right side).
# Your task is to find the minimum number of water tanks needed to collect rainwater from all of the
# houses.
#
# For example, given S = "-H-HH--", you can collect rainwater from all three houses by using two
# water tanks. You can position one water tank between the first and second houses and the other
# after the third house. This placement of water tanks can be represented as "-HTHHT-", where 'T'
# denotes a water tank.
# Write a function:
#
#     ```ruby
#     def solution(s)
#     ```
#
# that, given a string S of length N, returns the minimum number of water tanks needed.
#
# If there is no solution, return -1.
#
# Examples:
#
# 1. Given S = "-H-HH--", the function should return 2, as explained above.
#
# 2. Given S = "H", the function should return -1. There is no available plot on which to place a water
# tank.
#
# 3. Given S = "HH-HH", the function should return -1. There is only one plot to put a water tank, and it
# is impossible to collect rainwater from the first and last houses.
#
# 4. Given S = "-H-H-H-H-H", the function should return 3. One possible way of placing water tanks
# is "-HTH-HTHTH".
# Assume that:
#
# • N is an integer within the range (1.20);
# • string S is made only of the characters '-' and/or 'H'.
#
# In your solution, focus on correctness. The performance of your solution will not be the focus of the
# assessment.

#
# Solution 1:
# def solution(street)
#   # Step 1: Validate if it's possible to place tanks
#   return -1 if analyze_string(street) == -1
#
#   # Step 2: Place tanks optimally and return the result
#   place_tanks(street)
# end
#
# Helper function: Analyze the string for feasibility
# def analyze_string(street)
#   street.chars.each_with_index do |plot, position|
#     if plot == 'H'
#       has_left_empty_plot = position > 0 && street[position - 1] == '-'
#       has_right_empty_plot = position < street.length - 1 && street[position + 1] == '-'
#
#       has_adjacent_empty_plot = has_left_empty_plot || has_right_empty_plot
#       return -1 unless has_adjacent_empty_plot
#     end
#   end
#   0
# end
#
# Helper function: Place tanks and count them
# def place_tanks(street)
#   street_array = street.chars
#   tanks_count = 0
#   position = 0
#
#   while position < street_array.length
#     if street_array[position] == 'H'
#       if position > 0 && street_array[position - 1] == 'T'
#         position += 1
#         next
#       elsif position < street_array.length - 1 && street_array[position + 1] == '-'
#         street_array[position + 1] = 'T'
#         tanks_count += 1
#       elsif position > 0 && street_array[position - 1] == '-'
#         street_array[position - 1] = 'T'
#         tanks_count += 1
#       else
#         return -1
#       end
#     end
#     position += 1
#   end
#
#   tanks_count
# end

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

# Represents the entire street layout and handles tank placement logic
class Street
  def initialize(layout)
    @spots = layout.chars.map { |char| Spot.new(char) }
  end

  def analyze_feasibility
    @spots.each_with_index do |spot, index|
      next unless spot.house?

      has_left_empty = index > 0 && @spots[index - 1].empty?
      has_right_empty = index < @spots.length - 1 && @spots[index + 1].empty?

      return false unless has_left_empty || has_right_empty
    end
    true
  end

  def place_tanks
    return -1 unless analyze_feasibility

    tanks_count = 0
    @spots.each_with_index do |spot, index|
      next unless spot.house?

      # Skip if house is already covered
      next if index > 0 && @spots[index - 1].tank?

      # Place a tank in the optimal position
      if index < @spots.length - 1 && @spots[index + 1].empty?
        @spots[index + 1].type = 'T'
        tanks_count += 1
      elsif index > 0 && @spots[index - 1].empty?
        @spots[index - 1].type = 'T'
        tanks_count += 1
      else
        return -1
      end
    end

    tanks_count
  end

  def result
    @spots.map(&:type).join
  end
end

# Entry point to solve the problem
class RainwaterTankSolver
  def self.solve(street_layout)
    street = Street.new(street_layout)
    street.place_tanks
  end
end

# Example Usage
puts RainwaterTankSolver.solve('-H-HH--')    # Output: 2
puts RainwaterTankSolver.solve('H')          # Output: -1
puts RainwaterTankSolver.solve('HH-HH')      # Output: -1
puts RainwaterTankSolver.solve('-H-H-H-H-H') # Output: 3
puts RainwaterTankSolver.solve('----')       # Output: 0
puts RainwaterTankSolver.solve('H-H-H-H-H')  # Output: 3
