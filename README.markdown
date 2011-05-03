# Undertexter

## What is Undertexter?

*Undertexter* provides a basic API for [Undertexter.se](http://undertexter.se)

*Support for other subtitles sites will be added in the future. Follow this project to know when.*

Follow me on [Twitter](http://twitter.com/linusoleander) or [Github](https://github.com/oleander/) for more info and updates.

## How to use

### Find a subtitle

Pass an imdb id.
  
```` ruby  
subtite = Undertexter.find("tt0840361").first

subtitle.downloads
# => 8328
subtitle.movie_title
# => "The Town"
subtitle.title
# => "The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC"
subtitle.url
# => "http://www.undertexter.se/utext.php?id=23711"
subtitle.details
# => "http://www.undertexter.se/?p=undertext&id=23711"
````

Pass any string.

```` ruby
Undertexter.find("die hard").count
# => 41
````

### Specify a language

```` ruby    
Undertexter.find("tt0840361", :language => :english).count
# => 48

Undertexter.find("tt0840361", :language => :swedish).count
# => 8
````

### Download subtitle to disk

Download to `/tmp`.

```` ruby
Undertexter.find("tt0840361").first.download!
# => "/tmp/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar"

File.exists?("/tmp/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar")
# => true
````

Specify an absolut path.

```` ruby    
Undertexter.find("tt0840361").first.download!(:to => /some/dir)
# => "/some/dir/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar"
````

Specify a relative path.

```` ruby 
Dir.pwd
# => /Users/linus/Downloads
Undertexter.find("tt0840361").first.download!(:to => 'my_dir')
# => "/Users/linus/Downloads/my_dir/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar"
````

### Find subtitle based on a release name

```` ruby  
Undertexter.find("tt0840361").based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS")
````

### Sensitive

Specify how sensitive the `based_on` method should be, from `0.0` to `1.0`.

```` ruby
Undertexter.find("tt0840361").based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS", limit: 0.0)
# => nil
````

```` ruby 
Undertexter.find("tt0840361").based_on("The Town EXTENDED 2010 480p BRRip XviD AC3 FLAWL3SS", limit: 0.4)
# => #<SContainer::Subtitle:0x00000101b8d808 @cds=1, @downloads=1644, @title="The.Town.EXTENDED.2010.480p.BRRip.XviD.AC3-FLAWL3SS", @details="http://www.undertexter.se/?p=undertext&id=23752", @movie_title="The Town", @language=:swedish>
````

```` ruby
Undertexter.find("tt0840361").based_on("The.Town.EXTENDED.2010.480p.BRRip.XviD.AC3-FLAWL3SS", limit: 0.0)
# => #<SContainer::Subtitle:0x00000101b8d718 @cds=1, @downloads=1644, @title="The.Town.EXTENDED.2010.480p.BRRip.XviD.AC3-FLAWL3SS", @details="http://www.undertexter.se/?p=undertext&id=23752", @movie_title="The Town", @language=:swedish>
````

## What is being returned?

The `find` method returns an `Array` with zero or more `Container::Subtitle` instances with some basic accessors.

- `movie_title` (String) The official name of the movie.
- `cds` (Fixnum) The amount of cds that the release should contain.
- `title` (String) The release name of the subtitle, should have the same name as the downloaded movie.
- `downloads` (Fixnum) The amount of downloads for this particular subtitle.
- `url` (String) A direct link to the subtitle file, a rar file for example.
- `details` (String) A link to the details page for the subtitle.
- `download!` (String) The absolut path to the downloaded subtitle.

## Options to pass

### `find` method

Take a look at the *Specify a language* part for more info.

- **:language** (Symbol) The language of the subtitle. Default is `:swedish`, the other option is `:english`.

### `download!` method

Take a look at the *Download subtitle to disk* part for more info.

- **:to** (String) The absolut or relative path to where the downloaded file will be placed. Default is `/tmp`

### `based_on` method

Take a look at the *Find subtitle based on a release name* path for more info.

- **:limit** (Float) The sensitivity of the method, where `0.0` is a perfect match and `1.0` is don't care. If this is set to high the method will return nil. Default is `0.4`. Read more about the [levenshtein](http://en.wikipedia.org/wiki/Levenshtein_distance) algorithm that is being used [here](http://www.erikveen.dds.nl/levenshtein/doc/index.html).

## How to install

    [sudo] gem install undertexter
    
## How to use it in a rails 3 project

Add `gem 'undertexter'` to your Gemfile and run `bundle`.

## Requirements

*Undertexter* is tested in Mac OS X 10.6.6, 10.6.7 using Ruby 1.8.7, 1.9.2.

## License

*Undertexter* is released under the *MIT license*.