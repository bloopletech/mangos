class DecoratedPathname < Pathname
  def image?
    file? && extname && %w(.jpg .jpeg .png .gif).include?(extname.downcase)
  end

  def hidden?
    basename.to_s[0..0] == "."
  end
end
