require 'spec_helper'

describe Array do
  before(:each) do
    @subtitles = Undertexter.find("tt0840361")
  end
  
  it "should have a based_on method" do
    lambda{
      @subtitles.based_on("some args")
    }.should_not raise_error(NoMethodError)
  end
  
  it "should return the right one" do
    @subtitles.based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS").details.should match(/id=23752/)
  end
  
  it "should not return anything if the limit is set to low" do
    @subtitles.based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS", :limit => 0).should be_nil
  end
  
  it "should not return the right movie if to litle info i passed" do
    @subtitles.based_on("The Town").should be_nil
  end
  
  it "should return the right instance" do
    @subtitles.based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS").should be_instance_of(Subtitle)
  end
  
  it "should return nil if trying to fetch an non existing imdb id" do
    Undertexter.find("tt123456789").based_on("some random argument").should be_nil
  end
  
  it "should raise an exception when the array does not contain any subtitle objects" do
    lambda {
      [1,2,2,3].based_on("some args")
    }.should raise_error(NoMethodError)
  end
  
  it "should be an array" do
    @subtitles.should be_an_instance_of(Array)
  end
end