$filesURLdir = "https://raw.githubusercontent.com/shlomif/fortune-mod/master/fortune-mod/datfiles"
$filesGH = @(
  'art', 'ascii-art', 'computers', 'cookie', 'debian', 'definitions', 'disclaimer',
  'drugs', 'education', 'ethnic', 'food', 'fortunes', 'goedel', 'humorists', 'kids',
  'knghtbrd', 'law', 'linux', 'literature', 'love', 'magic', 'medicine', 'men-women',
  'miscellaneous', 'news', 'paradoxum', 'people', 'perl', 'pets', 'platitudes',
  'politics', 'pratchett', 'riddles', 'science', 'shlomif-fav', 'songs-poems',
  'sports', 'startrek', 'tao', 'translate-me', 'wisdom', 'work', 'zippy'
)

foreach ($file in $filesGH) {
    curl $filesURLdir/$file --output "$env:HOMEPATH\dotfiles\docs\fortunes\$file"
}
