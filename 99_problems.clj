(ns problems.99-problems)

(defn last [coll]
  (when (not-empty coll)
    (loop [coll coll]
      (let [head (first coll)
            tail (rest coll)]
        (if (empty? tail)
          (list head)
          (recur tail))))))

(comment
  (last [1 2 3]))

(defn last-two [coll]
  (when (not-empty (rest coll))
    (loop [head (first coll)
           tail (rest coll)]
      (let [h2 (first tail)
            t2 (rest tail)]
        (if (empty? t2)
          (list head h2)
          (recur h2 t2))))))

(comment
  (last-two nil)
  (last-two [1])
  (last-two '(1 2))
  (last-two [1 2 3 4])
  (last-two '(1 2 3 4)))

(defn kth [coll k]
  (when (not-empty coll)
    (if (zero? k)
      (first coll)
      (recur (rest coll) (dec k)))))

(comment
  (kth [1 2 3] 0)
  (kth nil 1)
  (kth '(1 2 3) 2)
  (kth [1 2 3] 4))

(defn len [coll]
  (loop [coll coll
         l    0]
    (if (empty? coll)
      l
      (recur (rest coll) (inc l)))))

(comment
  (len nil)
  (len '())
  (len [1 2]))

(defn reverse [coll]
  (loop [in  coll
         out '()]
    (if (empty? in)
      out
      (recur (rest in) (conj out (first in))))))

(comment
  (reverse [])
  (reverse [1])
  (reverse [1 2])
  (reverse '(1 2 3 1)))

(defn palindrome? [coll]
  (= coll (reverse coll)))

(comment
  (palindrome? [1 2 3 2 1])
  (palindrome? '(1 2 1))
  (palindrome? nil)
  (palindrome? []))

(defn flatten [coll]
  (if (empty? coll)
    '()
    (if (coll? (first coll))
      (concat (flatten (first coll)) (flatten (rest coll)))
      (cons (first coll) (flatten (rest coll))))))

(comment
  (flatten [1 '(2 3 [3 4 5])]))

(defn compress [coll]
  (when (not-empty coll)
    (loop [in   (rest coll)
           seen (first coll)
           ret  (list (first coll))]
      (if (empty? in)
        (reverse ret)
        (recur (rest in)
               (first in)
               (if (= seen (first in))
                 ret
                 (cons (first in) ret)))))))
(comment
 (compress [1 2 2 2 3 3 1 2 3]))

