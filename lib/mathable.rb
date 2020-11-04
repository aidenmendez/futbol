module Mathable

  def calc_percentage(numerator, denominator)
    (numerator.to_f / denominator).round(2)
  end

  def average(numerator, denominator) 
    return (numerator.to_f / denominator.count).round(2) if denominator.class == Array
    (numerator.to_f / denominator).round(2)
  end

end