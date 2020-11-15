#lang scribble/manual
@require[@for-label[htdp-trace
                    racket/base]
         scribble/example racket/sandbox
         ]
@(define my-eval
   (parameterize ([sandbox-output 'string]
                  [sandbox-error-output 'string]
                  [sandbox-memory-limit 50])
     (make-evaluator 'racket)))

@title{HTDP Trace}
@author{djholtby}


@defmodule[htdp-trace]

Racket has a useful tracing tool.  Unfortunately it does not work in Beginning Student.
This package provides a wrapper that can be used in the HtDP Languages.

@defform[(define/trace (name param ...) body)
         ]{Behaves the same as @racket[define], but whenever the function @racket[name] is applied,
                               the values of its parameters will be printed to the screen.
 When the function produces a value, that value will also be printed.

            @examples[#:eval my-eval #:no-prompt
                      (require htdp-trace)
                      (define/trace (f x)
                       (+ 2 x))
                      (f 2)
                      
                      (define/trace (sum-nums n)
                       (cond [(zero? n) 0]
                             [else (+ n (sum-nums (- n 1)))]))
                       (sum-nums 3)]} 
                                              

