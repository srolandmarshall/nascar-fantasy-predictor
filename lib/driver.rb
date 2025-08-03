# driver.rb

class Driver
  attr_reader :name, :salary, :avg_points_per_game, :start_pos

  # start_pos: integer starting grid position (1 = pole)
  def initialize(name:, salary:, avg_points_per_game:, start_pos:)
    @name = name
    @salary = salary
    @avg_points_per_game = avg_points_per_game
    @start_pos = start_pos
  end

  # Compute a combined score: base performance plus position-differential potential
  # Assumes a full field of 40 cars
  def score(differential_weight: 1.0, field_size: 40)
    potential_gain = field_size - start_pos
    avg_points_per_game + differential_weight * potential_gain
  end
end
