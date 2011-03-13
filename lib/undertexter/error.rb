class SourceHasBeenChangedError < StandardError
  def initialize(error, url)
    super <<-END_RUBY
      \nHi,
      
      It looks like an error has occurred.
      
      Please report it on the Github issue tracker (link below).
      https://github.com/oleander/Undertexter/issues
      
      Here is the error:
      
      \t #{error.message}
      \t #{error.backtrace.first}
      \t #{url}
      
      Thanks for using Undertexter!\n
    END_RUBY
  end
end