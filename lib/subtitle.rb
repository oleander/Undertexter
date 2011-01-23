class Subtitle
  attr_accessor :details, :downloads, :cds, :title, :movie_title
  def initialize(args)
    args.keys.each { |name| instance_variable_set "@" + name.to_s, args[name] }
  end
end