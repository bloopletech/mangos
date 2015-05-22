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

  #FIXME: Doesn't work!
  def url_to_pathname(url)
    path = Addressable::URI.unencode_component(url.normalized_path)
    path.gsub!(/^\//, "") #Make relative, if we allow mounting at a different root URL this will need to remove the root instead of just '/'
    root_url_path + path
  end

  def update
    app_path.mkdir unless File.exists?(app_path)
    update_app
    Mangos::Update.new(self)
  end

  def update_app
    dev = ENV["MANGOS_ENV"] == "development"

    app_children_paths.each do |file|
      mangos_file = app_path + file.basename
      FileUtils.rm_rf(mangos_file, :verbose => dev)
    end

    if dev
      app_children_paths.each do |file|
        mangos_file = app_path + file.basename
        FileUtils.ln_sf(file, mangos_file, :verbose => dev)
      end
    else
      FileUtils.cp_r(Mangos::Package.gem_path + "app/.", app_path, :verbose => dev)
    end

    FileUtils.chmod_R(0755, app_path, :verbose => dev)
  end

  def self.gem_path
    Pathname.new(__FILE__).dirname.parent.parent
  end

  def self.load_json(path)
    if File.exists?(path)
      JSON.parse(File.read(path))
    else
      nil
    end
  end

  def self.save_json(path, data)
    File.open(path, "w") { |f| f << data.to_json }
  end

  private
  def app_children_paths
    app_path = Mangos::Package.gem_path + "app/"
    app_path.children.reject { |f| f.basename.to_s == "img" } #TODO: Deal with this directory properly
  end
end