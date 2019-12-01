(require :asdf)

(defun parse-line (line)
  (parse-integer line))

(defun parse-file (filename)
  (mapcar #'parse-line (uiop:read-file-lines filename)))

(defun fuel-required (module)
  (- (floor (/ module 3)) 2))

(defun solve-one (input)
  (reduce #'+ (mapcar #'fuel-required input)))

(defun fuel-updates (fuel)
  (let ((head (nth 0 fuel)))
    (let ((extra-fuel (fuel-required head)))
      (if (<= extra-fuel 0)
          fuel
          (fuel-updates (cons extra-fuel fuel))))))

(defun total-fuel-module (module)
  (let ((initial-fuel (fuel-required module)))
    (reduce #'+ (fuel-updates (list initial-fuel)))))

(defun solve-two (input)
  (reduce #'+ (mapcar #'total-fuel-module input)))

(let ((input (parse-file #p"day01.txt")))
  (format t "Part one: ~a~%" (solve-one input))
  (format t "Part two: ~a~%" (solve-two input)))
