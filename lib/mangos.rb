#Ruby stdlib
require "pathname"
require "fileutils"
require "uri"
require "json"
require "digest"
require "strscan"

#Gems
require "addressable/uri"
require "naturalsorter"
require "rmagick"

module Mangos
end

require "mangos/decorated_pathname"
require "mangos/processor"
require "mangos/resort_pages_processor"
require "mangos/tag_breaker"
require "mangos/package"
require "mangos/update"
require "mangos/book"
require "mangos/pages_deflater"
require "mangos/pages_inflater"
require "mangos/thumbnailer"
require "mangos/book_updater"
