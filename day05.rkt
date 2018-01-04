#lang racket/base

(require (only-in racket/match
                  match-let))

(module+ test
  (require rackunit))

;; First puzzle

(define (follow offsets [jump-func jump] [pos 0] [niter 0])
  (if (exited? offsets pos)
      niter
   ; else
      (match-let ([(cons new-offsets new-pos) (jump-func offsets pos)])
        (follow new-offsets jump-func new-pos (add1 niter)))))

(module+ test
  (test-case "Follow offsets"
    (check-eq? (follow (vector 0 3 0 1 -3)) 5)))

(define (exited? offsets pos)
  (pos . >= . (vector-length offsets)))

(define (jump offsets pos)
  (define current-offset (vector-ref offsets pos))
  (vector-set! offsets pos (add1 current-offset))
  (cons offsets (+ pos current-offset)))

(module+ test
  (test-case "Jump"
    (check-equal? (jump (vector 1) 0) (cons #(2) 1)))
  (test-case "Exited?"
    (check-false (exited? #(1) 0))
    (check-true (exited? #(2) 1))
    (check-true (exited? #(2 5 0 1 -2) 5))))

(module+ main
  (define puzzle-input
    (for/vector #:length 1057
        ([line (in-lines (open-input-file "day05.txt"))])
      (string->number line)))
  (printf "First puzzle: \t~a~n" (follow puzzle-input)))

;; Second puzzle

(define (stranger-jump offsets pos)
  (define current-offset (vector-ref offsets pos))
  (if (current-offset . >= . 3)
      (vector-set! offsets pos (sub1 current-offset))
      ; else
      (vector-set! offsets pos (add1 current-offset)))
  (cons offsets (+ pos current-offset)))

(module+ test
  (test-case "Stranger-jumps"
    (check-eq? (follow (vector 0 3 0 1 -3) stranger-jump) 10)
    (check-eq? (follow (vector 1 1 1 1 1 1 1) stranger-jump) 7)))

(module+ main
  (define again-puzzle-input
    (for/vector #:length 1057
        ([line (in-lines (open-input-file "day05.txt"))])
      (string->number line)))
  (printf "Second puzzle: \t~a~n" (follow again-puzzle-input stranger-jump)))
