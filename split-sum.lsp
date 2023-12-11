(defun split-sum (nums)
  (let ((totalLeft 0)
        (totalRight 0)
        (left 0)
        (right (1- (length nums))))

    ;; Empty array, or single element array.
    (if (< right 1)
        (return-from split-sum (list '() '())))

    ;; Sum until the indexes meet in the middle.
    (loop do (progn
      (if (<= totalLeft totalRight)
          (progn
            (setq totalLeft (+ totalLeft (nth left nums)))
            (setq left (+ left 1)))
          (progn
            (setq totalRight (+ totalRight (nth right nums)))
            (setq right (- right 1)))))
      until (= left right))

    ;; Check middle in left group.
    (if (= (+ totalLeft (nth left nums)) totalRight)
        (return-from split-sum (list (subseq nums 0 (1+ left)) (subseq nums (1+ right)))))

    ;; Check middle in right group.
    (if (= totalLeft (+ totalRight (nth right nums)))
       (return-from split-sum (list (subseq nums 0 left) (subseq nums right))))

    (return-from split-sum (list '() '()))
    ))


;; Test cases
(defun test-cases (to-screen)
   (defvar cases '(()
                 (100)
                 (99 99)
                 (98 1 99)
                 (99 1 98)
                 (1 2 3 0)
                 (1 2 3 5)
                 (1 2 2 1 0)
                 (10 11 12 16 17)
                 (1 1 1 1 1 1 6)
                 (6 1 1 1 1 1 1)))
    (dolist (c cases)
      (if to-screen
          (format t "lisp: ~A -> ~A~%" c (split-sum c))
          (split-sum c)
)))

(test-cases t)

(setq start (get-internal-real-time))
(dotimes (i 1000000) (test-cases nil))
(setq end (get-internal-real-time))

(format t "lisp: ~3$ seconds" (float (/ (- end start) internal-time-units-per-second)))
