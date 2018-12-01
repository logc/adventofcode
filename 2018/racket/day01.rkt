#lang racket/base

(require (only-in racket/set
                  seteqv
                  set-member?
                  set-add))

(module+ test
  (require rackunit))

(define (read-lines filename)
  (for/list ([line (in-lines (open-input-file filename))]) line))

(define (find-first-repeated numbers)
  (define (do-find ns curr seen pos)
    (let ([n (repeated-ref ns pos)])
      (let ([freq (+ curr n)])
        (cond [(set-member? seen freq) freq]
              [else
               (do-find ns freq (set-add seen freq) (add1 pos))]))))
  (do-find numbers 0 (seteqv 0) 0))

(module+ test
  (check-eqv? (find-first-repeated '(1 -1)) 0)
  (check-eqv? (find-first-repeated '(3 3 4 -2 -4)) 10)
  (check-eqv? (find-first-repeated '(-6 3 8 5 -6)) 5)
  (check-eqv? (find-first-repeated '(7 7 -2 -7 -4)) 14))

(define (repeated-ref lst pos)
  (let ([new-pos (modulo pos (length lst))])
    (list-ref lst new-pos)))

(module+ test
  (check-eqv? (repeated-ref '(1 2 3) 3) 1)
  (check-eqv? (repeated-ref '(1 -1) 3) -1))

(module+ main
  (define puzzle-input (read-lines "day01.txt"))
  (define numbers (map string->number puzzle-input))
  (printf "First puzzle answer: ~a~n" (apply + numbers))
  (define first-repeated (find-first-repeated numbers))
  (printf "Second puzzle answer: ~a~n" first-repeated))
