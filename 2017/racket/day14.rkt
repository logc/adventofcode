#lang racket

(require "day10.rkt")

(module+ test
  (require rackunit))

(module+ main
  (define puzzle-input "xlqgujun")
  (printf "First puzzle: \t~a~n" (solve-first puzzle-input)))

(define (solve-first input)
  (define rows
    (for/list ([n (in-range 128)])
      (format "~a-~a" input n)))
  (define hashes (map knot-hash rows))
  (define binaries (map hexadecimal->binary hashes))
  binaries)

(module+ test
  (test-case "Knot hashes for 'flqrgnkx'"
    (check-equal? (knot-hash "flqrgnkx-0") "d4f76bdcbf838f8416ccfa8bc6d1f9e6")
    (check-equal? (knot-hash "flqrgnkx-1") "55eab3c4fbfede16dcec2c66dda26464")
    (check-equal? (knot-hash "flqrgnkx-127") "3ecaf0d2646e9dc1483e752d52688a1e")))

(define (hexadecimal->binary hex-string)
  (let* ([ns (map hex->decimal (string->list hex-string))]
         [all-remainders (flatten (map pad-to-four-elems (map convert ns)))])
    (string-join (map number->string all-remainders) "")))

(define (convert n [remainders '()])
  (cond [(zero? n) remainders]
        [else (convert (quotient n 2) (cons (remainder n 2) remainders))]))

(define (hex->decimal a-string)
  (string->number (format "#x~a" a-string)))

(define (pad-to-four-elems a-list)
  (cond [(>= (length a-list) 4) a-list]
        [else (pad-to-four-elems (cons 0 a-list))]))

(module+ test
  (test-case "Hexadecimal to binary"
    (check-equal? (hexadecimal->binary "1") "0001")
    (check-equal? (hexadecimal->binary "f") "1111")
    (check-equal? (hexadecimal->binary "a0c2017")
                  "1010000011000010000000010111")))
