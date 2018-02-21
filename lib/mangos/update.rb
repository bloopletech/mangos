class Mangos::Update
  attr_accessor :books

  def initialize(package, processor)
    @package = package
    @processor = processor
    @books = []
  end

  def update
    load_data
    process
    save_data
    puts "Done!"
  end

  def load_data
    return unless @package.data_path.exist?

    puts "Reading in JSON file"
    @books = JSON.parse(@package.data_path.read).map { |b| Mangos::Book.from_hash(b) }
  end

  def save_data
    puts "Writing out JSON file"
    @package.data_path.write(@books.map { |b| b.to_hash }.to_json)
  end

  def process
    puts "Processing books...\n"

    @new_books = 0
    @updated_books = 0
    @skipped_books = 0
    @deleted_books = 0

    paths = all_paths
    paths.each_with_index do |p, i|
      $stdout.write "\rProcessing #{i + 1} of #{paths.length} (#{(((i + 1) / paths.length.to_f) * 100.0).round}%)"
      $stdout.flush

      process_path(p)
    end

    process_deleted

    puts "\nProcessed #{@new_books} new books, updated #{@updated_books} existing books, removed #{@deleted_books} deleted books, and skipped #{@skipped_books} books"
  end

  def process_deleted
    books_to_remove = @books.reject do |book|
      path = @package.path + book.path
      path.exist?
    end

    @deleted_books = books_to_remove.length

    books_to_remove.each { |book| @processor.delete(book) }

    @books -= books_to_remove
  end

  def process_path(path)
    book_path = path.basename

    book = @books.find { |b| b.path == book_path }

    if book
      if @processor.update(path, book)
        @updated_books += 1
      else
        @skipped_books += 1
      end
    else
      @books << @processor.create(path)
      @new_books += 1
    end
  end

  def all_paths
    @package.path.children.reject { |p| p.hidden? }.select { |p| p.directory? }
  end
end