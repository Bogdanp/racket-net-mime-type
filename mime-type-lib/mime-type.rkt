#lang racket/base

(require racket/contract/base
         racket/match
         racket/path
         racket/runtime-path
         racket/string)

(provide
 (contract-out
  [register-mime-type! (-> symbol? (or/c string? bytes?) void?)]
  [path-mime-type (-> (or/c path? path-string?) (or/c #f bytes?))]
  [mime-type-ext (-> (or/c string? bytes?) (or/c #f symbol?))]))

(define-runtime-path mime.types-path
  "mime.types")

(define types
  (let ([types (make-hasheqv)])
    (begin0 types
      (call-with-input-file mime.types-path
        (lambda (in)
          (for ([line (in-lines in)])
            (match line
              [(regexp #rx"^ *$") (void)]
              [(regexp #rx"^ *#") (void)]
              [(regexp #rx"^([^ ]+) +(.+)$" (list _ mime exts))
               (define mime-bs (string->bytes/utf-8 mime))
               (for ([ext (in-list (string-split exts))])
                 (hash-set! types (string->symbol ext) mime-bs))]
              [_
               (log-warning "mime-types: failed to parse line ~s" line)])))))))

(define mimes
  (let ([mimes (make-hash)])
    (begin0 mimes
      (for ([(ext mime) (in-hash types)])
        (hash-set! mimes mime ext)))))

(define (register-mime-type! ext mime)
  (let ([mime (->bytes mime)])
    (hash-set! types ext mime)
    (hash-set! mimes mime ext)))

(define (path-mime-type p)
  (define ext (path-get-extension p))
  (define ext-sym (and ext (string->symbol (bytes->string/utf-8 ext #f 1))))
  (hash-ref types ext-sym #f))

(define (mime-type-ext mime)
  (hash-ref mimes (->bytes mime) #f))

(define (->bytes mime)
  (if (string? mime)
      (string->bytes/utf-8 mime)
      mime))
