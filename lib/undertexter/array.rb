require 'levenshteinish'

class Array
  def based_on(string, args = {})    
    self.any? ? self.map do|s|
      [Levenshtein.distance(s.title, string, args[:limit] || 0.4), s]
    end.reject do |value| 
      value.first.nil?
    end.sort_by do |value|
      value.first
    end.map(&:last).first : nil
  end
end