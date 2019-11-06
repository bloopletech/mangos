class Mangos::TagBreaker
  DELIMITERS = [
    ['(', ')'],
    ['[', ']'],
    ['{', '}'],
    ['<', '>']
  ]

  def initialize(text)
    @text = text
  end

  def tags
    results = []
    DELIMITERS.each { |(open, close)| results.concat(extract(open, close)) }
    results
  end

  def extract(open, close)
    token_regexp = /[^#{Regexp.escape(open)}#{Regexp.escape(close)}]+/
    delimiter_regexp = /[#{Regexp.escape(open)}#{Regexp.escape(close)}]/

    scanner = StringScanner.new(@text)

    results = []
    stack = []

    until scanner.eos? do
      token = scanner.scan(token_regexp)
      stack.each { |tag| tag << token } if token

      delimiter = scanner.scan(delimiter_regexp)
      case delimiter
      when open
        stack.push('')
      when close
        results << stack.pop
      end
    end

    results.concat(stack).compact
  end
end