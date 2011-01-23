require 'spec_helper'

describe Undertexter do
  before(:all) do
    @use = Undertexter.find("tt0499549")
  end
  
  it "should return return at least 31 subtitles" do
    Undertexter.should have_at_least(31).find("tt0499549")
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
  
  it "should contain titles that does not have whitespace in the end of beginning" do
    @use.each {|subtitle| subtitle.title.should_not match(/^\s+.+\s+$/)}
  end
  
  it "should contain titles that isn't blank" do
    @use.each {|subtitle| subtitle.title.should_not be_empty}
  end
  
  it "should contain the right detailss" do
    @use.each {|subtitle| subtitle.details.should match(/^http:\/\/www\.undertexter\.se\/\?p=undertext&id=\d+$/)}
  end
end


describe Undertexter, "trying to find a non existing movie" do
  it "should not return any subtitles" do
    Undertexter.find("some random name").count.should be(0)
  end
end

describe Undertexter, "trying to search for a movie using a title" do
  before(:all) do
    @use = Undertexter.find("die hard")
  end
  
  it "should return some subtitles" do
    Undertexter.should have_at_least(36).find("avatar")
  end
  
  it "should return some subtitles when searching for a movie with whitespace" do
    Undertexter.should have_at_least(41).find("die hard")
  end
  
  it "should return the right title, again" do
    @use.each{|subtitle| subtitle.title.should match(/die.*hard/i)}
  end
  
  it "should contain the right detailss, again" do
    @use.each {|subtitle| subtitle.details.should match(/^http:\/\/www\.undertexter\.se\/\?p=undertext&id=\d+$/i)}
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
end