#lang racket

;; First puzzle

(module+ test
  (require rackunit)
  (define test-input "b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
"))

(define (solve-first input)
  (define lines (map string-trim (string-split input "\n")))
  (define instructions (map parse lines))
  (define (process-all-instructions instructions registers)
    (cond [(empty? instructions) registers]
          [else (let ([updated-registers (do-process (first instructions) registers)])
                  (process-all-instructions (rest instructions) updated-registers))]))
  (find-largest-value (process-all-instructions instructions (make-hash))))

(define (!= a b)
  (not (= a b)))

(struct instruction
  (register opcode amount reg-comp comp val-comp)
  #:transparent)

(define (parse line)
  (define tokens (string-split line " "))
  (define register (string->symbol (first tokens)))
  (define opcode (if (string=? (second tokens) "inc") + -))
  (define amount (string->number (third tokens)))
  (define register-compare (string->symbol (fifth tokens)))
  (define comparison
    (let ([as-string (sixth tokens)])
      (cond [(string=? as-string ">") >]
            [(string=? as-string "<") <]
            [(string=? as-string ">=") >=]
            [(string=? as-string "<=") <=]
            [(string=? as-string "==") =]
            [(string=? as-string "!=") !=])))
  (define value-compare (string->number (seventh tokens)))
  (instruction
   register opcode amount register-compare comparison value-compare))

(define (do-process a-instruct registers)
  (define register (instruction-register a-instruct))
  (define register-compared (instruction-reg-comp a-instruct))
  (when (not (hash-ref registers register #f))
    (hash-set! registers register 0))
  (when (not (hash-ref registers register-compared #f))
    (hash-set! registers register-compared 0))
  ;; (printf "Registers: ~a~n" registers)
  (define compare (instruction-comp a-instruct))
  (define current-val (hash-ref registers register-compared))
  (define desired-val (instruction-val-comp a-instruct))
  ;; (printf "Compare: ~a ~a ~a~n" current-val compare desired-val)
  (when (compare current-val desired-val)
    (let* ([current-amount (hash-ref registers register)]
           [opcode (instruction-opcode a-instruct)]
           [result (opcode current-amount (instruction-amount a-instruct))])
      (hash-set! registers register result)))
  registers)

(define (find-largest-value registers)
  (apply max (hash-values registers)))

(module+ test
  (define-simple-check (check-eq-hash? actual expected)
    (define (hash->ordered-list a-hash)
      (sort (hash->list a-hash)
            (lambda (x y) (symbol<? (car x) (car y)))))
    (define actual-assocs (hash->ordered-list actual))
    (define expect-assocs (hash->ordered-list expected))
    (check-equal? actual-assocs expect-assocs))
  (test-case "Test example"
    (check-eqv? (solve-first test-input) 1))
  (test-case "Parse line"
    (check-equal? (parse "b inc 5 if a > 1")
                  (instruction 'b + 5 'a > 1))
    (check-equal? (parse "a inc 1 if b < 5")
                  (instruction 'a + 1 'b < 5))
    (check-equal? (parse "c inc -20 if c == 10")
                  (instruction 'c + -20 'c = 10))
    (check-equal? (parse "c inc -20 if c != 10")
                  (instruction 'c + -20 'c != 10)))
  (test-case "Process instruction"
    (define first-instruction (instruction 'b + 5 'a > 1))
    (define first-registers (make-hash))
    (check-eq-hash? (do-process first-instruction first-registers)
                    #hash((b . 0) (a . 0)))
    (define second-instruction (instruction 'a + 1 'b < 5))
    (define second-registers (make-hash (list (cons 'b 0) (cons 'a 0))))
    (check-eq-hash? (do-process second-instruction second-registers)
                    (make-hash (list (cons 'a 1) (cons 'b 0))))
    (define third-instruction (instruction 'c - -10 'a >= 1))
    (define third-registers (make-hash (list (cons 'a 1) (cons 'b 0))))
    (check-eq-hash? (do-process third-instruction third-registers)
                    (make-hash (list (cons 'a 1) (cons 'b 0) (cons 'c 10))))
    (define fourth-instruction (instruction 'c + -20 'c = 10))
    (define fourth-registers (make-hash (list (cons 'a 1) (cons 'b 0) (cons 'c 10))))
    (check-eq-hash? (do-process fourth-instruction fourth-registers)
                    (make-hash (list (cons 'a 1) (cons 'b 0) (cons 'c -10)))))
  (test-case "Largest register value"
    (let ([registers (make-hash (list (cons 'a 1) (cons 'b 0) (cons 'c -10)))])
      (check-eqv? (find-largest-value registers) 1))))

(module+ main
  (define main-input (port->string (open-input-file "day08.txt")))
  (printf "First puzzle: \t~a~n" (solve-first main-input)))

;; Second puzzle
(define (solve-second input)
  (define lines (map string-trim (string-split input "\n")))
  (define instructions (map parse lines))
  (define (process-all-instructions instructions registers largest)
    (cond [(empty? instructions) largest]
          [else (let* ([updated-registers (do-process (first instructions) registers)]
                       [current-largest (find-largest-value updated-registers)]
                       [maximum (max current-largest largest)])
                  (process-all-instructions
                   (rest instructions) updated-registers maximum))]))
  (process-all-instructions instructions (make-hash) 0))

(module+ test
  (test-case "Solve second puzzle with test input"
    (check-eqv? (solve-second test-input) 10)))

(module+ main
  (printf "Second puzzle: \t~a~n" (solve-second main-input)))
