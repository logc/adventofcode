#lang racket

(module+ main
  (define puzzle-input (vector 11	11 13	7	0	15	5	5	4	4	1	1	7	1	15 11)))

(module+ test
  (require rackunit))

;; First puzzle

(define (reallocate banks [past-banks '()] [steps 1])
  (let ([new-banks (redistribute banks (choose banks))])
    (cond [(already-seen? new-banks past-banks) steps]
          [else (reallocate new-banks (cons banks past-banks) (add1 steps))])))

(module+ test
  (test-case "Example"
    (check-eq? (reallocate (vector 0 2 7 0)) 5)))

(define (redistribute banks bank-idx)
  (define new-banks (vector-copy banks))
  (define blocks (vector-ref banks bank-idx))
  (vector-set! new-banks bank-idx 0)
  (for ([b blocks])
    (let* ([max-length (vector-length banks)]
           [idx (modulo (+ b bank-idx 1) max-length)]
           [current-val (vector-ref new-banks idx)])
      (vector-set! new-banks idx (add1 current-val))))
  new-banks)

(module+ test
  (test-case "Redistribute"
    (check-equal? (redistribute (vector 1 0) 0) (vector 0 1))
    (check-equal? (redistribute (vector 0 1) 1) (vector 1 0))
    (check-equal? (redistribute (vector 0 2 7 0) 2) (vector 2 4 1 2))))

(define (choose banks)
  (define (max banks found-idx idx)
    (cond [(idx . >= . (vector-length banks)) found-idx]
          [else (let ([item (vector-ref banks idx)])
                  (if (item . > . (vector-ref banks found-idx))
                      (max banks idx (add1 idx))
                      ; else
                      (max banks found-idx (add1 idx))))]))
  (max banks 0 0))

(module+ test
  (test-case "Choose"
    (check-eq? (choose (vector 0 2 7 0)) 2)
    (check-eq? (choose (vector 3 1 2 3)) 0)))

(define (already-seen? banks past-banks)
  (list? (member banks past-banks)))

(module+ test
  (test-case "Already seen"
    (let ([banks (vector 2 4 1 2)]
          [past-banks (list (vector 1 3 4 1)
                            (vector 0 2 3 4)
                            (vector 3 1 2 3)
                            (vector 2 4 1 2)
                            (vector 0 2 7 0))])
      (check-true (already-seen? banks past-banks)))
    (let ([banks (vector 2 4 1 2)]
          [past-banks (list (vector 1 3 4 1)
                            (vector 0 2 3 4)
                            (vector 3 1 2 3)
                            (vector 0 2 7 0))])
      (check-false (already-seen? banks past-banks)))))

(module+ main
  (printf "First puzzle: \t~a~n" (reallocate puzzle-input)))

;; Second puzzle

(define (size-loop banks)
  (define (first-reallocate banks [past-banks '()] [steps 1])
    (let ([new-banks (redistribute banks (choose banks))])
      (cond [(already-seen? new-banks past-banks) new-banks]
            [else (first-reallocate new-banks (cons banks past-banks) (add1 steps))])))
  (let ([reallocated-banks (first-reallocate banks)])
    (reallocate reallocated-banks)))

(module+ test
  (check-eq? (size-loop #(0 2 7 0)) 4))

(module+ main
  (printf "Second puzzle: \t~a~n" (size-loop puzzle-input)))
