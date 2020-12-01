(import :std/format)
(import :std/misc/ports)
(import :std/iter)
(export main)

(define (sum numbers)
  (apply + numbers))

(define (cycle alist)
  (lambda ()
    (let ((list-len (length alist)))
      (let loop ((idx 0))
        (yield (list-ref alist (modulo idx list-len)))
        (loop (1+ idx))))))

(define (find-first-repeated numbers)
  (declare (fixnum) (not safe))
  (let* ((curr 0)
         (list-len (length numbers))
         (seen (list->hash-table-eqv (list (cons curr #t)))))
    (let loop ((idx 0))
      (let ((n (list-ref numbers (modulo idx list-len))))
        (set! curr (+ curr n))
        (if (hash-key? seen curr)
            curr
            (begin
              (hash-put! seen curr #t)
              (loop (1+ idx))))))))

(define (main)
  (define puzzle-input (read-file-lines "day01.txt"))
  (define input-numbers (map string->number puzzle-input))
  (define first-answer (sum input-numbers))
  (define secnd-answer (find-first-repeated input-numbers))
  (printf "First puzzle answer: ~a~n" first-answer)
  (printf "Second puzzle answer: ~a~n" secnd-answer))

