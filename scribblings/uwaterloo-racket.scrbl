#lang scribble/manual
@require[@for-label[uwaterloo-racket/trace
                    racket/base]
         scribble/example racket/sandbox
         ]
@(define my-eval
   (parameterize ([sandbox-output 'string]
                  [sandbox-error-output 'string]
                  [sandbox-memory-limit 50])
     (make-evaluator 'racket)))

@title{UWaterloo Racket}
@author{djholtby}


Package Description Here

@section{The trace module}
@defmodule[uwaterloo-racket/trace]

Racket has a useful tracing tool.  Unfortunately it does not work in Beginning Student.
We have provided a wrapper to work around this issue.  To use it, you must add
@racket[(require uwaterloo-racket/trace)] to the top of your file (just below the header).

This allows you to use the @racket[define/trace] special form.

@defform[(define/trace (name param ...) body)
         ]{Behaves the same as @racket[define], but whenever the function @racket[name] is applied,
                               the values of its parameters will be printed to the screen.
 When the function produces a value, that value will also be printed.

 Examples:
            @examples[#:eval my-eval
                      (require uwaterloo-racket/trace)
                      (define/trace (f x)
                       (+ 2 x))
                      (f 2)]
            @examples[#:eval my-eval
                      (require uwaterloo-racket/trace)
                      (define/trace (sum-nums n)
                       (cond [(zero? n) 0]
                             [else (+ n (sum-nums (- n 1)))]))
                       (sum-nums 3)]} 
                                              

