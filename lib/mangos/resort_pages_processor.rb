class Mangos::ResortPagesProcessor
  def initialize(package)
    @package = package
  end

  def create(path)
    raise "Not for new books!"
  end

  def update(path, book)
    page_paths = Mangos::PagesInflater.new(book.page_paths).inflate
    sorted_page_paths = Naturalsorter::Sorter.sort(page_paths, true)
    book.page_paths = Mangos::PagesDeflater.new(sorted_page_paths).deflate
    true
  end

  def delete(book)
    raise "Not for deleted books!"
  end
end