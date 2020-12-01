(defparameter *puzzle-input*
  (let ((lines (with-open-file (infile "day01.txt")
                               (loop for line = (read-line infile nil)
                                     while line
                                     collect line))))
    (mapcar #'parse-integer lines)))

(defun list-ref-mod (lst pos)
  (nth (mod pos (length lst)) lst))

(defun find-repeated-freq (input seen pos current)
  (let ((freq (+ current (list-ref-mod input pos))))
    (cond ((gethash freq seen) freq)
          (T (setf (gethash freq seen) 'seen)
             (find-repeated-freq input seen (+ pos 1) freq)))))

(with-open-file (puzzle-input "day01.txt")
  (let ((lines (loop for line = (read-line puzzle-input nil) while line collect line)))
    (let ((numbers (mapcar #'parse-integer lines)))
      (format t "First puzzle answer: ~A~%" (apply #'+ numbers))
      (format t "Second puzzle answer: ~A~%" (find-repeated-freq numbers (make-hash-table) 0 0)))))
