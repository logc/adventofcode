(import :std/format
        :std/misc/ports)

(define contents (map string->number (read-file-lines "day01.txt")))

(define (sum a-list) (apply + a-list))

(define (less-than-two? a-list)
  (< (length a-list) 2))

(define (count-positive-diffs depths diffs)
  (cond ((less-than-two? depths) (sum diffs))
        (else (let ((pair (take depths 2)))
                (let ((diff (apply - (reverse pair))))
                  (if (> diff 0)
                    (count-positive-diffs (cdr depths) (cons 1 diffs))
                    (count-positive-diffs (cdr depths) (cons 0 diffs))))))))
(displayln (format "Puzzle 1: ~a~n" (count-positive-diffs contents '())))
