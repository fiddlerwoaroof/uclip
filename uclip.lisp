;;;; uclip.lisp

(in-package #:uclip)



(defvar *current-clipboard*)
(defun init ()
  (restore 'uclip) 
  (setf *current-clipboard* (defaulted-value "main" 'current-clipboard)))

(defun copy (argv)
  (init)
  (push (cond ((null (cdr argv))
               (apply #'concatenate
                      (list* 'string
                             (loop for a := (read-line *standard-input* nil)
                                   while (not (null a))
                                   collect (format nil "~a~%" a)))))
              (t (format nil "~{~a~^ ~}" (cdr argv))))
        (value 'clipboard *current-clipboard*)))

(defun paste (argv)
  (init) 
  (let ((*current-clipboard*
          (if (cdr argv) (cadr argv) *current-clipboard*)))
    (awhen (car (value 'clipboard *current-clipboard*))
      (format t "~a" it))))

(defun tee (argv)
  (copy argv)
  (paste nil))

(defun switch-clipboards (argv)
  (init) 
  (setf *current-clipboard*
        (setf (value 'current-clipboard) (cadr argv))))

(defun pop-clipboard (argv)
  (declare (ignore argv))
  (init) 
  (when (value 'clipboard *current-clipboard*)
    (format t "~a" (pop (value 'clipboard *current-clipboard*)))))

(defun show-clipboard-contents (argv)
  (init)
  (let*  ((*current-clipboard* (aif (cdr argv) (car it) *current-clipboard*))
          (current-clipboard (value 'clipboard *current-clipboard*))
          (cc-length (length current-clipboard))
          (show-length (min cc-length
                            (or (awhen (cddr argv) (parse-integer (car it) :junk-allowed t))
                                5)))
          (current-clipboard (subseq current-clipboard 0 show-length)))
    (when (> cc-length 0)
      (format t "~&~{~a~&~^---~%~}" current-clipboard))))

(defun list-clipboards (argv)
  (init)
  (format t "~&~{~a~%~}" (hash-table-keys (value 'clipboard))))

(defun clear-clipboard (argv)
  (declare (ignore argv))
  (init)
  (setf (value 'clipboard *current-clipboard*) nil))
