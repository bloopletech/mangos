class Mangos::Processor
  def initialize(package)
    @package = package
    @original_mtime = @package.data_path.mtime
  end

  def create(path)
    Mangos::Book.new.tap { |book| Mangos::BookUpdater.new(@package, book, path).update }
  end

  def update(path, book)
    return false if path.mtime < @original_mtime
    Mangos::BookUpdater.new(@package, book, path).update
    true
  end

  def delete(book)
  end
end