#lang info

(define collection "graphic-block")
(define deps '("drracket-plugin-lib"
               "gui-lib"
               "string-constants-lib"
               "base"))
(define build-deps '("scribble-lib" "racket-doc"))

;(define scribblings '(("scribblings/uwaterloo-racket.scrbl" ())))
(define pkg-desc "Plugin that adds settings to prevent insertion of non-string snips into editor files")
(define version "0.0")
(define pkg-authors '(djholtby))


(define drracket-tool-names (list "Graphic Blocker"))
(define drracket-tools (list (list "graphic-block.rkt")))
