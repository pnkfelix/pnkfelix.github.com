#!r6rs
;; This file defines an abstract Collection "class"
(library (obj-lecture collection-delegate)
  (export base-collection isEmpty addElem anyElem addAll toList)
  (import (rnrs base))

  ;; A Collection is a (Msg -> Procedure)
  ;; where Msg is one of:
  ;; - 'is-empty        => (Self -> Boolean)
  ;; - 'add-elem        => (Self * Value -> Collection)
  ;; - 'some-elem       => (Self -> (list Value Collection))
  ;; - 'add-all-elems   => (Self * Collection -> Collection)
  ;; - 'to-list         => (Self -> Listof[Value])

  ;; In this file, Collection is only partially 
  ;; implemented (the concrete method implementations
  ;; are for add-all-elems and to-list).  It is the 
  ;; responsbility of our subclasses to supply the 
  ;; remaining three method implementations.

  (define (isEmpty c)   ((c 'is-empty)  c))
  (define (addElem c v) ((c 'add-elem)  c v))
  (define (anyElem c)   ((c 'some-elem) c))
  (define (addAll c c2) ((c 'add-all-elems) c c2))
  (define (toList c)    ((c 'to-list) c))

  ;; concrete->object : -> Collection
  ;; abstract constructor for making a new collection
  (define (concrete->object)
    (lambda (sym)
      (cond
        ((eq? sym 'add-all-elems)
         add-all-elems-impl)
        ((eq? sym 'to-list)
         to-list-impl)
        (else
         (error 'unimplemented-message (symbol->string sym))))))

  ;; base-collection : -> Collection
  (define (base-collection)
    (concrete->object))

  ;; add-all-elems-impl : Self Collection -> Collection
  (define (add-all-elems-impl self other-collection)
    (if (isEmpty other-collection)
        self
        (let* ((val-and-other-rest (anyElem other-collection))
               (val           (list-ref val-and-other-rest 0))
               (other-rest    (list-ref val-and-other-rest 1)))
          (addAll (addElem self val) other-rest))))

  ;; to-list-impl : Self -> Listof[Value]
  (define (to-list-impl self)
    (if (isEmpty self)
        '()
        (let* ((val-and-other-rest          (anyElem self))
               (val        (list-ref val-and-other-rest 0))
               (other-rest (list-ref val-and-other-rest 1)))
          (cons val (toList other-rest))))))
