
# oooo - a splitter function object would be nice, because it could stash the width, splitter and cleaner block
# This thing will probably be used a lot with identical params, so seriously, do it. Do it. Do it.    Do it.
#
def similarity(str1, str2, options = { }, &cleaner)
  # Nominal size of pieces to extract from each word.
  width = options[:width] || 2

  # splitter can be a Regexp (defaults to any non-word) or a proc/lambda for extra power.
  # The caller can split on strict whitespace by passing /\s+/, whereas the default of
  # /\W+/ basically only leaves alpha-num. "Apostrophe's" (sic) could be an issue...
  #
  # Capture as both, then replace splitter with a lambda-wrap of re if re is a pattern.
  re = splitter = options[:splitter] || /\W+/
  splitter = lambda { |str| str.split(re) } if re.class == Regexp

  # Give caller the opportunity to use a canonicalizing block (write-once...)
  # If the caller wants no lower-casing, they can use a no-op block { |s| s } :p
  cleaner ||= lambda { |str| str.downcase }

  # Split into words, then collect progressive pieces from each word. Result will be a flat sorted list of pieces.
  smush = lambda { |str| splitter.call(cleaner.call(str)).reject(&:empty?)
                        .map { |s| s.length < width ? s : 0.upto(s.length - width).collect { |i| s[i, width] } }
                        .flatten.sort }

  pieces1, pieces2 = smush.call(str1), smush.call(str2)

  n = (l1 = pieces1.length) + (l2 = pieces2.length)
  # Two empty strings match perfectly. NOTE: strings full of separator also appear empty.
  return 1.0 if n == 0

  # Count matching pieces. Exploit the sorted lists returned from smush() to step through them both.
  i1 = i2 = k = 0
  while i1 < l1 && i2 < l2
      case
        when pieces1[i1] < pieces2[i2] then i1 += 1     # skip in pieces1 while it's current piece is behind
        when pieces1[i1] > pieces2[i2] then i2 += 1     # ditto for pieces2
        else i1 += 1; i2 += 1; k += 1       # score!!!
      end
  end

  # Final score ranges from 0.0 to 1.0
  return (2.0 * k) / n
end

