# encoding: UTF-8

require 'rest-client'
require 'subtitle'
require 'hpricot'
require 'iconv'
require 'undertexter/array'

module Hpricot

  # Monkeypatch to fix an Hpricot bug that causes HTML entities to be decoded
  # incorrectly.
  def self.uxs(str)
    str.to_s.
      gsub(/&(\w+);/) { [Hpricot::NamedCharacters[$1] || ??].pack("U*") }.
      gsub(/\&\#(\d+);/) { [$1.to_i].pack("U*") }
  end

end

class Undertexter
  attr_accessor :raw_data, :base_details, :subtitles
  
  def initialize(options)
    @options = {
      :language => {
        :swedish => 'soek',
        :english => 'eng_search'
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
    
    # Downloading the page
    this.get(search_string)
    
    # If something went wrong, like a timeout, {raw_data} could be nil
    return [] if this.raw_data.nil?
    
    this.parse!
    
    this.build!
    
    return this.subtitles
  end
  
  def parse!
    # Example output
    # [["(1 cd)", "Nedladdningar: 11891", "Avatar (2009) PROPER DVDSCR XviD-MAXSPEED", "http://www.undertexter.se/?p=undertext&id=19751", "Avatar"]]
    
    doc = Hpricot(@raw_data)
    @block = []
    
    # Trying to find the {tbody} that does not contain any tbody's
    tbody = doc.search("tbody").to_a.reject do |inner, index|
      not inner.inner_html.match(/Nedladdningar/i)
    end.sort_by do |inner| 
      inner.search('tbody').count 
    end.first
    
    # Nothing found, okey!
    return if tbody.nil?
    
    tbody = tbody.search('tr').drop(3)
    
    tbody.each_with_index do |value, index|
      next unless index % 3 == 0
      length = @block.length
      @block[length] = [] if @block[length].nil?

      line = tbody[index + 1].inner_html.split('<br />').map(&:strip)
      value = value.search('a')

      @block[length] << line[0]
      @block[length] << line[2]
      @block[length] << line[4]
      @block[length] << value.last.attributes['href']
      @block[length] << value.last.attributes['title']

      @block[length].map! {|i| i.gsub(/<\/?[^>]*>/, "").strip}
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
        :movie_title => movie[4],
        :language => @options[:preferred_language]
      })
    end
  end
  
  def get(search_string)
    @raw_data = RestClient.get(@base_details + CGI.escape(search_string), :timeout => 10) rescue nil
    @raw_data = Iconv.conv('utf-8','ISO-8859-1', @raw_data)
  end
end