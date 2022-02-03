;; Product objects must have:
;; - id
;; - title
;; - author
;; - price
;; - cover image url
;; - shelf
;;

(defpackage myproject
  (:use :cl
        :log4cl))

(in-package :myproject)

(defparameter *config-file* "~/.myproject.lisp"
  "lispy configuration file. Loaded with `load-init'.")
(defparameter *version* "0.1")
(defparameter *verbose* nil)

(defvar *products* nil
  "List of all products.")


(defun load-init ()
  "Read the configuration variables (contact information,…) from the `*config-file*'."
  (let ((file (uiop:native-namestring *config-file*)))
    (let ((*package* *package*))
      (in-package myproject)
      (load file))))

;;
;; Get products.
;;
(defun get-products ()
  "Get all products from somewhere."
  (setf *products*
        (loop for i upto 10
           collect (list
                    :|id| i
                    :|title| (format nil "Product ~a" i)
                    :|price| 19.99
                    :|category| "category"
                    :|cover| "https://via.placeholder.com/150")))
  *products*)


;;
;; Search products.
;;
(defun search-products (products query)
  "`products': plist,
   `query': string."
  ;XXX: type declarations and type checking.
  (let* (;; Filter by title and author(s).
         (result (if (not (str:blank? query))
                     ;; no-case: strips internal contiguous whitespace, removes accents
                     ;; and punctuation.
                     (let* ((query (slug:asciify query))
                            (query (str:replace-all " " ".*" query)))
                       ;; Here a DB lookup.
                       (loop for product in products
                          for repr = (str:downcase (getf product :|title|))
                          when (ppcre:scan query repr)
                          collect product))
                     products)))
    (log:info "Searched '~a' and found ~a results.~&" query (length result))
    (values result
            (length result))))

(defun main ()
  "Entry point of the executable."
  (handler-case
      (progn
        (start)
        ;; Put the webserver thread on the foreground
        ;; (otherwise the app shuts down immediately).
        (bt:join-thread
         (find-if (lambda (th)
                    (search "hunchentoot" (bt:thread-name th)))
                  (bt:all-threads))))
    (sb-sys:interactive-interrupt () (progn
                                       (format *error-output* "User abort. Bye!~&")
                                       (uiop:quit)))
    (error (c) (format *error-output* "~&An error occured: ~A~&" c))))
