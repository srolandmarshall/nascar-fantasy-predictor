# prediction.rb

class Prediction
  attr_reader :lineup, :total_score, :total_salary

  def initialize(lineup, total_score)
    @lineup = lineup
    @total_score = total_score
    @total_salary = lineup.sum(&:salary)
  end

  def to_s
    result = "Prediction (Total Salary: $#{total_salary}, Combined Score: #{'%.2f' % total_score})\n"
    lineup.each do |drv|
      result += format("%s - Start: P%s, Salary: $%d, Avg PPG: %.2f, Score: %.2f\n", drv.name, drv.start_pos,
                       drv.salary, drv.avg_points_per_game, drv.score)
    end
    result
  end
end
