# run.rb

require_relative 'lib/driver'
require_relative 'lib/race'
require_relative 'lib/prediction'

require 'csv'

# Load drivers from CSV file
def import_drivers
  @drivers = []
  CSV.foreach('/Users/smarshall/Development/nascar-fantasy/data/iowa-corn.csv', headers: true) do |row|
    @drivers << Driver.new(
      name: row['Name'],
      salary: row['Salary'].to_i,
      avg_points_per_game: row['AvgPointsPerGame'].to_f,
      start_pos: row['StartPos'].to_i
    )
  end
  @drivers
end

def race
  @race ||= Race.new(drivers: import_drivers, track_name: 'Iowa Speedway')
end

def run!
  race.generate_prediction.tap do |prediction|
    puts prediction
  end
end

run!
