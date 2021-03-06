class Mangos::Package
  attr_reader :path, :options

  def initialize(path, options)
    raise "path must be an instance of Pathname" unless path.is_a?(Pathname)

    @path = DecoratedPathname.new(path)
    @options = options
  end

  def update
    app_path.mkdir unless File.exists?(app_path)
    thumbnails_path.mkpath unless File.exists?(thumbnails_path)

    Mangos::Update.new(self, Mangos::Processor.new(self)).update
  end

  def app_path
    @path + ".mangos/"
  end

  def data_path
    app_path + "data.json"
  end

  def thumbnails_path
    app_path + "img/thumbnails/"
  end

  def force?
    @options[:force]
  end
end
