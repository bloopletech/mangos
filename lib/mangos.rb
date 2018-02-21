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

#Core Extensions
require "mangos/core_ext/pathname"

module Mangos
end

require "mangos/processor"
require "mangos/resort_pages_processor"
require "mangos/tag_breaker"
require "mangos/package"
require "mangos/update"
require "mangos/book"
require "mangos/pages_deflater"
require "mangos/pages_inflater"
require "mangos/book_updater"
