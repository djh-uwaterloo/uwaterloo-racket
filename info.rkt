#lang info

(define collection "uwaterloo-racket")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/uwaterloo-racket.scrbl" ())))
(define pkg-desc "University of Waterloo Racket plugins and libraries")
(define version "0.0")
(define pkg-authors '(djholtby))


(define drracket-tool-names (list "Graphic Blocker"))
(define drracket-tools (list (list "graphic-block.rkt")))

