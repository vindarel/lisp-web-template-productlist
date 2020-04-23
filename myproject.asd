(asdf:defsystem "myproject"
  :version "0.1"
  :author ""
  :license "WTFPL"
  :depends-on (:str
               :cl-slug
               :local-time
               :cl-ppcre
               :hunchentoot
               :easy-routes
               :djula
               :log4cl)
  :components ((:module "src"
                :components
                ((:file "myproject")
                 (:file "web"))))

  ;; To build a binary:
  :build-operation "program-op"
  :build-pathname "myproject"
  :entry-point "myproject::main"

  :description "A web template"
  ;; :long-description
  ;; #.(read-file-string
  ;;    (subpathname *load-pathname* "README.md"))
  :in-order-to ((test-op (test-op "myproject-test"))))

;; Smaller binary.
#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))
