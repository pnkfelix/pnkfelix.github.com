#!r6rs
;; Demonstrates the Collection/Queue/Tree object hierarchy implemented
;; in (obj-lecture collection-delegate), (obj-lecture queue1-delegate),
;; and (obj-lecture tree-delegate)
(import (obj-lecture collection-delegate)
        (except (obj-lecture queue1-delegate) isEmpty)
        (obj-lecture tree-delegate)
        (rnrs))

;; check : String Value -> Unspecified
;; displays a message and a value
(define (check msg val)
  (let* ((tgt-msg-length 20)
         (pad (make-string (max 0 (- tgt-msg-length
                                     (string-length msg)))
                           #\space))
         (msg+pad (string-append msg pad)))
    (display msg+pad)
    (write val)
    (newline)))

;; An empty Queue (which is also a Collection)
(define q1 (empty))
(check "{}:" 
       (toList q1))

;; A Queue with three elements
(define q2 (addElem (addElem (addElem q1 'a) 'b) 'c))
(check "{a b c}:" 
       (toList q2))
(check "{b c}:" 
       (toList (tail q2)))

;; An empty Tree 
(define t1 (empty))
(check "{}:" 
       (toList t1))

;; A Tree with five elements
(define t2 (node (node (leaf) (leaf) 'p)
                 (node (node (leaf) (leaf) 'q)
                       (node (leaf) (leaf) 'r)
                       's)
                 't))
(check "{p q r s t}:"
       (toList t2))
(check "t2 a leaf?"
       (isLeaf t2))
(check "t2.rgt leaf?"
       (isLeaf (right t2)))
(check "t2.lft leaf?"
       (isLeaf (left t2)))
(check "t2.lft.value:"
       (nodeValue (left t2)))
(check "t2.rgt as list:"
       (toList (right t2)))
(check "q2 and t2 as list:"
       (toList (addAll q2 t2)))
(check "t2 and q2 as list:"
       (toList (addAll t2 q2)))
