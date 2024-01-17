;2) Merge two sorted lists into one sorted list. You can assume both input lists are sorted in ascending order

(define (merge lst1 lst2)
  (cond ((null? lst1) lst2)
        ((null? lst2) lst1)
        ((>= (car lst1) (car lst2))
         (cons (car lst2) (merge lst1 (cdr lst2))))
        (else
         (cons (car lst1) (merge (cdr lst1) lst2)))))

;tests merge, should display lists into one sorted listed in ascending order
(merge '(1 3 4) '(2 5 6))