#lang racket/base
(require drracket/tool
         racket/class
         racket/gui/base
         racket/unit
         framework
         mrlib/switchable-button)
(provide tool@)
 
(define tool@
  (unit
    (import drracket:tool^)
    (export drracket:tool-exports^)
 
    (define block-WXME-mixin
      (mixin ((class->interface text%)) ()
 
        (inherit begin-edit-sequence
                 get-snip-position
                 set-position
                 find-snip
                 split-snip
                 end-edit-sequence
                 insert
                 delete
                 get-text)

        (define updating #f)
        
        (define/augment (on-insert start len)
          ;(eprintf "(on-insert ~a ~a)  (in-edit-sequence?) => ~a\n" start len (send this in-edit-sequence?))
          (inner (void) on-insert start len))
        
                
        (define/augment (after-insert start len)
          (inner (void) after-insert start len)
          (unless updating (check-range start (+ start len)))
		         
          )
        
        #|(define/augment (on-delete start len)
          (begin-edit-sequence))
        (define/augment (after-delete start len)
          (check-range (max 0 (- start (string-length secret-key)))
                       start)
          (end-edit-sequence))|#
        
        (define undoing #f)
        (define/private (check-range start stop)
          (split-snip start)
          (split-snip stop)
          (let loop ([snip (find-snip start 'after-or-none)]
                     [new-text (open-output-string)]
                     [changed? #f])
            (cond [(or (not snip) (<= stop (get-snip-position snip)))
				   
                   (when (and changed? (not undoing))
                     (let ([s (get-output-string new-text)])
                       ;(eprintf "Base case : ~v [~v:~v]\n" s start stop)
                   
                       (set! updating #t)
                       (begin-edit-sequence #t #f)
                       ;(set-position start stop)
                       ;(send this undo)
                       ;(delete start stop)
                       ;(end-edit-sequence)
                       ;(begin-edit-sequence #t #f)
                       ;(set-position start stop)
                       (insert (get-output-string new-text) start stop #f)
                       (end-edit-sequence)
                       (send this add-undo (lambda ()
                                            ; (begin-edit-sequence #f #f)
											
											 ;(delete start (+ start (string-length s)))
                                             ;(insert (make-string (- stop start) #\space) start (+ start (string-length s)));(delete start stop #f)
                                             ;(end-edit-sequence)
											 (set! undoing #t)
                                             #t))

                       (set! updating #f)
                       )
                     )
					 (set! undoing #f)
                   ]
                  [(is-a? snip string-snip%)
                   (display (send snip get-text 0 (send snip get-count)) new-text)
                   (loop (send snip next) new-text changed?)]
                  [else
                   (cond [(number-snip:is-number-snip? snip)
                          (write (number-snip:get-number snip) new-text)]
                         [else (fprintf new-text "#|Failed to insert ~v|#" snip)])
                   (loop (send snip next)
                         new-text
                         #t)])))
 
        (super-new)))
 
    
 
    
 
    
 
    (define (phase1) (void))
    (define (phase2) (void))
 
    (drracket:get/extend:extend-definitions-text block-WXME-mixin)))
