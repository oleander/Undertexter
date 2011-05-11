require 'spec_helper'

describe Undertexter do
  use_vcr_cassette "tt0499549"
  
  before(:each) do
    @use = Undertexter.find("tt0499549")
  end
  
  it "should return return at least 31 subtitles" do
    Undertexter.find("tt0499549").count.should >= 31
  end
  
  it "should contain cds that is of the type Fixnum" do
    @use.each {|subtitle| subtitle.cds.class.should eq(Fixnum)}
  end
  
  it "should not contain cds with the value zero" do
    @use.each {|subtitle| subtitle.cds.should_not be(0)}
  end
  
  it "should not contain some amount of downloads" do
    @use.each {|subtitle| subtitle.downloads.class.should be(Fixnum)}
  end
  
  it "should contain some downloads" do
    @use.reject {|subtitle| subtitle.downloads <= 0}.count.should_not be(0)
  end
  
  it "should not be empty" do
    @use.should_not be_empty
  end
  
  it "should contain titles that does not have whitespace in the end of beginning" do
    @use.each {|subtitle| subtitle.title.should_not match(/^\s+.+\s+$/)}
  end
  
  it "should contain titles that isn't blank" do
    @use.each {|subtitle| subtitle.title.should_not be_empty}
  end
  
  it "should contain the right details" do
    @use.each {|subtitle| subtitle.details.should match(/^http:\/\/www\.undertexter\.se\/\d+\/$/)}
  end
end


describe Undertexter, "trying to find a non existing movie" do
  use_vcr_cassette "non-existing"
  
  it "should not return any subtitles" do
    Undertexter.find("some random name").count.should be(0)
  end
end

describe Undertexter, "trying to search for a movie using a title" do
  use_vcr_cassette "die-hard"
  
  before(:each) do
    @use = Undertexter.find("die hard")
  end
  
  it "should return some subtitles when searching for a movie with whitespace" do
    @use.count.should >= 41
  end
  
  it "should have 6 die hard movies that does not contain any title" do
    @use.reject{|subtitle| ! subtitle.title.empty?}.count.should be(6)
  end
  
  it "should contain the right details, again" do
    @use.each {|subtitle| subtitle.details.should match(/^http:\/\/www\.undertexter\.se\/\d+\/$/)}
  end
  
  it "should have a movie title" do
    @use.each {|subtitle| subtitle.movie_title.should match(/die hard/i)}
  end
  
  it "should have a movie title that is not equal to the subtitle" do
    @use.each {|subtitle| subtitle.movie_title.should_not eq(subtitle.title)}
  end
  
  it "should not contain movie title that starts or ends with whitespace" do
    @use.each {|subtitle| subtitle.movie_title.should_not match(/^\s+.+\s+$/)}
  end
  
  it "should return the same id for every link" do
    @use.each_with_index do |subtitle, index|
      subtitle.url.match(/id=(\d+)$/)[1].should 
        eq(@use[index].details.match(/^http:\/\/www\.undertexter\.se\/(\d+)\/$/)[1])
    end
  end
  
  it "should only contain SContainer::Subtitle instances" do
    @use.each { |subtitle| subtitle.should be_instance_of(SContainer::Subtitle) }
  end
  
  it "should not contain any attributes that contain any html tags" do
    @use.each do |subtitle|
      [:details, :downloads, :cds, :title, :movie_title, :url].each do |method|
        subtitle.send(method).to_s.should_not match(/<\/?[^>]*>/)
      end
    end
  end
end

describe "deactivated" do
  it "should raise an error if trying to fetch an english subtitle" do
    lambda { 
      Undertexter.find("tt0840361", :language => :english)  
    }.should raise_error(ArgumentError, "Support for english subtitles are deactivated - for now.")
  end
end

describe Undertexter, "should work when trying to fetch some english subtitles" do
  use_vcr_cassette "tt0840361"
  
  # Deactivated - for now - 2011-05-11
  # 
  # it "should return at least 48 subtitles" do
  #   Undertexter.should have_at_least(48).find("tt0840361", :language => :english)
  # end
  # it "should return the right url when trying to fetch an english sub" do
  #   Undertexter.find("tt0840361", :language => :english).first.url.should match(/http:\/\/eng\.undertexter\.se\/subtitle\.php\?id=\d+/i)
  # end
  
  it "should return at least 8 subtitles" do
    Undertexter.should have_at_least(8).find("tt0840361", :language => :strange)
  end
  
  it "should return at least 8 subtitles" do
    Undertexter.should have_at_least(8).find("tt0840361", :language => :swedish)
  end
  
  it "should return the right url when trying to fetch an swedish sub" do
    Undertexter.find("tt0840361", :language => :swedish).first.url.should match(/http:\/\/undertexter\.se\/laddatext\.php\?id=\d+/i)
  end
end

describe "errors" do
  before(:all) do
    WebMock.disable_net_connect!
  end
  
  it "should raise an error if the markup is changed" do
    stub_request(:get, "http://www.undertexter.se/?p=soek&add=arkiv&str=tt0499549").to_return(:body => File.read("spec/fixtures/error.html"), :status => 200)
    lambda { Undertexter.find("tt0499549") }.should raise_error(SourceHasBeenChangedError)
  end
  
  after(:all) do
    WebMock.allow_net_connect!
  end
end