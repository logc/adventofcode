#lang racket/base

(require (only-in racket/string
                  string-split)
         (only-in racket/list
                  remove-duplicates))

(module+ test
  (require rackunit))

(define (valid? passphrase)
  (define words (string-split passphrase))
  (define dedup (remove-duplicates words))
  (= (length words) (length dedup)))

(module+ test
  (test-case "Valid passphrase"
    (check-true (valid? "aa bb cc dd ee"))
    (check-false (valid? "aa bb cc dd aa"))
    (check-true (valid? "aa bb cc dd aaa"))))

(module+ main
  (define valid-lines-count
    (for/sum ([line (in-lines (open-input-file "day04.txt"))]
              #:when (valid? line))
     1))
  (printf "First puzzle: \t~a~n" valid-lines-count))

(define (no-anagrams? passphrase)
  (define words (string-split passphrase))
  (define listoflistofchars (map string->list words))
  (define sorted (map (lambda (x) (sort x char<?)) listoflistofchars))
  (define dedup (remove-duplicates sorted))
  (= (length sorted) (length dedup)))

(module+ test
  (test-case "Added security"
    (check-true (no-anagrams? "abcde fghij"))
    (check-false (no-anagrams? "abcde xyz ecdab"))
    (check-true (no-anagrams? "a ab abc abd abf abj"))
    (check-true (no-anagrams? "iiii oiii ooii oooi oooo"))
    (check-false (no-anagrams? "oiii ioii iioi iiio"))))

(module+ main
  (define no-anagrams-count
    (for/sum ([line (in-lines (open-input-file "day04.txt"))]
              #:when (no-anagrams? line))
      1))
  (printf "Second puzzle: \t~a~n" no-anagrams-count))
