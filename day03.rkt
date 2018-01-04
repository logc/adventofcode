#lang racket

(require math/number-theory)

(module+ main
  (define puzzle-input 361527))

(module+ test
  (require rackunit))

(define (nearest-square-corner number)
  (for/first ([n (in-range number 0 -1)]
              #:when (and (odd? n) (perfect-square n)))
    n))

(define (next-square-corner number)
  (for/first ([n (in-naturals number)]
              #:when (and (odd? n) (perfect-square n)))
    n))

(define (min-square-radius number)
  (- (sqrt (nearest-square-corner number)) 1))

(define (max-square-radius number)
  (- (sqrt (next-square-corner number)) 1))

(module+ test
  (test-case "Nearest square corner"
    (check-eq? (nearest-square-corner 11) 9)
    (check-eq? (nearest-square-corner 27) 25)
    (check-eq? (nearest-square-corner 1024) 961))
  (test-case "Next square corner"
    (check-eq? (next-square-corner 11) 25))
  (test-case "Min square radius"
    (check-eq? (min-square-radius 11) 2)
    (check-eq? (min-square-radius 27) 4)
    (check-eq? (min-square-radius 1024) 30)))

(define (axis-aligned? number)
  (zero?
   (with-modulus (min-square-radius number)
     (mod- number (nearest-square-corner number)))))

(module+ test
  (test-case "Axis aligned"
    (check-true (axis-aligned? 9))
    (check-false (axis-aligned? 10))
    (check-true (axis-aligned? 11))
    (check-false (axis-aligned? 13))
    (check-true (axis-aligned? 23))))

(define (min-carry data)
  (cond [(= data 1) 0]
        [(axis-aligned? data) (min-square-radius data)]
        [else (add1 (min-square-radius data))]))

(module+ test
  (test-case "Min carry"
    (check-eq? (min-carry 1) 0)
    (check-eq? (min-carry 12) 3)
    (check-eq? (min-carry 13) 3)
    (check-eq? (min-carry 23) 2)
    (check-eq? (min-carry 1024) 31)))

(module+ main
  (printf "First puzzle: \t~a~n" (min-carry puzzle-input)))
