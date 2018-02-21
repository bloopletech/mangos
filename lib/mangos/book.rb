class Mangos::Book
  attr_accessor :path, :page_paths, :pages, :published_on, :key

  def from_hash(hash)
    @path = hash["path"]
    @page_paths = hash["pagePaths"]
    @pages = hash["pages"]
    @published_on = hash["publishedOn"]
    @key = hash["key"]
  end

  def self.from_hash(hash)
    book = new
    book.from_hash(hash)
    book
  end

  def to_hash
    {
      "path" => @path,
      "pagePaths" => @page_paths,
      "pages" => @pages,
      "publishedOn" => @published_on,
      "key" => @key
    }
  end
end
