
# Build a binay.
build:
	sbcl --load myproject.asd \
	     --eval '(ql:quickload :myproject)' \
	     --eval '(asdf:make :myproject)' \
	     --eval '(quit)'
