# loop through entire file, finding the end of sentences, then provide that
# string to another method to split it to n-grams
require 'pp'

class MostCommonNGrams

  def initialize
    @file_contents = File.open("easier.txt", "r").read
    @phrases = Hash.new
    @sentences = []
  end

  def strip_new_lines_and_punc
    @file_contents = @file_contents.gsub(/[\,\"\:\n\-]/, "")
  end

  def split_sentences
    i = 0
    while i < @file_contents.length
      if !['.','!','?'].include?(@file_contents[i])
        temp = ''
        while !['.','!','?'].include?(@file_contents[i])
          temp += @file_contents[i].downcase
          i+=1
        end
        @sentences << temp
      end
      i+=1
    end
  end

  def strip_leading_whitespace
    @sentences.map! { |e| e.strip }
  end

  def loop_thru_sentences
    @sentences.each do |sentence|
      split_into_n_grams(sentence)
    end
  end

  def split_into_n_grams(sentence)
    split_words = sentence.split(' ')
    sentence_length = split_words.length

    if sentence_length < 10
      max = sentence_length
    else
      max = 10
    end

    n = 3

    while n <= max
      n_grams(n, split_words)
      n += 1
    end
  end

  def n_grams(n, array)
    n_gram = array.each_cons(n).to_a
    n_gram.each do |gram|
      gram = gram.join(' ')
      if @phrases.key?(gram)
        @phrases[gram] += 1
      else
        @phrases[gram] = 1
      end
    end
  end

  def filter_subsets
    i = 0
    phrase_keys = @phrases.keys
    while i < phrase_keys.length - 1
      j = i + 1
      while j < phrase_keys.length
        # puts "a: #{phrase_keys[i]} b: #{phrase_keys[j]}"
        if is_subset?(phrase_keys[i], phrase_keys[j])
          @phrases.delete(phrase_keys[i])
          @phrases[phrase_keys[j]] += 1
        end
        j+=1
      end
      i+=1
    end

  end

  def count_n_grams(gram)

    # You go through each key, and then see which one is longer
    # then you see if the shorter is a subset of the longer
    # if it is, delete both (or whichever is on the hash) and
    # put the longer one on and

    longer = gram
    phrase_count = 1
    @phrases.each_key do |key|
      if is_subset?(key, gram)
        phrase_count += @phrases[key]
        @phrases.delete(key)
        longer = longer(key, gram)
      end
    end
    # if it gets thru the entire loop and and a similar
    # key isn't found, it should add it to the hash
    @phrases[longer] = phrase_count
  end

  def longer(phrase1, phrase2)
    if phrase1.length > phrase2.length
      longest = phrase1
    else
      longest = phrase2
    end
    longest
  end

  def is_subset?(phrase1, phrase2)
    longest = longer(phrase1, phrase2)
    shortest = phrase1 == longest ? phrase2 : phrase1

    a = 0
    b = 0

    while a < shortest.length && b < longest.length
      if shortest[a] != longest[b]
        b += 1
      elsif shortest[a] == longest[b]
        a += 1
        b += 1
      end
    end
    a == shortest.length
  end

  def sort_phrases
    @phrases.sort {|a,b| b[1]<=>a[1]}
  end

  def run
    strip_new_lines_and_punc
    split_sentences
    strip_leading_whitespace
    loop_thru_sentences
    filter_subsets
    print sort_phrases[0..10]
  end

end

MostCommonNGrams.new.run
