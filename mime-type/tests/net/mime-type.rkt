#lang racket/base

(module+ test
  (require net/mime-type
           rackunit)

  (define-check (check-mime-table tbl)
    (for ([(p expected) (in-hash tbl)])
      (define res (path-mime-type p))
      (unless (equal? res expected)
        (fail-check (format "expected ~s but got ~s for ~s" expected res p)))))

  (check-mime-table
   (hash
    "a" #f
    "a/b" #f
    "a/b.html" #"text/html"
    "b.shtml" #"text/html"
    "test.mjs" #"text/javascript"
    "test.foo" #f))

  (register-mime-type! 'foo "application/foo")
  (check-equal? (path-mime-type "test.foo") #"application/foo"))
