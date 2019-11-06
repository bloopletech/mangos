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
    @book.page_paths = build_page_paths(page_paths)
    @book.pages = page_paths.length
    @book.path = @path.basename.to_s
    @book.published_on = @path.mtime.to_i
    @book.tags = Mangos::TagBreaker.new(@book.path).tags

    Mangos::Thumbnailer.new(page_paths.first, thumbnail_path).generate
  end

  def find_page_paths
    image_paths = @path.children.select { |p| p.image? && !p.hidden? }
    Naturalsorter::Sorter.sort(image_paths.map(&:to_s), true).map { |p| DecoratedPathname.new(p) }
  end

  def build_page_paths(page_paths)
    Mangos::PagesDeflater.new(page_paths.map { |p| p.basename.to_s }).deflate
  end

  def thumbnail_path
    @package.thumbnails_path + "#{@book.key}.jpg"
  end
end