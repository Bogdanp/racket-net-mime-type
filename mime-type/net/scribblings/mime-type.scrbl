#lang scribble/manual

@(require (for-label net/mime-type
                     racket/base
                     racket/contract))

@title{MIME Types}
@author[(author+email "Bogdan Popa" "bogdan@defn.io")]
@defmodule[net/mime-type]

This module provides utilities for working with MIME types.  Its MIME
type table is based on the table that the Nginx web server uses by
default.

@defproc[(path-mime-type [p path?]) (or/c #f bytes?)]{
  Given a path @racket[p], this function looks up the MIME type for
  that path (based on its extension) and returns it.
}

@defproc[(register-mime-type! [ext symbol?]
                              [mime (or/c string? bytes?)]) void?]{

  Adds @racket[mime] as the mime type for @racket[ext] in the global
  MIME type table.  Replaces any existing entries for @racket[ext].
}

@defproc[(mime-type-ext [mime (or/c string? bytes?)]) (or/c #f symbol?)]{
  Returns the extension symbol for the given @racket[mime], if known.

  @history[#:added "1.1"]
}
