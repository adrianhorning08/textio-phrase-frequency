# textio-phrase-frequency

## Overview
Given a string representing a document, write a function which returns the top 10 most frequent repeated phrases.
A phrase is a stretch of three to ten consecutive words and cannot span sentences.
Only include a phrase if it is not a subset of another, longer phrase (if “cool and collected” and “calm cool and collected” are repeated, do not include “cool and collected” in the returned set).
A phrase is repeated if it is used two or more times.

Example input

The quick brown fox jumped over the lazy dog.
The lazy dog, peeved to be labeled lazy, jumped over a snoring turtle.
In retaliation the quick brown fox jumped over ten snoring turtles.

Example output

['the lazy dog', 'the quick brown fox jumped over']

## Usage

1. Clone repo `git clone https://github.com/adrianhorning08/textio-phrase-frequency.git`
2. `cd textio-phrase-frequency`
3. Enter a string into `@file_contents` or provide a file. ie `@file_contents = File.open("sample.txt", "r").read`
3. Run `ruby script.rb`
4. Results will output to terminal

## Implementation
Used Ruby because it is very easy to read contents of a file, and the methods Ruby provides abstracts many time consuming tasks, such as finding n grams and looping through a hash.

I used a hash to store all n grams and their frequency. This becomes slow when I try to find if a phrase is a subset of another phrase (O(n^2)). Something like a prefix tree would perform much faster.
