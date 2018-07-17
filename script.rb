# loop through entire file, finding the end of sentences, then provide that
# string to another method to split it to n-grams
require 'pp'

class MostCommonNGrams

  def initialize
    @file_contents = File.open("easy.txt", "r").read
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
    # print n_gram
    n_gram.each do |gram|
      count_n_grams(gram.join(' '))
    end
  end

  def count_n_grams(n_gram)
    if @phrases.key?(n_gram)
      @phrases[n_gram] += 1
    else
      @phrases[n_gram] = 1
    end
  end

  def sort_phrases
    # print @phrases.each_with_index.sort_by(&:first)
  end

  def run
    strip_new_lines_and_punc
    split_sentences
    strip_leading_whitespace
    loop_thru_sentences
    sort_phrases
    pp @phrases
  end

end

MostCommonNGrams.new.run
