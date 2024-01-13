class Mangos::Package
  attr_reader :path, :options

  def initialize(path, options)
    raise "path must be an instance of Pathname" unless path.is_a?(Pathname)

    @path = DecoratedPathname.new(path)
    @options = options
  end

  def update
    app_path.mkdir unless File.exist?(app_path)
    thumbnails_path.mkpath unless File.exist?(thumbnails_path)

    Mangos::Update.new(self, Mangos::Processor.new(self)).update
  end

  def app_path
    @path + ".mangos/"
  end

  def data_path
    app_path + "data.json"
  end

  def key_mapping_path
    app_path + "key_mapping.json"
  end

  def thumbnails_path
    app_path + "img/thumbnails/"
  end

  def force?
    @options[:force]
  end

  def migrate?
    @options[:migrate]
  end
end
