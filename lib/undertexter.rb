# encoding: UTF-8

require "rest-client"
require "subtitle"
require "nokogiri"
require "iconv"
require "undertexter/error"
require "undertexter/array"

class Undertexter
  attr_accessor :raw_data, :base_details, :subtitles, :search_string
  
  def initialize(options)
    @options = {
      :language => {
        :swedish => "soek",
        :english => "eng_search"
      },
      :preferred_language => options[:language]
    }
    
    # If a non existing language is being used, swedish will be the default
    lang = @options[:language][options[:language]] || @options[:language][:swedish]
    
    @base_details = "http://www.undertexter.se/?p=#{lang}&add=arkiv&str="
    @subtitles = []
  end
  
  def self.find(search_string, options = {:language => :swedish})
    this = self.new(options)
    this.search_string = search_string
    
    # Downloading the page
    this.get!
    
    # If something went wrong, like a timeout, {raw_data} could be nil
    return [] if this.raw_data.nil?
    
    this.parse!
    
    this.build!
    
    return this.subtitles
  end
  
  def parse!
    # Example output
    # [["(1 cd)", "Nedladdningar: 11891", "Avatar (2009) PROPER DVDSCR XviD-MAXSPEED", "http://www.undertexter.se/?p=undertext&id=19751", "Avatar"]]
    
    doc = Nokogiri::HTML(@raw_data)
    @block = []
    
    tbody = doc.css("table").to_a.reject do |i| 
      ! i.content.match(/Nedladdningar/i) or i.css("table").any?
    end.sort_by do |inner| 
      inner.css("table").count 
    end.first
    
    return if tbody.nil?
    
    tbody = tbody.css("tr").select do |tr|
      tr.to_s.match(/http:\/\/www\.undertexter\.se\/\d+\//) or tr.to_s.match(/Nedladdningar/i)
    end.each_slice(2) do |first, last|
      length = @block.length
      @block[length] = [] if @block[length].nil?
      line = last.content.split(/\n/).map(&:strip)
      value = first.at_css("a")
      @block[length] << line[1]             # (cd 1)
      @block[length] << line[3]             # Nedladdningar: 11891
      @block[length] << line[4]             # "Avatar (2009) PROPER DVDSCR XviD-MAXSPEED"
      @block[length] << value.attr("href")  # http://www.undertexter.se/20534/
      @block[length] << value.attr("title") # Avatar
      @block[length].map!(&:strip)
    end
  rescue StandardError => error
    raise SourceHasBeenChangedError.new(error, url)
  end
  
  def build!
    @block.each do |movie|
      next unless movie.count == 5
      @subtitles << SContainer::Subtitle.new({
        :cds         => movie[0].match(/\d+/)[0].to_i,
        :downloads   => movie[1].match(/\d+/)[0].to_i,
        :title       => movie[2],
        :details     => movie[3],
        :movie_title => movie[4],
        :language    => @options[:preferred_language]
      })
    end
  end
  
  def get!
    @raw_data = RestClient.get(url, :timeout => 10) rescue nil
    @raw_data = Iconv.conv("utf-8","ISO-8859-1", @raw_data)
  end
  
  def url
    @base_details + CGI.escape(search_string)
  end
end