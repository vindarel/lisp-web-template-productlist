
# Build a binary.
build:
	sbcl --load myproject.asd \
	     --eval '(ql:quickload :myproject)' \
	     --eval '(asdf:make :myproject)' \
	     --eval '(quit)'
