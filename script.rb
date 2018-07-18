class MostCommonNGrams

  def initialize
    @file_contents = @file_contents = '' #input goes here
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
        @sentences << temp.strip
      end
      i+=1
    end
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
    # each_cons iterates over the given array n times, to_a will then return
    # an array of n grams
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

  def filter_non_repeats
    @phrases.each do |phrase, freq|
      if freq == 1
        @phrases.delete(phrase)
      end
    end
  end

  def filter_subsets
    i = 0
    phrase_keys = @phrases.keys
    while i < phrase_keys.length - 1
      j = i + 1
      while j < phrase_keys.length
        if is_subset?(phrase_keys[i], phrase_keys[j])
          @phrases.delete(phrase_keys[i])
          @phrases[phrase_keys[j]] += 1
        end
        j+=1
      end
      i+=1
    end
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

  def return_top_10
    results = []
    sorted = sort_phrases
    if sorted.length < 10
      len = sorted.length
    else
      len = 10
    end
    len.times do |i|
      results << sorted[i][0]
    end
    results
  end

  def run
    strip_new_lines_and_punc
    split_sentences
    loop_thru_sentences
    filter_non_repeats
    filter_subsets
    print return_top_10
  end

end

MostCommonNGrams.new.run
