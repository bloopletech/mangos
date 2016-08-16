class Mangos::Book
  attr_accessor :url, :page_urls, :pages, :title, :published_on, :thumbnail_url, :key

  def from_hash(hash)
    @url = hash["url"]
    @page_urls = hash["pageUrls"]
    @pages = hash["pages"]
    @title = hash["title"]
    @published_on = hash["publishedOn"]
    @thumbnail_url = hash["thumbnailUrl"]
    @key = hash["key"]
  end

  def self.from_hash(hash)
    book = new
    book.from_hash(hash)
    book
  end

  def to_hash
    {
      "url" => @url,
      "pageUrls" => @page_urls,
      "pages" => @pages,
      "title" => @title,
      "publishedOn" => @published_on,
      "thumbnailUrl" => @thumbnail_url,
      "key" => @key
    }
  end
end
