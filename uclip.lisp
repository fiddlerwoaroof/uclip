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
  (declare (ignore argv))
  (init) 
  (let ((*current-clipboard*
          (if (cdr argv) (cadr argv) *current-clipboard*)))
    (awhen (car (value 'clipboard *current-clipboard*))
      (format t "~a" it))))

(defun switch-clipboards (argv)
  (init) 
  (setf *current-clipboard*
        (setf (value 'current-clipboard) (cadr argv))))

(defun pop-clipboard (argv)
  (declare (ignore argv))
  (init) 
  (when (value 'clipboard *current-clipboard*)
    (format t "~a" (pop (value 'clipboard *current-clipboard*)))))
