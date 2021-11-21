class Mangos::BookUpdater
  attr_reader :package, :book

  def initialize(package, book, path)
    @package = package
    @book = book
    @path = path
  end

  def update
    page_paths = find_page_paths

    @book.old_key = @book.key
    @book.key = Digest::SHA256.hexdigest(@path.basename.to_s)[0..16]
    @book.page_paths = build_page_paths(page_paths)
    @book.pages = page_paths.length
    @book.path = @path.basename.to_s
    @book.published_on = @path.mtime.to_i
    @book.tags = Mangos::TagBreaker.new(@book.path).tags

    fix_thumbnail_path if @package.migrate?
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

  def fix_thumbnail_path
    old_thumbnail_path = @package.thumbnails_path + "#{@book.old_key}.jpg"
    if old_thumbnail_path.exist? && !thumbnail_path.exist?
      old_thumbnail_path.rename(thumbnail_path)
    end
  end
end