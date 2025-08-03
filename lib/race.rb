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
    'Iowa Speedway' => 1.6,
    'Auto Club Speedway' => 1.0,
    'Sonoma Raceway' => 0.6,
    'Michigan International Speedway' => 1.0,
    'Charlotte Motor Speedway ROVAL' => 0.7
  }

  NASCAR_RACES = {
    'Daytona 500' => 'Daytona International Speedway',
    'Coke Zero Sugar 400' => 'Daytona International Speedway',
    'Folds of Honor QuikTrip 500' => 'Atlanta Motor Speedway',
    'Pennzoil 400' => 'Las Vegas Motor Speedway',
    'United Rentals Work United 500' => 'Phoenix Raceway',
    'Auto Club 400' => 'Auto Club Speedway',
    'Würth 400' => 'Richmond Raceway',
    'Food City Dirt Race' => 'Bristol Motor Speedway',
    'Coca-Cola 600' => 'Charlotte Motor Speedway',
    'Ally 400' => 'Nashville Superspeedway',
    'Buschy McBusch Race 400' => 'Kansas Speedway',
    'Cook Out Southern 500' => 'Darlington Raceway',
    'Go Bowling at The Glen' => 'Watkins Glen International',
    'Consumers Energy 400' => 'Michigan International Speedway',
    'Talladega 500' => 'Talladega Superspeedway',
    'Toyota/Save Mart 350' => 'Sonoma Raceway',
    'Pocono Organics CBD 325' => 'Pocono Raceway',
    'Brickyard 400 Presented by PPG' => 'Indianapolis Motor Speedway',
    'Bank of America Roval 400' => 'Charlotte Motor Speedway ROVAL',
    'Hollywood Casino 400' => 'Kansas Speedway',
    'Autotrader EchoPark Automotive 400' => 'Dover International Speedway',
    'Xfinity 500' => 'Martinsville Speedway',
    'GEICO 500' => 'Talladega Superspeedway',
    'NASCAR Cup Series Championship Race' => 'Phoenix Raceway',
    'Iowa Corn 350' => 'Iowa Speedway'
  }
  # name: string of race venue; used to lookup default differential_weight
  # differential_weight: optional override
  def initialize(drivers:, track_name: nil, race_name: nil, differential_weight: nil, field_size: 40)
    @drivers = drivers
    @field_size = field_size
    @track_name = track_name || NASCAR_RACES[race_name]
    @differential_weight = differential_weight || DIFFERENTIAL_WEIGHTS[track_name] || 1.0
    @salary_cap = 50_000
  end

  # Generates the optimal 6-driver prediction under the salary cap
  # by brute-force combination search, maximizing combined score
  def generate_prediction
    valid_lineups = generate_valid_lineups
    best_lineup = select_best_lineup(valid_lineups)
    best_score = calculate_lineup_score(best_lineup)
    Prediction.new(best_lineup, best_score)
  end

  private

  def generate_valid_lineups
    drivers.combination(6).reject { |combo| combo.sum(&:salary) > salary_cap }
  end

  def select_best_lineup(lineups)
    lineups.max_by { |combo| calculate_lineup_score(combo) } || []
  end

  def calculate_lineup_score(lineup)
    lineup.sum { |drv| drv.score(differential_weight: differential_weight, field_size: field_size) }
  end
end
