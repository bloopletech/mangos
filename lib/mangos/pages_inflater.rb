class Mangos::PagesInflater
  def initialize(page_paths)
    @page_paths = page_paths
  end

  def inflate
    paths = []

    @page_paths.split("|").each do |part|
      if part.include?("/")
        name, count = part.split("/")

        last_base, last_ext = name.split(".")

        paths << name

        count.to_i.times do
          last_base.succ!
          paths << "#{last_base}.#{last_ext}"
        end
      else
        paths << part
      end
    end

    paths
  end
end