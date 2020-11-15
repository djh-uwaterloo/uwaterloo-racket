#lang racket/base
(require drracket/tool
         racket/class
         racket/gui/base
         racket/unit
         framework
         string-constants
         mrlib/switchable-button)
(provide tool@)
 
(define tool@
  (unit
    (import drracket:tool^)
    (export drracket:tool-exports^)
 
    (define block-WXME-mixin
      (mixin (text:basic<%>) ()
 
        (inherit begin-edit-sequence
                 get-snip-position
                 set-position
                 find-snip
                 split-snip
                 end-edit-sequence
                 get-top-level-window
                 insert
                 delete
                 get-text)

        (define updating #f)   ; whether current insert is being done by the wxme->text code
        (define undoing #f)    ; whether current insert is being done by undo/redo
        (define paste-info #f) ; whether current insert is being done as part of a paste


        (define/public (ask-convert?)
          (cond
            [(preferences:get 'framework:ask-about-wxme-conversion)
             (define-values (mbr checked?)
               (message+check-box/custom
                (string-constant drscheme)
                "The string you inserted contains fractions or other non-text elements.\
  Convert them to text?"
                (string-constant dont-ask-again)
                "Convert to text"
                (string-constant leave-alone)
                #f
                (get-top-level-window)
                (cons (if (preferences:get 'framework:do-wxme-conversion)
                          'default=1
                          'default=2)
                      '(caution))
                2))
             (define convert? (not (equal? 2 mbr)))
             (preferences:set 'framework:ask-about-wxme-conversion (not checked?))
             (preferences:set 'framework:do-wxme-conversion convert?)
             convert?]
            [else
             (preferences:get 'framework:do-wxme-conversion)]))
        
        ;; copied from text-normalize-paste.  Seems to work
        (define (as-a-paste thunk)
          (dynamic-wind
           (λ () (set! paste-info #t))
           (λ ()
             (thunk)
             (define local-paste-info paste-info)
             (set! paste-info #f)
             (deal-with-paste local-paste-info))
           ;; use the dynamic wind to be sure that the paste-info is set back to #f
           ;; in the case that the middle thunk raises an exception
           (λ () (set! paste-info #f))))
    
        (define/override (do-paste start the-time)
          (as-a-paste (λ () (super do-paste start the-time))))
        
        (define/augment (after-insert start len)
          (inner (void) after-insert start len)
          ;; It didn't seem to work if I updated one snip at a time, so it just logs the whole
          ;; modified range and replaces the non-text snips in one pass
          (cond [(pair? paste-info)
                 (set! paste-info (cons (min (car paste-info) start)
                                        (max (cdr paste-info) (+ start len))))]
                [paste-info
                 (set! paste-info (cons start (+ start len)))]
                [(not updating) (check-range start (+ start len))]))


        (define/private (deal-with-paste local-paste-info)
          (when (pair? local-paste-info)
            (check-range (car local-paste-info) (cdr local-paste-info))))

        ;; (check-range start stop) replaces the snips from start to stop with
        ;;  a single string snip, converting number snips to plain text literals
        ;;  and replacign all other non-string snips with comments
        ;; If currently undoing / redoing, check-range does nothing (otherwise the undo/redo will
        ;;  convert the text twice, once here and then again as part of the chained edit sequence that
        ;;  this method already added
        
        ;; TODO: replace comment boxes with block comments?
        ;; check-range: Nat Nat -> Void
        (define/private (check-range start stop)
          (unless undoing
            (split-snip start)
            (split-snip stop)
            (let loop ([snip (find-snip start 'after-or-none)]
                       [new-text (open-output-string)]
                       [changed? #f])
              (cond [(or (not snip) (<= stop (get-snip-position snip)))
                     (when (and changed? (ask-convert?))
                       (let ([s (get-output-string new-text)])
                         (set! updating #t)
                         (send this add-undo
                               (lambda ()
                                 (set! undoing #f)
                                 #t))
                         (send this add-undo
                               (lambda ()
                                 (set! undoing #t)
                                 #t))
                         (begin-edit-sequence #f #t) ; these go before the change so that 
                         (delete start stop #f)      ; a redo is marked
                         (end-edit-sequence)
                         (begin-edit-sequence #t #f)
                         (set-position start stop)
                         (insert (get-output-string new-text) start 'same #f)
                         (end-edit-sequence)
                         (send this add-undo ; these go after the change, so an undo is marked
                               (lambda ()
                                 (set! undoing #t)
                                 #t))
                         (send this add-undo
                               (lambda ()
                                 (set! undoing #f)
                                 #t))
                         (set! updating #f)))]
                    [(is-a? snip string-snip%)
                     (display (send snip get-text 0 (send snip get-count)) new-text)
                     (loop (send snip next) new-text changed?)]
                    [else ; to any CS135 students reading this: else cond isn't always terrible 
                     (cond [(number-snip:is-number-snip? snip)
                            (write (number-snip:get-number snip) new-text)]
                           [else (fprintf new-text "#|Failed to insert ~v|#" snip)])
                     (loop (send snip next) ;; this also happens in the else ;)
                           new-text
                           #t)]))))
 
        (super-new)))
 
    
 
    
 
    
 
    (define (phase1) (void))
    (define (phase2) (void))
    (preferences:set-default 'framework:ask-about-wxme-conversion #f boolean?)
    (preferences:set-default 'framework:do-wxme-conversion #t boolean?)
    (preferences:add-to-editor-checkbox-panel
     (λ (editor-panel)
       (preferences:add-check editor-panel
                              'framework:ask-about-wxme-conversion
                              "Ask before converting graphics to plain text")
       (preferences:add-check editor-panel
                              'framework:do-wxme-conversion
                              "Convert graphics to plain text")))
 
    (drracket:get/extend:extend-definitions-text block-WXME-mixin)))
