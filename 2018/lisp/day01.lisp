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

(format t "First puzzle answer: ~A~%" (apply #'+ *puzzle-input*))
(format t "Second puzzle answer: ~A~%" (find-repeated-freq *puzzle-input* (make-hash-table) 0 0))
