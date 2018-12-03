(define puzzle-input
  (let ((p (open-input-file "day01.txt")))
    (let f ((x (read p)))
      (if (eof-object? x)
          (begin (close-input-port p)
                 '())
          (cons x (f (read p)))))))

(define (list-ref-mod lst pos)
  (list-ref lst (modulo pos (length lst))))

(define (find-repeated-freq input)
  (let search ((pos 0) (current 0) (seen (make-eqv-hashtable)))
    (let ((change (list-ref-mod input pos)))
      (let ((freq (+ current change)))
        (if (hashtable-contains? seen freq)
            freq
            (begin (hashtable-set! seen freq 'seen)
                   (search (add1 pos) freq seen)))))))

(printf "First puzzle answer: ~a~n" (apply + puzzle-input))
(printf "Second puzzle answer: ~a~n" (find-repeated-freq puzzle-input))
