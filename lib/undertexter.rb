require 'rest-client'
require 'subtitle'
require 'nokogiri'

class Undertexter
  attr_accessor :raw_data, :base_details, :subtitles
  
  def initialize
    @base_details = "http://www.undertexter.se/?p=soek&add=arkiv&str="
    @subtitles = []
  end
  
  def self.find(search_string)
    this = self.new
    
    # Downloading the page
    this.get(search_string)
    
    # If something went wrong, like a timeout, {raw_data} could be nil
    return [] if this.raw_data.nil?
    
    this.parse!
    
    this.build!
    
    return this.subtitles
  end
  
  def parse!
    noko = Nokogiri::HTML(@raw_data)
    
    # Example output
    # [["(1 cd)", "Nedladdningar: 11891", "Avatar (2009) PROPER DVDSCR XviD-MAXSPEED", "http://www.undertexter.se/?p=undertext&id=19751"]]
    
    [15,12].each do |id|
      @block = noko.css("table:nth-child(#{id}) td").to_a.reject do |inner| 
        inner.content.empty? or ! inner.content.match(/Nedladdningar/i) 
      end.map do |inner| 
        inner.content.split("\n").map do |i| 
          i.gsub(/"/, "").strip
        end
      end
      
      next if @block.nil?
      
      noko.css("table:nth-child(#{id}) a").to_a.reject do |inner| 
        details = inner.attr('href')
        inner.content.empty? or details.nil? or ! details.match(/p=undertext&id=\d+/i)
      end.map do |y| 
        [y.attr('href'), y.content.strip]
      end.each_with_index do |value, index|
        @block[index] << value.first
        @block[index] << value.last
      end
    
      @block.map!{|value| value.reject(&:empty?)}
      
      break if @block.any?
    end
  end
  
  def build!
    @block.each do |movie|
      next unless movie.count == 5
      @subtitles << Subtitle.new({
        :cds => movie[0].match(/\d+/)[0].to_i,
        :downloads => movie[1].match(/\d+$/)[0].to_i,
        :title => movie[2],
        :details => movie[3],
        :movie_title => movie[4]
      })
    end
  end
  
  def get(search_string)
    @raw_data = RestClient.get(@base_details + CGI.escape(search_string), :timeout => 10) rescue nil
  end
end