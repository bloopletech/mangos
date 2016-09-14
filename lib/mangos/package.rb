class Mangos::Package
  attr_reader :path
  attr_reader :app_path

  def initialize(path)
    raise "path must be an instance of Pathname" unless path.is_a?(Pathname)

    @path = path
    @app_path = path + ".mangos/"
  end

  def pathname_to_url(path, relative_from)
    URI.escape(path.relative_path_from(relative_from).to_s)
  end

  def update
    app_path.mkdir unless File.exists?(app_path)
    Mangos::Update.new(self, Mangos::Processor.new(self)).update
  end

  def data_path
    @app_path + "data.json"
  end
end
