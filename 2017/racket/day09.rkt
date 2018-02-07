#lang racket/base

(module+ test
  (require rackunit))

;; First puzzle

(module+ main
  (define puzzle-input (open-input-file "day09.txt"))
  (printf "First puzzle: \t~a~n" (solve-first puzzle-input))
  (close-input-port puzzle-input))

(struct state (score total))

(define (solve-first input)
  (define-values (final-state final-garbage final-ignored)
    (for/fold
        ([acc-state (state 0 0)]
         [prev-in-garbage #f]
         [ignored #f])
       ([c (in-port read-char input)])
      (define in-garbage
        (if (not ignored)
            (update-garbage prev-in-garbage c)
            prev-in-garbage))
      (define next-state
        (if (not in-garbage)
            (update acc-state c)
            acc-state))
      (define next-ignored (and (is-exclamation? c)
                                (not ignored)))
      (values next-state in-garbage next-ignored)))
  (state-total final-state))

(define (is-exclamation? chr) (eqv? chr #\!))

(module+ test
  (test-case "Solve first puzzle"
    (check-eqv? (solve-first (open-input-string "{}")) 1)
    (check-eqv? (solve-first (open-input-string "<{}>")) 0)
    (check-eqv? (solve-first (open-input-string "{}>")) 1)
    (check-eqv? (solve-first (open-input-string "{{}}")) (+ 1 2))
    (check-eqv? (solve-first (open-input-string "{{{}}}")) (+ 1 2 3))
    (check-eqv? (solve-first (open-input-string "{<{}>}")) 1)
    (check-eqv? (solve-first (open-input-string "{!<{}>}")) (+ 1 2))
    (check-eqv? (solve-first (open-input-string "{!!<{}>}")) 1)))

(define (update a-state chr)
  (cond [(open-bracket? chr)
         (struct-copy state a-state
                      [score (add1 (state-score a-state))])]
        [(close-bracket? chr)
         (struct-copy state a-state
                      [score (sub1 (state-score a-state))]
                      [total (+ (state-score a-state) (state-total a-state))])]
        [else a-state]))

(define (open-bracket? chr) (eqv? chr #\{))

(define (close-bracket? chr) (eqv? chr #\}))

(define (update-garbage current-garbage chr)
  (cond [(and (open-angle? chr) (not current-garbage)) #t]
        [(and (close-angle? chr) current-garbage) #f]
        [else current-garbage]))

(define (open-angle? chr) (eqv? chr #\<))

(define (close-angle? chr) (eqv? chr #\>))


;; Second puzzle

(module+ main
  (define same-puzzle-input (open-input-file "day09.txt"))
  (printf "Second puzzle: \t~a~n" (solve-second same-puzzle-input))
  (close-input-port same-puzzle-input))

(define (solve-second input)
  (define-values (final-count final-garbage final-ignored)
    (for/fold ([acc 0]
               [previous-in-garbage #f]
               [ignored #f])
              ([c (in-port read-char input)])
      (define in-garbage
        (if (not ignored)
            (update-garbage previous-in-garbage c)
            previous-in-garbage))
      (define next-acc
        (if (and in-garbage previous-in-garbage (not (is-exclamation? c)) (not ignored))
            (add1 acc)
            acc))
      (define next-ignored
        (and (is-exclamation? c) (not ignored)))
      (values next-acc in-garbage next-ignored)))
  final-count)

(module+ test
  (test-case "Solve second"
    (check-eqv? (solve-second (open-input-string "<>")) 0)
    (check-eqv? (solve-second (open-input-string "<random characters>")) 17)
    (check-eqv? (solve-second (open-input-string "<<<<>")) 3)
    (check-eqv? (solve-second (open-input-string "<{!>}>")) 2)
    (check-eqv? (solve-second (open-input-string "<!!>")) 0)
    (check-eqv? (solve-second (open-input-string "<!!!>>")) 0)
    (check-eqv? (solve-second (open-input-string "<{o\"i!a,<{i<a>")) 10)))
