#lang racket/base

(require racket/list
         (only-in racket/string string-join)
         (only-in racket/function identity))

(module+ test
  (require rackunit))

(module+ main
  (define puzzle-input '(94 84 0 79 2 27 81 1 123 93 218 23 103 255 254 243))
  (printf "First puzzle: \t~a~n" (solve-first puzzle-input)))

(define (solve-first input [size 256])
  (define init-buffer (make-buffer size))
  (define result-buffer (knot-hash-round init-buffer input))
  (define v (vector->list (buffer-contents result-buffer)))
  (* (first v) (second v)))

(define (knot-hash-round a-buffer input)
  (cond [(empty? input) a-buffer]
        [else (let* ([next-slice (buffer-slice a-buffer (first input))]
                     [next-buffer (update-buffer a-buffer next-slice)])
                (knot-hash-round next-buffer (rest input)))]))

(module+ test
  (check-equal? (solve-first '(3 4 1 5) 5) 12))

(struct buffer (contents pos skip) #:transparent)

(define (make-buffer size)
  (buffer (build-vector size identity) 0 0))

(define (buffer-slice a-buffer a-length)
  (define start (buffer-pos a-buffer))
  (define end (+ start a-length))
  (define v (buffer-contents a-buffer))
  (define m (vector-length v))
  (for/vector ([pos (in-range start end)])
    (vector-ref v (modulo pos m))))

(define (vector-reverse a-vector)
  (for/vector ([pos (in-range (sub1 (vector-length a-vector)) -1 -1)])
    (vector-ref a-vector pos)))

(define (update-buffer a-buffer a-slice)
  (define v (buffer-contents a-buffer))
  (define w (vector-reverse a-slice))
  (define L (vector-length v))
  (define l (vector-length w))
  (define start (buffer-pos a-buffer))
  (circular-vector-copy! v start w)
  (define new-pos
    (modulo (+ (buffer-pos a-buffer) l (buffer-skip a-buffer)) L))
  (define new-skip (add1 (buffer-skip a-buffer)))
  (buffer v new-pos new-skip))

(define (circular-vector-copy! v start w)
  (for ([pos (in-range start (+ start (vector-length w)))] [elem w])
    (vector-set! v (modulo pos (vector-length v)) elem)))

(module+ test
  (test-case "Circular buffer"
    (define test-buffer (make-buffer 5))
    (define test-slice (buffer-slice test-buffer 3))
    (define buffer-after-1 (buffer (vector 2 1 0 3 4) 3 1))
    (define second-slice (buffer-slice buffer-after-1 4))
    (define buffer-after-2 (buffer (vector 4 3 0 1 2) 3 2))
    (define third-slice (buffer-slice buffer-after-2 1))
    (define buffer-after-3 (buffer (vector 4 3 0 1 2) 1 3))
    (define fourth-slice (buffer-slice buffer-after-3 5))
    (define buffer-after-4 (buffer (vector 3 4 2 1 0) 4 4))
    (check-equal? test-slice #(0 1 2))
    (check-equal? second-slice #(3 4 2 1))
    (check-equal? third-slice #(1))
    (check-equal? fourth-slice #(3 0 1 2 4))
    (check-equal? (vector-reverse test-slice) #(2 1 0))
    (check-equal? (update-buffer test-buffer test-slice)
                  buffer-after-1)
    (check-equal? (update-buffer buffer-after-1 second-slice)
                  buffer-after-2)
    (check-equal? (update-buffer buffer-after-2 third-slice)
                  buffer-after-3)
    (check-equal? (update-buffer buffer-after-3 fourth-slice)
                  buffer-after-4)))

;; Second puzzle

(module+ main
  (define puzzle-input-string "94,84,0,79,2,27,81,1,123,93,218,23,103,255,254,243")
  (printf "Second puzzle: \t~a~n" (knot-hash puzzle-input-string)))

(define (string->codes/ascii a-string)
  (map char->integer (string->list a-string)))

(module+ test
  (test-case "Convert characters to lengths"
    (check-equal? (string->codes/ascii "1,2,3") '(49 44 50 44 51))))

(define (standard-suffix lengths)
  (append lengths '(17 31 73 47 23)))

(define (knot-hash input-str)
  (define input-lengths (string->codes/ascii input-str))
  (define lengths (standard-suffix input-lengths))
  (define sparse-hash
    (for/fold ([buffer (make-buffer 256)])
              ([i (in-range 64)])
      (knot-hash-round buffer lengths)))
  (define dense-hash
    (sparse->dense (buffer-contents sparse-hash)))
  (integers->hex-string dense-hash))

(module+ test
  (test-case "Knot hash"
    (check-equal? (knot-hash "") "a2582a3a0e66e6e86e3812dcb672a272")
    (check-equal? (knot-hash "AoC 2017") "33efeb34ea91902bb2f59c9920caa6cd")
    (check-equal? (knot-hash "1,2,3") "3efbe78a8d82f29979031a4aa0b16a9d")
    (check-equal? (knot-hash "1,2,4") "63960835bcdc130f0b66d7ff4f6a5a8e")))

(define (sparse->dense sparse-hash)
  (define v (vector->list sparse-hash))
  (define blocks (for/list ([n (in-range 16)]) (take (drop v (* n 16)) 16)))
  (map (lambda (block) (apply bitwise-xor block)) blocks))

(module+ test
  (test-case "Sparse->dense"
    (check-eqv? (bitwise-xor 65 27 9 1 4 3 40 50 91 7 6 0 2 5 68 22) 64)))

(define (integers->hex-string ns)
  (define hex-digits (map decimal->hexadecimal ns))
  (define hex-strings
    (map (lambda (pair) (format "~a~a" (first pair) (second pair))) hex-digits))
  (string-join hex-strings ""))

(module+ test
  (test-case "integers->hex-string"
    (check-equal? (integers->hex-string '(64 7 255)) "4007ff")))

(define (decimal->hexadecimal n)
  (define (convert n remainders)
    (cond [(zero? n) remainders]
          [else (convert (quotient n 16) (cons (remainder n 16) remainders))]))
  (define result (map as-hex-digit (convert n '())))
  (if (< (length result) 2)
      (cons 0 result)
      result))

(define (as-hex-digit decimal-digit)
  (cond [(<= decimal-digit 9) decimal-digit]
        [(= decimal-digit 10) 'a]
        [(= decimal-digit 11) 'b]
        [(= decimal-digit 12) 'c]
        [(= decimal-digit 13) 'd]
        [(= decimal-digit 14) 'e]
        [(= decimal-digit 15) 'f]))

(module+ test
  (test-case "decimal->hexadecimal"
    (check-equal? (decimal->hexadecimal 31) '(1 f))
    (check-equal? (decimal->hexadecimal 7) '(0 7))))
