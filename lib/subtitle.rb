class Subtitle
  attr_accessor :details, :downloads, :cds, :title, :movie_title, :url
  
  def initialize(args)
    args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
  end
  
  def url
    "http://www.undertexter.se/utext.php?id=#{id}"
  end
  
  private
    def id
      @details.match(/id=(\d+)/)[1]
    end
end