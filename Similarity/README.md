
# A Smarter String Similarity routine.

NOTE: this is way better than Levenshtein and friends for realistic text.

NOTE: The Ruby version is ahead of the Perl version which needs to play catch-up.

Directly inspired by a
[Stack Overflow Q&A](http://stackoverflow.com/questions/653157/a-better-similarity-ranking-algorithm-for-variable-length-strings)
which references
[Simon White of Catalysoft](http://www.catalysoft.com/articles/StrikeAMatch.html)
as inspiration.

The Ruby version, being ahead of the game, currently offers

```ruby
measure = similarity(str1, str2, width: 2, splitter: /\W+/) { |str| str.downcase.gsub(/'/, '') }
```

where the width and splitter defaults are shown, and the optional block
shows an alternative canonicaliser which downcases and strips apostrophes.
The default for the block just performs downshift on the string.
Note that the string is canonicalised BEFORE it is split into words.

The resultant measure ranges from 0.0 to 1.0.
Strings that are completely different will rate 0.0,
and strings that are completely identical
(disregaring variations of whitespace)
will measure as equivalent (1.0).
The default settings for canonicalisation means that
empty strings or strings containing only blanks
are all equivalent.
Actually, the default /\W+/ means that punctuation will also be ignored.

Read the referenced Simon White article to understand the science.
As for parameters, the splitter (default /\W+/ which means 'non-word characters'))
allows you to choose how to break up the string into words or packets,
and the default width of 2 refers to the size of the particles
that each word is split up into. The article uses particles of length 2,
but you might find it useful to go for bigger particle sizes depending on your data.

The process of canonicalisation refers to removing junk or
other characters you don't care about.
You might consider punctuation characters are worth keeping, for example.
Remember that the optional-but-defaulted block is ran first upon each string,
then the string is broken into words using the splitter,
and finally the algorithm performs it's magic to rate the difference
between the two sets of cleaned-up words.

