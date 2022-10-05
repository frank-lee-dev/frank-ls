def middle_word(string)
  arr = string.split
  word_count = arr.count
  return "" if word_count == 0 || word_count.even?
  arr[word_count / 2]
end

p middle_word('the last word') == 'last'
p middle_word('Launch School is great!') == ''
p middle_word('here is a sentence with odd words') == 'sentence'
p middle_word('') == ''

# input = string
# output = string

# Suppose we need a method that retrieves the middle word of a phrase/sentence. What edge cases need to be considered? How would you handle those edge cases without ignoring them? Write a method that returns the middle word of a phrase or sentence. It should handle all of the edge cases you thought of.

# edge cases:
# - no word given
#   - return empty string
# - one word given
#   - return the word
# - even number of words given
#   - return empty string

# algo
# - split the argument save as array variable
# - count the number of items on that list and save as word_count variable
# - return empty string if word_count is 0 or even
# - return array[word_count / 2]