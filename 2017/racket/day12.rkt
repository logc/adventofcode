#lang racket

(module+ test
  (require rackunit))

(module+ main
  (define puzzle-input (port->string (open-input-file "day12.txt")))
  (printf "First puzzle: \t~a~n" (solve-first puzzle-input)))

(define (solve-first input)
  (define lines (string-split input "\n"))
  (define graph (make-hash (map parse lines)))
  (define zero-subgraph (dfs graph 0))
  (length zero-subgraph))

(define (parse line)
  (define tokens (string-split line))
  (let ([node (string->number (first tokens))]
        [neighbors (map (lambda (x) (string-trim x ",")) (drop tokens 2))])
    (cons node (list (map string->number neighbors)))))

(module+ test
  (test-case "Parse line"
    (check-equal? (parse "2 <-> 0, 3, 4") '(2 (0 3 4)))
    (check-equal? (parse "1993 <-> 685" ) '(1993 (685)))))

(define (dfs g start [found '()])
  (define (search g neighbours visited)
    (for/list ([n neighbours]
               #:when (not (memq n visited)))
      (dfs g n visited)))
  (let ([new-found (cons start found)]
        [neighbours (first (hash-ref g start '(())))])
    (cond [(all-in-list? neighbours new-found) new-found]
          [(empty? neighbours) new-found]
          [else (remove-duplicates
                 (numerical-sort
                  (flatten
                   (search g neighbours new-found))))])))

(define (numerical-sort a-list)
  (sort a-list <))

(module+ test
  (test-case "Depth-first search"
    (let ([graph (make-hash '((0 (1))))])
      (check-equal? (dfs graph 0) '(0 1)))
    (let ([graph (make-hash '((0 (1)) (1 (2))))])
      (check-equal? (dfs graph 0) '(0 1 2)))
    (let ([graph (make-hash '((0 (1)) (1 (0 2)) (2 (3))))])
      (check-equal? (dfs graph 0) '(0 1 2 3)))
    (let ([graph (make-hash '((0 (2)) (1 ()) (2 (0))))])
      (check-equal? (dfs graph 0) '(0 2)))))

(define (all-in-list? elems a-list [answer #f])
  (for/and ([elem elems])
    (not (false? (memq elem a-list)))))

(module+ test
  (test-case "All in list?"
    (check-true (all-in-list? '(1 2) '(1 2 3 4)))
    (check-false (all-in-list? '(1 2) '(1 3 4 5)))))

(module+ main
  (printf "Second puzzle: \t~a~n" (solve-second puzzle-input)))

(define (solve-second input)
  (define lines (string-split input "\n"))
  (define graph (make-hash (map parse lines)))
  (define components (find-components graph))
  (length components))

(define (find-components graph)
  (cond [(empty? (hash-keys graph)) '()]
        [else (let* ([k (lowest-key graph)]
                     [component (dfs graph k)]
                     [new-graph (prune graph component)])
                (cons component (find-components new-graph)))]))

(define (lowest-key a-hash)
  (first (sort (hash-keys a-hash) <)))

(define (prune graph component)
  (for ([node component]) (hash-remove! graph node))
  graph)

(module+ test
  (test-case "Find all components"
    (define example
      '("0 <-> 2"
        "1 <-> 1"
        "2 <-> 0, 3, 4"
        "3 <-> 2, 4"
        "4 <-> 2, 3, 6"
        "5 <-> 6"
        "6 <-> 4, 5"))
    (define graph (make-hash (map parse example)))
    (check-equal? (find-components graph) '((0 2 3 4 5 6) (1)))))
