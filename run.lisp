"
Usage:

PORT=9999 sbcl --load run.lisp

This loads the project's asd, loads the quicklisp dependencies, and
starts the web server.

Then, we are given the lisp prompt: we can interact with the running application.

Another way to run the app is to build and run the executable (see README).
"

(load "myproject.asd")

(ql:quickload "myproject")

(in-package :myproject)
(handler-case
    (myproject:start :port (parse-integer (uiop:getenv "PORT")))
  (error (c)
    (format *error-output* "~&An error occured: ~a~&" c)
    (uiop:quit 1)))
