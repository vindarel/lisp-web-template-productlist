(in-package :myproject)

(defvar *server* nil
  "Server instance (Hunchentoot acceptor).")

(defparameter *port* 8899
  "We can override it in the config file or from an environment variable.")

;;
;; Templates.
;;
(djula:add-template-directory
 (asdf:system-relative-pathname "myproject" "src/templates/"))
(defparameter +base.html+ (djula:compile-template* "base.html"))
(defparameter +welcome.html+ (djula:compile-template* "welcome.html"))
(defparameter +products.html+ (djula:compile-template* "products.html"))

;;
;; Routes.
;;
(easy-routes:defroute root ("/" :method :get) ()
  (djula:render-template* +welcome.html+ nil
                          :title "My great website"))

(easy-routes:defroute search-route ("/search" :method :get) (q)
  (let* ((products (search-products *products*
                                    (slug:asciify (str:downcase q)))))
    (djula:render-template* +products.html+ nil
                            :title (format nil "My website - ~a" q)
                            :query q
                            :products products
                            :no-results (zerop (length products)))))


;;
;; Start the web server.
;;
(defun start-server (&key (port *port*))
  (format t "~&Starting the web server on port ~a" port)
  (force-output)
  (setf *server* (make-instance 'easy-routes:easy-routes-acceptor
                                :port (or port *port*)))
  (hunchentoot:start *server*))

(export 'start)
(defun start (&key (port *port*) (load-init t))
  (if load-init
      (progn
        (format t "Loading init file...~&")
        (load-init))
      (format t "Skipping init file.~&"))
  (force-output)

  (format t "~&Loading the products...")
  (force-output)
  (get-products)
  (format t "~&Done.~&")
  (force-output)

  (start-server :port (or port *port*))
  (format t "~&Ready. You can access the application!~&")
  (force-output))
