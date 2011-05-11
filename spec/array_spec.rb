require 'spec_helper'

describe Array do
  use_vcr_cassette "tt0840361"
  
  before(:each) do
    @subtitles = Undertexter.find("tt0840361")
  end
  
  it "should have a based_on method" do
    lambda{
      @subtitles.based_on("some args")
    }.should_not raise_error(NoMethodError)
  end
  
  it "should return the right one" do
    @subtitles.based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS").details.should match(/23752/)
  end
  
  it "should not return anything if the limit is set to low" do
    @subtitles.based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS", :limit => 0).should be_nil
  end
  
  it "should not return the right movie if to litle info i passed" do
    @subtitles.based_on("The Town").should be_nil
  end
  
  it "should return the right instance" do
    @subtitles.based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS").should be_instance_of(SContainer::Subtitle)
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
  
  it "should return nil due to the release date {S09E12}" do
    Undertexter.find("tt0313043").based_on("CSI.Miami.S09E12.HDTV.XviD-LOL").should be_nil
  end
  
  it "should not return anything due to the wrong year" do
    @subtitles.based_on("The Town EXTENDED 1999 480p BRRip XviD AC3 FLAWL3SS").should be_nil
  end
end