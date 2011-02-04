require 'spec_helper'
describe Subtitle do
  before(:each) do
    @title = "127 Hours 2010 DVDSCR XViD-MC8"
    @new_file = "/tmp/#{@title.gsub(/\s+/, '.')}.zip"
    
    @subtitle = Subtitle.new({
      :details => "http://www.undertexter.se/?p=undertext&id=23984",
      :downloads => 100,
      :cds => 1,
      :title => @title,
      :movie_title => "127 Hours (127 Timmar)",
      :language => :swedish
    })
  end
  
  it "should be an instance of subtitle" do
    @subtitle.should be_instance_of(Subtitle)
  end
  
  it "should have the right accessors" do
    @subtitle.details.should eq("http://www.undertexter.se/?p=undertext&id=23984")
    @subtitle.downloads.should eq(100)
    @subtitle.cds.should eq(1)
    @subtitle.title.should eq("127 Hours 2010 DVDSCR XViD-MC8")
    @subtitle.movie_title.should eq("127 Hours (127 Timmar)")
    @subtitle.url.should eq("http://undertexter.se/laddatext.php?id=23984")
  end
  
  it "should be able to download the subtitle" do
    @subtitle.download!.should eq(@new_file)
  end
  
  it "should have created an existing file" do
    FileUtils.rm(@new_file)
    @subtitle.download!
    File.exists?(@new_file).should be_true
  end
  
  it "should be able to download the file to a specific absolute directory" do
    %x{rm -r /tmp/new_dir; mkdir /tmp/new_dir}
    @subtitle.download!(:to => '/tmp/new_dir')
    %x{ls /tmp/new_dir}.should_not be_empty
  end
  
  it "should be able to download the file to a specific relative directory" do
    folder = "#{Dir.pwd}/spec/data"
    
    @subtitle.download!(:to => 'spec/data')
    
    %x{ls #{folder}}.should_not be_empty
    
    %x{cd #{folder} && rm 127.Hours.2010.DVDSCR.XViD-MC8.zip}
  end
end