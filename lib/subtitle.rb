class Subtitle
  attr_accessor :details, :downloads, :cds, :title, :movie_title, :url
  
  def initialize(args)
    args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
  end
  
  def url
    @language == :english ? "http://eng.undertexter.se/subtitle.php?id=#{id}" : "http://www.undertexter.se/utext.php?id=#{id}"
  end
  
  private
    def id
      @details.match(/id=(\d+)/)[1]
    end
end