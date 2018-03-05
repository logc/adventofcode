#lang racket/base

(require (only-in racket/string string-split string-trim)
         (only-in racket/port port->string))

(module+ test
  (require rackunit))

(module+ main
  (define puzzle-input (port->string (open-input-file "day11.txt")))
  (printf "First puzzle: \t~a~n" (solve-first puzzle-input)))

(define (solve-first input)
  (let ([start (hex-point 0 0 0)]
        [dirs  (string-split (string-trim input) ",")])
    (distance (moves start dirs) start)))

(struct hex-point (r g b) #:transparent)

(define (move-n hp)
  (hex-point (hex-point-r hp)
             (add1 (hex-point-g hp))
             (sub1 (hex-point-b hp))))

(define (move-ne hp)
  (hex-point (add1 (hex-point-r hp))
             (hex-point-g hp)
             (sub1 (hex-point-b hp))))

(define (move-se hp)
  (hex-point (add1 (hex-point-r hp))
             (sub1 (hex-point-g hp))
             (hex-point-b hp)))

(define (move-s hp)
  (hex-point (hex-point-r hp)
             (sub1 (hex-point-g hp))
             (add1 (hex-point-b hp))))

(define (move-sw hp)
  (hex-point (sub1 (hex-point-r hp))
             (hex-point-g hp)
             (add1 (hex-point-b hp))))

(define (move-nw hp)
  (hex-point (sub1 (hex-point-r hp))
             (add1 (hex-point-g hp))
             (hex-point-b hp)))

(define (distance hp1 hp2)
  (max (- (hex-point-r hp1) (hex-point-r hp2))
       (- (hex-point-g hp1) (hex-point-g hp2))
       (- (hex-point-b hp1) (hex-point-b hp2))))

(define (move hp dir)
  (cond [(string=? dir "n" ) (move-n  hp)]
        [(string=? dir "ne") (move-ne hp)]
        [(string=? dir "se") (move-se hp)]
        [(string=? dir "s" ) (move-s  hp)]
        [(string=? dir "sw") (move-sw hp)]
        [(string=? dir "nw") (move-nw hp)]))

(define (moves start dirs)
  (for/fold ([hp start])
            ([dir dirs])
    (move hp dir)))

(module+ test
  (test-case "Move"
    (let ([start (hex-point 0 0 0)])
      (check-equal? (move start "ne") (hex-point 1 0 -1))
      (check-equal? (move start "n" ) (hex-point 0 1 -1))
      (check-equal? (move start "se") (hex-point 1 -1 0))
      (check-equal? (move start "s" ) (hex-point 0 -1 1))
      (check-equal? (move start "sw") (hex-point -1 0 1))
      (check-equal? (move start "nw") (hex-point -1 1 0))))
  (test-case "Moves"
    (let ([start (hex-point 0 0 0)]
          [dirs '("ne" "ne" "ne")]
          [dors '("ne" "ne" "sw" "sw")]
          [durs '("ne" "ne" "s" "s")]
          [dars '("se" "sw" "se" "sw" "sw")])
      (check-equal? (moves start dirs) (hex-point 3 0 -3))
      (check-equal? (moves start dors) (hex-point 0 0 0))
      (check-equal? (moves start durs) (hex-point 2 -2 0))
      (check-equal? (moves start dars) (hex-point -1 -2 3))))
  (test-case "Distances"
    (let ([start (hex-point 0 0 0)]
          [dirs '("ne" "ne" "ne")]
          [dors '("ne" "ne" "sw" "sw")]
          [durs '("ne" "ne" "s" "s")]
          [dars '("se" "sw" "se" "sw" "sw")])
      (check-eq? (distance (moves start dirs) start) 3)
      (check-eq? (distance (moves start dors) start) 0)
      (check-eq? (distance (moves start durs) start) 2)
      (check-eq? (distance (moves start dars) start) 3))))


(module+ main
  (printf "Second puzzle: \t~a~n" (solve-second puzzle-input)))


(define (solve-second input)
  (let ([orig (hex-point 0 0 0)]
        [dirs (string-split (string-trim input) ",")])
    (define-values (finish-hp distances)
      (for/fold ([hp (hex-point 0 0 0)] [distances '()])
               ([dir dirs])
       (define next-hp (move hp dir))
        (values next-hp (cons (distance next-hp orig) distances))))
    (apply max distances)))
