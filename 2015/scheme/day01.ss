(import :std/iter
        :std/misc/ports
        :std/test)

(def puzzle-input (read-file-string "day01.in"))

;; Santa is trying to deliver presents in a large apartment building, but he
;; can't find the right floor - the directions he got are a little confusing.
;; He starts on the ground floor (floor 0) and then follows the instructions
;; one character at a time.
;; 
;; An opening parenthesis, (, means he should go up one floor, and a closing
;; parenthesis, ), means he should go down one floor.
;; 
;; The apartment building is very tall, and the basement is very deep; he will
;; never find the top or bottom floors.
;; 
;; For example:
;; 
;;     (()) and ()() both result in floor 0.
;;     ((( and (()(()( both result in floor 3.
;;     ))((((( also results in floor 3.
;;     ()) and ))( both result in floor -1 (the first basement level).
;;     ))) and )())()) both result in floor -3.

;; To what floor do the instructions take Santa?
(def chars (string->list puzzle-input))

(def (char->update char)
    (cond ((eq? char #\() 1)
          ((eq? char #\)) -1)
          (else 0)))

(def (solve-one puzzle-input)
  (apply + (map char->update chars)))

(check-eq? (solve-one puzzle-input) 138)
; Now, given the same instructions, find the position of the first character
; that causes him to enter the basement (floor -1). The first character in the
; instructions has position 1, the second character has position 2, and so on.

; For example:

;    ) causes him to enter the basement at character position 1.
;    ()()) causes him to enter the basement at character position 5.

; What is the position of the character that causes Santa to first enter the
; basement?
(def (solve-two puzzle-input)
  (let loop ((floor 0)
             (index 0))
    (if (< floor 0)
      index
      (loop
       (+ floor (char->update (string-ref puzzle-input index)))
       (+ index 1)))))

(check-eq? (solve-two puzzle-input) 1771)
