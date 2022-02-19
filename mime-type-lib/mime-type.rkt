#lang racket/base

(require racket/contract
         racket/match
         racket/path
         racket/runtime-path
         racket/string)

(provide
 (contract-out
  [register-mime-type! (-> symbol? (or/c string? bytes?) void?)]
  [path-mime-type (-> (or/c path? path-string?) (or/c #f bytes?))]))

(define-runtime-path mime.types-path "mime.types")

(define types
  (let ([types (make-hasheqv)])
    (begin0 types
      (call-with-input-file mime.types-path
        (lambda (in)
          (for ([line (in-lines in)])
            (match line
              [(regexp #rx"^ *#") (void)]
              [(regexp #rx"^([^ ]+) +(.+)$" (list _ mime exts))
               (define mime-bs (string->bytes/utf-8 mime))
               (for ([ext (in-list (string-split exts))])
                 (hash-set! types (string->symbol ext) mime-bs))]
              [_
               (log-warning "mime-types: failed to parse line ~s" line)])))))))

(define (register-mime-type! ext mime)
  (hash-set! types ext (if (string? mime)
                           (string->bytes/utf-8 mime)
                           mime)))

(define (path-mime-type p)
  (define ext (path-get-extension p))
  (define ext-sym (and ext (string->symbol (bytes->string/utf-8 ext #f 1))))
  (hash-ref types ext-sym #f))
