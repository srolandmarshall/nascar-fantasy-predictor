# frozen_string_literal: true

# Represents a race slate with a pool of drivers and a salary cap

# Represents a NASCAR race, encapsulating race-specific parameters and logic for fantasy lineup optimization.
#
# Attributes:
# - drivers: Array of Driver objects participating in the race.
# - salary_cap: Numeric value representing the maximum allowed salary for a lineup.
# - differential_weight: Float indicating the weight applied to position differential scoring, can be race-specific.
# - field_size: Integer representing the total number of drivers in the race (default: 40).
# - name: String name of the race venue.
#
# Constants:
# - DIFFERENTIAL_WEIGHTS: Hash mapping race venue names to their respective differential weights.
#
# Methods:
# - initialize(name, drivers, salary_cap, differential_weight: nil, field_size: 40):
#   Initializes a Race instance with provided parameters.
#   If differential_weight is not specified, uses the default for the venue or 1.0.
# - generate_prediction:
#   Computes the optimal 6-driver lineup under the salary cap by evaluating all possible combinations and maximizing
#   the total score. Returns a Prediction object containing the best lineup and its score.
class Race
  attr_reader :drivers, :salary_cap, :differential_weight, :field_size, :name

  # Differential weights by race (estimate based on passing difficulty & position volatility)
  DIFFERENTIAL_WEIGHTS = {
    'Daytona International Speedway' => 0.3,
    'Talladega Superspeedway' => 0.3,
    'Martinsville Speedway' => 2.0,
    'Bristol Motor Speedway' => 1.8,
    'Richmond Raceway' => 1.7,
    'Nashville Superspeedway' => 1.6,
    'Dover International Speedway' => 1.5,
    'Darlington Raceway' => 1.4,
    'Atlanta Motor Speedway' => 1.2,
    'Phoenix Raceway' => 1.3,
    'Kansas Speedway' => 1.0,
    'Charlotte Motor Speedway' => 1.0,
    'Pocono Raceway' => 0.9,
    'Indianapolis Motor Speedway' => 0.8,
    'Circuit of the Americas' => 0.4,
    'Watkins Glen International' => 0.5,
    'Iowa Speedway' => 1.6
  }

  # name: string of race venue; used to lookup default differential_weight
  # differential_weight: optional override
  def initialize(track_name:, drivers:, salary_cap: 50_000, differential_weight: nil, field_size: 40)
    @track_name = track_name
    @drivers = drivers
    @salary_cap = salary_cap
    @field_size = field_size
    @differential_weight = differential_weight || DIFFERENTIAL_WEIGHTS[name] || 1.0
  end

  # Generates the optimal 6-driver prediction under the salary cap
  # by brute-force combination search, maximizing combined score
  def generate_prediction
    best_lineup = nil
    best_score = 0.0

    drivers.combination(6).each do |combo|
      total_salary = combo.sum(&:salary)
      next if total_salary > salary_cap

      total_score = combo.sum { |drv| drv.score(differential_weight: differential_weight, field_size: field_size) }
      if total_score > best_score
        best_score = total_score
        best_lineup = combo
      end
    end

    Prediction.new(best_lineup || [], best_score)
  end
end
