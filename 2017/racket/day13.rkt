#lang racket/base

(require [only-in racket/string string-split string-join]
         [only-in racket/list flatten last empty?]
         [only-in racket/port port->string])

(module+ test
  (require rackunit))

(module+ main
  (define puzzle-input (port->string (open-input-file "day13.txt")))
  (printf "First puzzle: \t~a~n" (solve-first puzzle-input)))

(define (solve-first input)
  (define lines (string-split input "\n"))
  (define firewall (apply hash (flatten (map parse lines))))
  (severity firewall))

(module+ test
  (test-case "Example"
    (define input
      (string-join
       '("0: 3" "1: 2" "4: 4" "6: 4")
       "\n"))
    (check-eqv? (solve-first input) 24)))

(define (parse line)
  (map string->number (string-split line ": ")))

(define (severity firewall)
  (for/sum [(pos (in-range (add1 (largest-key firewall))))
            #:when (caught? firewall pos)]
    (let ([fw-depth pos]
          [fw-range (hash-ref firewall pos)])
      (* fw-depth fw-range))))

(define (largest-key a-hash)
  (last (numerical-sort (hash-keys a-hash))))

(define (numerical-sort a-list)
  (sort a-list <))

(define (caught? firewall pos)
  (and (hash-has-key? firewall pos)
       (scanner-at-top? firewall pos pos)))

(define (scanner-at-top? firewall pos t)
  (if (zero? t)
      #t
      ;; else
      (let* ([fw-range (hash-ref firewall pos)]
             [period (* 2 (sub1 fw-range))])
        ;; t is exactly a multiple of period, i.e. there have been exactly
        ;; t / T complete rounds made around the harmonic movement
        (zero? (remainder t period)))))

(module+ test
  (test-case "Caught?"
    (check-false (caught? (hash 0 1 2 1) 1))
    (check-true (caught? (hash 0 1) 0))
    (check-true (caught? (hash 4 4 6 4) 6))))

(module+ main
  (printf "Second puzzle: \t~a~n" (solve-second puzzle-input)))

(define (solve-second input)
  (define lines (string-split input "\n"))
  (define firewall (apply hash (flatten (map parse lines))))
  (find-delay firewall))

(define (find-delay firewall [a-delay 0])
  (cond [(empty? (severities firewall a-delay)) a-delay]
        [else (find-delay firewall (add1 a-delay))]))

(define (severities firewall a-delay)
  (for/list
      [(pos (in-range (add1 (largest-key firewall))))
       #:when (caught-delayed? firewall pos a-delay)]
    1))

(define (caught-delayed? firewall pos a-delay)
  (and (hash-has-key? firewall pos)
       (scanner-at-top? firewall pos (+ pos a-delay))))

(module+ test
  (test-case "Example again"
    (define input
      (string-join
       '("0: 3" "1: 2" "4: 4" "6: 4")
       "\n"))
    (check-eqv? (solve-second input) 10)))
