# Undertexter
## What is Undertexter?

Undertexter provides a basic search client that makes it possible to search for swedish and english subtitles on [Undertexter.se](http://undertexter.se)

*Support for other subtitles sites will be added in the future. Follow this project to know when.*

## How to use

### Find a subtitle based on any string

The find methods takes any string, including an IMDB id.
This is how to use it in `irb`.

    $ require 'undertexter'
    # => true
    
    $ subtite = Undertexter.find("tt0840361").first
    => #<Container::Subtitle:0x1020fff98 @downloads=8328, @movie_title="The Town", @title="The.Town.2010....BRRip", @url="http://www.undertexter.se/?p=undertext&id=23711", @cds=1>
    $ subtitle.downloads
    => 8328
    $ subtitle.movie_title
    => "The Town"
    $ subtitle.title
    => "The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC"
    $ subtitle.url
    = "http://www.undertexter.se/utext.php?id=23711"
    $ subtitle.details
    => "http://www.undertexter.se/?p=undertext&id=23711"
    
    $ Undertexter.find("die hard").count
    => 41

### Find a subtitle with in centrain language
    
    $ Undertexter.find("tt0840361", :language => :english).count
    => 48
    $ Undertexter.find("tt0840361", :language => :swedish).count
    => 8

### Download the subtitle to disk

    $ Undertexter.find("tt0840361").first.download!
    => "/tmp/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar"
    $ File.exists?("/tmp/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar")
    => true
    
### Download the subtitle to a specified destination folder, both relative and absolute
    
    $ Undertexter.find("tt0840361").first.download!(:to => /some/dir)
    => "/some/dir/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar"
    
    $ Dir.pwd
    => /Users/linus/Downloads
    $ Undertexter.find("tt0840361").first.download!(:to => 'my_dir')
    => "/Users/linus/Downloads/my_dir/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar"
    
### Find the right subtitle based on the **release name** of the movie
    
    $ Undertexter.find("tt0840361").based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS")
    => #<Container::Subtitle:0x00000101b739d0 @cds=1, @downloads=1644, @title="The.Town.EXTENDED.2010.480p.BRRip.XviD.AC3-FLAWL3SS", @details="http://www.undertexter.se/?p=undertext&id=23752", @movie_title="The Town", @language=:swedish>
    
### Specify how sensitive the `based_on` method should be, from `0.0` to `1.0`
    
    $ Undertexter.find("tt0840361").based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS", limit: 0.0)
    => nil
    
    $ Undertexter.find("tt0840361").based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS", limit: 0.4)
    => #<Container::Subtitle:0x00000101b8d808 @cds=1, @downloads=1644, @title="The.Town.EXTENDED.2010.480p.BRRip.XviD.AC3-FLAWL3SS", @details="http://www.undertexter.se/?p=undertext&id=23752", @movie_title="The Town", @language=:swedish>
    
    $ Undertexter.find("tt0840361").based_on("The.Town.EXTENDED.2010.480p.BRRip.XviD.AC3-FLAWL3SS", limit: 0.0)
    => #<Container::Subtitle:0x00000101b8d718 @cds=1, @downloads=1644, @title="The.Town.EXTENDED.2010.480p.BRRip.XviD.AC3-FLAWL3SS", @details="http://www.undertexter.se/?p=undertext&id=23752", @movie_title="The Town", @language=:swedish>

## What is being returned?

The find method returns an `Array` with zero or more `Container::Subtitle` instances. Every object provides some basic accessors.

- `movie_title` (String) The official name of the movie.
- `cds` (Integer) The amount of cds that the release should contain.
- `title` (String) The release name of the subtitle, should have the same name as the downloaded movie.
- `downloads` (Integer) The amount of downloads for this particular subtitle.
- `url` (String) A direct link to the subtitle file, a rar file for example
- `details` (String) A link to the details page for the subtitle
- `download!` (String) The absolut path to the downloaded subtitle

## Some optional options 

### The `find` method

- **:language** (Symbol) The language of the subtitle. Default is `:swedish`, the other option is `:english`.

### The `download!` method on the subtitle object

- **:to** (String) The absolut or relative path to where the downloaded file will be placed. Default is `/tmp`

### The `based_on` method on any array that is being returned from `Undertexter`

- **:limit** (Float) The sensitivity of the method, where `0.0` is a perfect match and `1.0` is don't care. If this is set to high the method will return nil. Default is `0.4`. Read more about the [levenshtein](http://en.wikipedia.org/wiki/Levenshtein_distance) algorithm that is being used [here](http://www.erikveen.dds.nl/levenshtein/doc/index.html).

## How to install

    [sudo] gem install undertexter
    
## How to use it in a rails 3 project

Add `gem 'undertexter'` to your Gemfile and run `bundle`.

## How to help

- Start by copying the project or make your own branch.
- Navigate to the root path of the project and run `bundle`.
- Start by running all tests using rspec, `rspec spec/undertexter_spec.rb`.
- Implement your own code, write some tests, commit and do a pull request.

## Requirements

Undertexter is tested on OS X 10.6.6 using Ruby 1.8.7 and 1.9.2.