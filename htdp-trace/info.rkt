#lang info

(define collection "htdp-trace")
(define deps '("base"))
(define build-deps '("sandbox-lib"
                     "scribble-lib" "racket-doc"))

(define scribblings '(("scribblings/htdp-trace.scrbl")))
(define pkg-desc "Wrapper for racket/trace that allows it to be used in Beginning Student (HtDP)")
(define version "0.0")
(define pkg-authors '(djholtby))
