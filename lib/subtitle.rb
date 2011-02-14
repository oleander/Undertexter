require 'fileutils'
require 'mimer_plus'

module Container
  class Subtitle
    attr_accessor :details, :downloads, :cds, :title, :movie_title, :url
  
    def initialize(args)
      args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
    end
  
    def url
      @language == :english ? "http://eng.undertexter.se/subtitle.php?id=#{id}" : "http://undertexter.se/laddatext.php?id=#{id}"
    end
  
    # Downloading the file and saves it disk
    def download!(args = {})
      if args[:to].nil?
        dir = "/tmp"
        file_name = "#{dir}/#{generate_file_name}"
      else
        dir = generate_custom_file_path(args)
        file_name = "#{dir}/#{generate_file_name}"
      end
    
      data = RestClient.get(self.url, :timeout => 10) rescue nil
      file = File.new(file_name, 'w')
      file.write(data)
      file.close
    
      type = Mimer.identify(file_name)
    
      if type.zip?
        file_ending = ".zip"
      elsif type.rar?
        file_ending = ".rar"
      else
        file_ending = ""
      end
    
      new_file_name = "#{dir}/#{title.gsub(/\s+/, '.')}#{file_ending}"
    
      # Changing the name on the file
      FileUtils.mv(file_name, new_file_name)
    
      # I like return :)
      return new_file_name
    end
  
    private
      def id
        @details.match(/id=(\d+)/)[1]
      end
    
      def generate_file_name
        (0...30).map{65.+(rand(25)).chr}.join.downcase
      end
    
      def generate_custom_file_path(args)
        # If the path is relative
        args[:to] = File.expand_path(args[:to]) unless args[:to].match(/^\//)

        # Makes sure that every directory structure looks the same
        Dir.new(args[:to]).path
      end
  end
end