require 'levenshteinish'

class Array
  def based_on(string, args = {})    
    result = self.any? ? self.map do|s|
      [Levenshtein.distance(s.title, string, args[:limit] || 0.4), s]
    end.reject do |value| 
      value.first.nil?
    end.sort_by do |value|
      value.first
    end.map(&:last).first : nil
    
    return if result.nil?
    
    # If the string contains a release date, then the results should do it to
    if result.title =~ /(s\d{2}e\d{2})/i
      return unless string.match(/#{$1}/i)
    end
    
    # If the {string} contains a year, then the found movie should return one to
    if result.title =~ /((19|20)\d{2})/
      return unless string.match(/#{$1}/)
    end
    
    # Yes i know, return isn't needed
    return result
  end
end