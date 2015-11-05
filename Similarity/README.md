
* A Smarter String Similarity routine.

The Ruby version is ahead of the Perl version, which needs to play catch-up.

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

The resultant measure ranges from 0.0 to 1.0 which means that strings containing only /\W+/
will measure as equivalent (1.0). For the default settings, this means empty strings,
strings containing only blanks, and strings only containing blank or non-wordy characters.

