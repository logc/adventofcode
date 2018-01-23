#lang racket

(module+ test
  (require rackunit)
  (define test-input "
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"))

;; First puzzle

(define (parse-adjacencies input)
  (filter (compose not empty?)
          (for/list ([line (string-split input "\n")])
            (for/list ([word (string-split line)]
                       #:when ((length (string-split line)) . > . 3))
              (string-trim word ",")))))

(define (tree-root input)
  (define adjacencies (parse-adjacencies input))
  (define parents (map first adjacencies))
  (define children (remove-duplicates
                    (flatten
                     (map (lambda (x) (list-tail x 3)) adjacencies))))
  (first (filter (lambda (parent) (not (member parent children))) parents)))

(module+ test
  (test-case "Example of root"
    (check-equal? (tree-root test-input) "tknk")))

(module+ main
  (define main-input (port->string (open-input-file "day07.txt")))
  (define overall-root (tree-root main-input))
  (printf "First puzzle: \t~a~n" overall-root))

;; Second puzzle

(struct process (name weight children) #:transparent)

(define (parse-weight a-str)
  (string->number (string-trim a-str #rx"[()]")))

(define (remove-commas a-str)
  (string-replace a-str "," ""))

(define (parse-children a-list)
  (cond [((length a-list) . < . 3) '()]
        [else (map (compose string->symbol remove-commas)
                   (drop a-list 3))]))

(define (parse-process line)
  (let* ([tokens (string-split line)]
         [name (string->symbol (first tokens))]
         [weight (parse-weight (second tokens))]
         [children (parse-children tokens)])
    (process name weight children)))

(module+ test
  (test-case "Parse process"
    (check-equal? (parse-process "yflpz (40)") (process 'yflpz 40 '()))
    (check-equal? (parse-process "imzegu (190) -> afpxssv, xdwzfh")
                  (process 'imzegu 190 '(afpxssv xdwzfh)))))

(define (parse-tree lines)
  (for/hash ([line lines])
    (let ([p (parse-process line)])
      (values (process-name p) p))))

(module+ test
  (test-case "Parse tree"
    (let* ([lines '("a (1) -> b" "b (2)")]
           [tree (parse-tree lines)])
      (check-true (hash? tree))
      (check-equal? (hash-ref tree 'a)
                    (process 'a 1 '(b)))
      (check-equal? (hash-ref tree 'b)
                    (process 'b 2 '())))))

(module+ test
  (define second-layer-imbalance-input
    '("a (1) -> b c"
      "b (2) -> d e"
      "c (1)"
      "d (1)"
      "e (1)"))
  (define third-layer-imbalance-input
    '("a (1) -> b c d"
      "b (1) -> e f g"
      "c (1) -> h i j"
      "d (1) -> k l m"
      "e (1) -> n"
      "f (1) -> o"
      "g (1) -> p"
      "h (2) -> q" ;; here is the imbalance
      "i (1) -> r"
      "j (1) -> s"
      "k (1) -> t"
      "l (1) -> u"
      "m (1) -> v"
      "n (1)" "o (1)" "p (1)" "q (1)" "r (1)" "s (1)" "t (1)" "u (1)" "v (1)")))

(define (sum-weights a-tree start)
  (define root (hash-ref a-tree start))
  (define root-weight (process-weight root))
  (define children (process-children root))
  (cond [(empty? children)
         root-weight]
        [else
         (+ root-weight
            (apply + (map (lambda (x) (sum-weights a-tree x)) children)))]))

(define (find-problem-node a-tree start)
  (define children (process-children (hash-ref a-tree start)))
  (define child+weight
    (for/list ([c children])
      (cons c (sum-weights a-tree c))))
  (define singled-out-by-its-weight
    (flatten
     (filter (lambda (group) ((length group) . = . 1))
             (group-by cdr child+weight))))
  (cond [(or (empty? singled-out-by-its-weight)
             ((length children) . = . 1))
         start]
        [else (find-problem-node a-tree (car singled-out-by-its-weight))]))

(module+ test
  (define test-lines (string-split test-input "\n"))
  (define test-tree (parse-tree test-lines))
  (define second-layer-tree (parse-tree second-layer-imbalance-input))
  (define third-layer-tree (parse-tree third-layer-imbalance-input))
  (test-case "Find node with different weight in subtree"
    (check-equal? (find-problem-node third-layer-tree 'a)
                  'h))
  (check-equal? (find-problem-node test-tree 'tknk)
                  'ugml )
  (test-case "Sum weights of subtree"
    (check-eqv? (sum-weights test-tree 'ugml) 251)
    (check-eqv? (sum-weights test-tree 'padx) 243)
    (check-eqv? (sum-weights test-tree 'fwft) 243)
    (check-eqv? (sum-weights second-layer-tree 'a) 6)
    (check-eqv? (sum-weights second-layer-tree 'b) 4)
    (check-eqv? (sum-weights second-layer-tree 'c) 1)
    (check-eqv? (sum-weights third-layer-tree 'h) 3)
    (check-eqv? (sum-weights third-layer-tree 'i) 2)
    (check-eqv? (sum-weights third-layer-tree 'j) 2)))

(define (find-siblings a-tree start needle)
  (let ([children (process-children (hash-ref a-tree start))])
    (cond [(member needle children) children]
          [else (flatten
                 (for/list ([c children])
                   (find-siblings a-tree c needle)))])))

(module+ test
  (test-case "Find siblings of a node"
    (check-equal? (find-siblings test-tree 'tknk 'ugml) '(ugml padx fwft))
    (check-equal? (find-siblings third-layer-tree 'a 'h) '(h i j))))

(define (adjust-weight a-tree siblings culprit)
  (define sibling+weight
    (for/list ([s siblings])
      (cons s (sum-weights a-tree s))))
  (define culprit+weight (assoc culprit sibling+weight))
  (define anyother+weight
    (car (take (remove culprit+weight sibling+weight) 1)))
  (define diff (- (cdr culprit+weight) (cdr anyother+weight)))
  (cons culprit (- (process-weight (hash-ref a-tree culprit)) diff)))

(module+ test
  (test-case "Adjust weight"
    (check-equal? (adjust-weight test-tree '(ugml padx fwft) 'ugml)
                  '(ugml . 60))))

(module+ main
  (define main-tree (parse-tree (string-split main-input "\n")))
  (define start (string->symbol overall-root))
  (define problem-node (find-problem-node main-tree start))
  (define problem-disk (find-siblings main-tree start problem-node))
  (printf "Second puzzle: \t~a~n"
          (adjust-weight main-tree problem-disk problem-node)))
