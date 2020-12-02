(import :std/format
        :std/misc/ports)
(export main)

(define (solve-one numbers total)
  (define (loop n rest seen)
    ;; this proc is defined just to be able to answer empty when finished
    ;; consuming without an answer. it helps reuse the outer proc for part 2.
    ;; otherwise, this proc would be just a named let
    (cond ((null? rest) '())
          (else
           (let ((diff (- total n)))
             (if (hash-key? seen diff)
                 (* diff n)
             ; else
                 (begin
                   (hash-put! seen n #t)
                   (loop (car rest) (cdr rest) seen)))))))
  (loop (car numbers) (cdr numbers) (make-hash-table-eqv)))

(define (solve-two numbers)
  (let loop ((n (car numbers))
             (rest (cdr numbers)))
    (let* ((total (- 2020 n))
           (partial (solve-one rest total)))
      (if (not (null? partial))
          (* partial n)
      ; else
          (loop (car rest) (cdr rest))))))

(define (main)
  (define puzzle-input (read-file-lines "day01.txt"))
  (define number-input (map string->number puzzle-input))
  (printf "Puzzle #1: ~a~n" (solve-one number-input 2020))
  (printf "Puzzle #2: ~a~n" (solve-two number-input)))
