#lang racket/base

(require racket/trace (for-syntax racket/base))
(provide define/trace)

(define-syntax (define/trace stx)
  (syntax-case stx ()
    [(_ (f) body extra-part ...) ;; put this first since arg ... means 0 or more
     (raise-syntax-error 'define/trace
                         "expected at least one variable after the function name, but found none"
                         stx)]
    [(_ (f arg ...) body)
     (with-syntax
         ; break hygiene to snag define from the current lexical context
         ([student-define (datum->syntax stx 'define)]
         ; generate a fake name for the real function.  temporaries are always distinct
          [(f1) (generate-temporaries #'(f))])
       (syntax/loc stx
         (begin
          (define f1 (letrec ([f (λ (arg ...) body)])
                       (trace f)
                       f))
          (student-define (f arg ...) (f1 arg ...)))))]
    [(_ name value) ; if they try to use it to define a constant
     (raise-syntax-error 'define/trace "define/trace can only be used to define functions" stx)]
    [(_ arg ...) ; other cases it just maps to a define so that that syntax can raise its own errors
     (with-syntax ([student-define (datum->syntax stx 'define)])
       (syntax/loc stx
         (student-define arg ...)))]
    [_
     (raise-syntax-error 'define/trace
                         "expected an open parenthesis before define/trace, but found none"
                         stx)]))

