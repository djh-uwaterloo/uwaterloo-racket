# University of Waterloo Racket Tools

## Graphic Block

Dr.Racket allows non-text elements to be embedded in Racket files.  
Unfortunately this format is in constant flux, so it's not possible
to automatically convert this graphical format to plain text so that the code can be run 
by our testing servers (or read by the TAs doing hand marking).  This is because the servers
are always much behind the students in terms of which version of Racket they are running.

The graphic-block plug-in for Dr.Racket blocks the user from pasting this content.  This can be 
toggled in the user's settings.

## HTDP Trace

Racket has a useful tracing tool.  Unfortunately it does not work in Beginning Student.
This package provides a wrapper that can be used in the HtDP Languages.

To use it, `(require htdp-trace)`

Examples:
```
(define/trace (f x)
 (+ 2 x))
(f 2)
>(f 2)
<4
4


(define/trace (sum-nums n)
 (cond [(zero? n) 0]
       [else (+ n (sum-nums (- n 1)))]))
(sum-nums 3)
>(sum-nums 3)
> (sum-nums 2)
> >(sum-nums 1)
> > (sum-nums 0)
< < 0
< <1
< 3
<6
6
```


