#lang racket

(require (only-in math/number-theory
                  perfect-square))
(module+ main
  (define puzzle-input 361527))

(module+ test
  (require rackunit))

;; First puzzle

(define (data-carry pos)
  (manhattan-distance (coords pos)))

(define (manhattan-distance a-posn)
  (+ (abs (posn-x a-posn))
     (abs (posn-y a-posn))))

(define (next-odd-square n)
  (cond [(and (perfect-square n) (odd? (perfect-square n))) n]
        [else (next-odd-square (add1 n))]))

(define (square-side n)
  (sqrt n))

(module+ test
  (test-case "Data from square"
    (check-eq? (data-carry 1) 0)
    (check-eq? (data-carry 12) 3)
    (check-eq? (data-carry 23) 2)
    (check-eq? (data-carry 1024) 31))
  (test-case "Next odd square"
    (check-eq? (next-odd-square 2) 9)
    (check-eq? (next-odd-square 12) 25)
    (check-eq? (next-odd-square 26) 49))
  (test-case "Square side"
    (check-eq? (square-side 9) 3)
    (check-eq? (square-side 25) 5)))

(struct posn (x y))

(struct square (posn-dr posn-dl posn-ul posn-ur))

(define (construct-square side)
  (define max-x (/ (- side 1) 2))
  (define max-y (/ (- side 1) 2))
  (define posn-dr (posn max-x (* -1 max-y)))
  (define posn-dl (posn (* -1 max-x) (* -1 max-y)))
  (define posn-ul (posn (* -1 max-x) max-y))
  (define posn-ur (posn max-x max-y))
  (square posn-dr posn-dl posn-ul posn-ur))

(module+ test
  (define-simple-check (check-posn? actual expected)
    (check-eqv? (posn-x actual) (posn-x expected))
    (check-eqv? (posn-y actual) (posn-y expected)))
  (define-simple-check (check-square? actual expected)
    (check-posn? (square-posn-dr actual) (square-posn-dr expected))
    (check-posn? (square-posn-dl actual) (square-posn-dl expected))
    (check-posn? (square-posn-ul actual) (square-posn-ul expected))
    (check-posn? (square-posn-ur actual) (square-posn-ur expected)))
  (test-case "Construct square"
    (check-square? (construct-square (square-side 9))
                   (square (posn 1 -1) (posn -1 -1) (posn -1 1) (posn 1 1)))
    (check-square? (construct-square (square-side 25))
                   (square (posn 2 -2) (posn -2 -2) (posn -2 2) (posn 2 2)))
    (check-square? (construct-square (square-side (sqr 7)))
                   (square (posn 3 -3) (posn -3 -3) (posn -3 3) (posn 3 3)))))

(define (coords n)
  (define max-square-val (next-odd-square n))
  (define max-square-side (square-side max-square-val))
  (define max-square (construct-square max-square-side))
  (cond [(on-lower-side? n max-square-val max-square-side)
         (let* ([reference (square-posn-dr max-square)]
                [reference-val max-square-val]
                [diff (- reference-val n)])
           (posn (- (posn-x reference) diff) (posn-y reference)))]
        [(on-left-side? n max-square-val max-square-side)
         (let* ([reference (square-posn-dl max-square)]
                [reference-val (- max-square-val (* 1 (- max-square-side 1)))]
                [diff (- reference-val n)])
           (posn (posn-x reference) (+ (posn-y reference) diff)))]
        [(on-upper-side? n max-square-val max-square-side)
         (let* ([reference (square-posn-ul max-square)]
                [reference-val (- max-square-val (* 2 (- max-square-side 1)))]
                [diff (- reference-val n)])
           (posn (+ (posn-x reference) diff) (posn-y reference)))]
        [(on-right-side? n max-square-val max-square-side)
         (let* ([reference (square-posn-ur max-square)]
                [reference-val (- max-square-val (* 3 (- max-square-side 1)))]
                [diff (- reference-val n)])
           (posn (posn-x reference) (- (posn-y reference) diff)))])
  )

(define (on-lower-side? n max-val side)
  (on-side? n max-val side 1))

(define (on-left-side? n max-val side)
  (on-side? n max-val side 2))

(define (on-upper-side? n max-val side)
  (on-side? n max-val side 3))

(define (on-right-side? n max-val side)
  (on-side? n max-val side 4))

(define (on-side? n max-val side nsides)
  (n . >= . (- max-val (* nsides (- side 1)))))

(module+ test
  (test-case "On lower side"
    (check-true (on-lower-side? 8 9 3))
    (check-true (on-lower-side? 7 9 3))
    (check-false (on-lower-side? 6 9 3)))
  (test-case "On left side"
    (check-true (on-left-side? 6 9 3))
    (check-true (on-left-side? 5 9 3))
    (check-false (on-left-side? 4 9 3)))
  (test-case "On upper side"
    (check-true (on-upper-side? 4 9 3))
    (check-true (on-upper-side? 3 9 3))
    (check-false (on-upper-side? 2 9 3)))
  (test-case "On left side"
    (check-true (on-right-side? 2 9 3)))
  (test-case "Coords"
    (check-posn? (coords 1)  (posn 0 0))
    (check-posn? (coords 2)  (posn 1 0))
    (check-posn? (coords 3)  (posn 1 1))
    (check-posn? (coords 4)  (posn 0 1))
    (check-posn? (coords 5)  (posn -1 1))
    (check-posn? (coords 6)  (posn -1 0))
    (check-posn? (coords 7)  (posn -1 -1))
    (check-posn? (coords 8)  (posn 0 -1))
    (check-posn? (coords 9)  (posn 1 -1))
    (check-posn? (coords 10) (posn 2 -1))
    (check-posn? (coords 11) (posn 2 0))
    (check-posn? (coords 12) (posn 2 1))
    (check-posn? (coords 23) (posn 0 -2))))

(module+ main
  (printf "First puzzle: \t~a~n" (data-carry puzzle-input)))

;; Second puzzle

(define (neighbors coordinates)
  (define x (vector-ref coordinates 0))
  (define y (vector-ref coordinates 1))
  (let ([ur (vector (add1 x) (add1 y))]
        [uu (vector       x  (add1 y))]
        [ul (vector (sub1 x) (add1 y))]
        [rr (vector (add1 x)       y)]
        [ll (vector (sub1 x)       y)]
        [dr (vector (add1 x) (sub1 y))]
        [dd (vector       x  (sub1 y))]
        [dl (vector (sub1 x) (sub1 y))])
    (list ur uu ul rr ll dr dd dl)))

(module+ test
  (test-case "Neighbors"
    (let ([nn (neighbors (vector 1 0))])
      (check-equal? (first nn)   (vector 2 1))
      (check-equal? (second nn)  (vector 1 1))
      (check-equal? (third nn)   (vector 0 1))
      (check-equal? (fourth nn)  (vector 2 0))
      (check-equal? (fifth nn)   (vector 0 0))
      (check-equal? (sixth nn)   (vector 2 -1))
      (check-equal? (seventh nn) (vector 1 -1))
      (check-equal? (eighth nn)  (vector 0 -1)))))

(define (fill-square coords-ord grid)
  (define cds (coordinates coords-ord))
  (define nn (neighbors cds))
  (define sum
    (cond [(= coords-ord 1) 1]
          [else (for/sum ([n nn])
                  (let ([filled (assoc n grid)])
                    (if filled (cadr filled) 0)))]))
  (cons (list cds sum) grid))

(module+ test
  (test-case "Fill square"
    (define-simple-check (check-first? actual expected)
      (check-equal? (first actual) expected))
    (check-equal? (fill-square 1 '()) '((#(0 0) 1)))
    (check-first? (fill-square 2 '((#(0 0) 1))) '(#(1 0) 1))
    (check-first? (fill-square 3 '((#(1 0) 1) (#(0 0) 1))) '(#(1 1) 2))
    (check-first? (fill-square 4 '((#(1 1) 2) (#(1 0) 1) (#(0 0) 1))) '(#(0 1) 4))
    (check-first? (fill-square 5 '((#(0 1) 4) (#(1 1) 2) (#(1 0) 1) (#(0 0) 1)))
                  '(#(-1 1) 5))
    (check-first? (fill-square 6 '((#(-1 1) 5) (#(0 1) 4) (#(1 1) 2) (#(1 0) 1) (#(0 0) 1)))
                  '(#(-1 0) 10))
    (check-first? (fill-square 7 '((#(-1 0) 10) (#(-1 1) 5) (#(0 1) 4) (#(1 1) 2) (#(1 0) 1) (#(0 0) 1)))
                  '(#(-1 -1) 11))
    (check-first? (fill-square 8 '((#(-1 -1) 11) (#(-1 0) 10) (#(-1 1) 5) (#(0 1) 4) (#(1 1) 2) (#(1 0) 1) (#(0 0) 1)))
                  '(#(0 -1) 23))
    (check-first? (fill-square 9 '((#(0 -1) 23) (#(-1 -1) 11) (#(-1 0) 10)
                                                (#(-1 1) 5) (#(0 1) 4) (#(1 1) 2)
                                                (#(1 0) 1) (#(0 0) 1)))
                  '(#(1 -1) 25))
    (check-first? (fill-square 10 '((#(1 -1) 25) (#(0 -1) 23) (#(-1 -1) 11)
                                                  (#(-1 0) 10) (#(-1 1) 5)
                                                  (#(0 1) 4) (#(1 1) 2)
                                                  (#(1 0) 1) (#(0 0) 1)))
                  '(#(2 -1) 26))
    (check-first? (fill-square 11 '((#(2 -1) 26) (#(1 -1) 25) (#(0 -1) 23) (#(-1 -1) 11)
                                                 (#(-1 0) 10) (#(-1 1) 5)
                                                 (#(0 1) 4) (#(1 1) 2)
                                                 (#(1 0) 1) (#(0 0) 1)))
                  '(#(2 0) 54))
    (check-first? (fill-square 12 '((#(2 0) 54) (#(2 -1) 26) (#(1 -1) 25) (#(0 -1) 23) (#(-1 -1) 11)
                                                 (#(-1 0) 10) (#(-1 1) 5)
                                                 (#(0 1) 4) (#(1 1) 2)
                                                 (#(1 0) 1) (#(0 0) 1)))
                  '(#(2 1) 57))))

(define (coordinates step)
  (define coords (vector 0 0))
  (for ([n (in-range 1 step)])
    (define max-val (next-odd-square n))
    (define max-side (square-side max-val))
    (define-values (idx inc)
      (cond [(to-right? n) (values 0 add1)]
            [(on-lower-side? n max-val max-side) (values 0 add1)]
            [(on-left-side? n max-val max-side) (values 1 sub1)]
            [(on-upper-side? n max-val max-side) (values 0 sub1)]
            [(on-right-side? n max-val max-side) (values 1 add1)]))
    (define current (vector-ref coords idx))
    (vector-set! coords idx (inc current)))
  coords)

(module+ test
  (test-case "Coordinates"
    (check-equal? (coordinates 1) #(0 0))
    (check-equal? (coordinates 2) #(1 0))
    (check-equal? (coordinates 3) #(1 1))
    (check-equal? (coordinates 4) #(0 1))
    (check-equal? (coordinates 5) #(-1 1))
    (check-equal? (coordinates 6) #(-1 0))
    (check-equal? (coordinates 7) #(-1 -1))
    (check-equal? (coordinates 8) #(0 -1))
    (check-equal? (coordinates 9) #(1 -1))
    (check-equal? (coordinates 10) #(2 -1))
    (check-equal? (coordinates 11) #(2 0))
    (check-equal? (coordinates 12) #(2 1))
    (check-equal? (coordinates 13) #(2 2))
    (check-equal? (coordinates 14) #(1 2))
    (check-equal? (coordinates 15) #(0 2))
    (check-equal? (coordinates 16) #(-1 2))
    (check-equal? (coordinates 17) #(-2 2))))

(define (prev-odd-square n)
  (cond [(and (perfect-square n) (odd? (perfect-square n))) n]
        [else (prev-odd-square (sub1 n))]))

(define (to-right? n)
  (= (prev-odd-square n) n))

(module+ test
  (test-case "Prev odd square"
    (check-eq? (prev-odd-square 2) 1)
    (check-eq? (prev-odd-square 10) 9))
  (test-case "To right"
    (check-true (to-right? (sub1 2)))
    (check-true (to-right? (sub1 10)))
    (check-true (to-right? (sub1 26)))))

(define (fill-until value [n 1] [grid '()])
  (define new-grid (fill-square n grid))
  (define square-val (first new-grid))
  (define square (first square-val))
  (define val (second square-val))
  (cond [(val . > . value) val]
        [else (fill-until value (add1 n) new-grid)]))

(module+ test
  (test-case "Fill until greater"
    (check-eq? (fill-until 56) 57)
    (check-eq? (fill-until 134) 142)
    (check-eq? (fill-until 745) 747)
    (check-eq? (fill-until 747) 806)))

(module+ main
  (printf "Second puzzle: \t~a~n" (fill-until puzzle-input)))
