#Ruby stdlib
require "pathname"
require "fileutils"
require "uri"
require "json"
require "digest"

#Gems
require "addressable/uri"
require "naturally"
require "RMagick"

#Core Extensions
require "mangos/core_ext/pathname"

module Mangos
end

require "mangos/package"
require "mangos/update"
require "mangos/book"
require "mangos/pages_deflater"
require "mangos/book_updater"
