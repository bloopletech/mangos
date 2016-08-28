class Mangos::PagesDeflater
  def initialize(page_urls)
    @page_urls = page_urls
  end

  def deflate
    last_ext = nil
    last_base = nil
    last_count = 0

    out = []

    @page_urls.each do |path|
      base, ext = path.split(".")

      if last_base.nil? || (ext != last_ext) || (base != last_base.succ)
        if last_count > 0
          out.last.replace("#{out.last}/#{last_count}")
          last_count = 0
        end

        out << path
      else
        last_count += 1
      end

      last_base = base
      last_ext = ext
    end

    if last_count > 0
      out.last.replace("#{out.last}/#{last_count}")
    end

    out.join("|")
  end
end