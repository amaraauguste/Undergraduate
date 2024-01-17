;1) Implement a function to check if a list is a palindrome.

(define (palindrome? s)
  (let ((chars (string->list s)))
    (equal? chars (reverse chars))))

;tests whether or not "radar" is a palindrome (it is so should return true)
(palindrome? "radar")
