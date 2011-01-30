What is Undertexter?
===============

Undertexter provides a basic search client that makes it possible to search for swedish and english subtitles on [Undertexter.se](http://undertexter.se)

How to use
===============

The find methods takes any string, including an IMDB id.
This is how to use it in irb.

    $ require 'undertexter'
    # => true
    $ subtite = Undertexter.find("tt0840361").first
    => #<Subtitle:0x1020fff98 @downloads=8328, @movie_title="The Town", @title="The.Town.2010....BRRip", @url="http://www.undertexter.se/?p=undertext&id=23711", @cds=1>
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

You can also provide an language option.
    
    $ Undertexter.find("tt0840361", :language => :english).count
    => 48
    $ Undertexter.find("tt0840361", :language => :swedish).count
    => 8

Download the subtitle to disk

    $ Undertexter.find("tt0840361").first.download!
    => "/tmp/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar"
    $ File.exists?("/tmp/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar")
    => true
    
You can also specify a destination folder to download the file, both relative and absolute
    
    $ Undertexter.find("tt0840361").first.download!(:to => /some/dir)
    => "/some/dir/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar"
    
    $ Dir.pwd
    => /Users/linus/Downloads
    $ Undertexter.find("tt0840361").first.download!(:to => 'my_dir')
    => "/Users/linus/Downloads/my_dir/The.Town.2010.EXTENDED.480p.BRRip.XviD-NYDIC.rar"
    
If no language option is being passed to find, it will fall back to swedish

What is being returned from the find method?
===============

The find method returns an `Array` with zero or more subtitles. Every subtitle provides some basic accessors.

- `movie_title` (String) The official name of the movie.
- `cds` (Integer) The amount of cds that the release should contain.
- `title` (String) The release name of the subtitle, should have the same name as the downloaded movie.
- `downloads` (Integer) The amount of downloads for this particular subtitle.
- `url` (String) A direct link to the subtitle file, a rar file for example
- `details` (String) A link to the details page for the subtitle

How to install
===============

    sudo gem install undertexter
    
How to use it in a rails 3 project
===============

Add `gem 'undertexter'` to your Gemfile and run `bundle`.

How to help
===============

- Start by copying the project or make your own branch.
- Navigate to the root path of the project and run `bundle`.
- Start by running all tests using rspec, `rspec spec/undertexter_spec.rb`.
- Implement your own code, write some tests, commit and do a pull request.

Requirements
===============

Undertexter is tested in OS X 10.6.6 using Ruby 1.8.7.