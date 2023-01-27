class Mangos::Processor
  def initialize(package)
    @package = package
    @original_mtime = @package.data_path.exist? ? @package.data_path.mtime : 0
  end

  def create(path)
    Mangos::Book.new.tap { |book| Mangos::BookUpdater.new(@package, book, path).update }
  end

  def update(path, book)
    return false if !update?(path, book)
    Mangos::BookUpdater.new(@package, book, path).update
    true
  end

  def update?(path, book)
    return true if @package.force?
    return true if path.mtime >= @original_mtime
    return true if book.pages == 0
    false
  end

  def delete(book)
  end
end