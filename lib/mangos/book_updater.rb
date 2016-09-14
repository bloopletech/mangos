class Mangos::BookUpdater
  attr_reader :package, :book

  def initialize(package, book, path)
    @package = package
    @book = book
    @path = path
  end

  def update
    page_paths = find_page_paths

    @book.key = Digest::SHA256.hexdigest(@path.to_s)[0..16]
    @book.url = @package.pathname_to_url(@path, @package.app_path)
    @book.page_urls = build_page_urls(page_paths)
    @book.pages = page_paths.length
    @book.title = @path.basename.to_s
    @book.published_on = @path.mtime.to_i
    @book.thumbnail_url = thumbnail_url

    generate_thumbnail(page_paths.first)
  end

  def find_page_paths
    image_paths = @path.children.select { |p| p.image? && !p.hidden? }
    Naturalsorter::Sorter.sort(image_paths, true)
  end

  def build_page_urls(page_paths)
    page_urls = page_paths.map { |p| @package.pathname_to_url(p, @path) }
    Mangos::PagesDeflater.new(page_urls).deflate
  end

  def thumbnail_path
    @package.app_path + "img/thumbnails/" + "#{@book.key}.jpg"
  end

  def thumbnail_url
    @package.pathname_to_url(thumbnail_path, @package.app_path)
  end

  #PREVIEW_WIDTH = 211
  #PREVIEW_HEIGHT = 332
  PREVIEW_WIDTH = 197
  PREVIEW_HEIGHT = 310

  PREVIEW_SMALL_WIDTH = 98
  PREVIEW_SMALL_HEIGHT = 154

  def generate_thumbnail(image_path)
    return if thumbnail_path.exist?
    return if image_path.nil? || image_path.to_s == ''

    img = Magick::Image.read(image_path).first

    p_width = PREVIEW_WIDTH
    p_height = PREVIEW_HEIGHT

    if (img.columns > img.rows) && img.columns > p_width && img.rows > p_height #if it's landscape-oriented
      img.crop!(Magick::EastGravity, img.rows / (p_height / p_width.to_f), img.rows) #Resize it so the right-most part of the image is shown
    end

    img.change_geometry!("#{p_width}>") { |cols, rows, _img| _img.resize!(cols, rows) }

    img.page = Magick::Rectangle.new(img.columns, img.rows, 0, 0)
    img = img.extent(p_width, p_height, 0, 0)
    img.excerpt!(0, 0, p_width, p_height)

    img.write(thumbnail_path)
  rescue Exception => e
    puts "There was an error generating thumbnail: #{e.inspect}"
  end
end