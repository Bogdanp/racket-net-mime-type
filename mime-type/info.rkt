#lang info

(define collection 'multi)
(define version "1.0")
(define deps
  '("base"
    "mime-type-lib"))
(define build-deps
  '("base"
    "mime-type-lib"
    "racket-doc"
    "rackunit-lib"
    "scribble-lib"))
(define implies
  '("mime-type-lib"))
