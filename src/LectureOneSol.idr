-- ---------------------------------------------------------- [ LectureOne.idr ]
-- Module      : LectureOneSol
-- Description : Exercises for Lecture One
-- Copyright   : (c) The Idris Community 2014
-- License     : see LICENSE
-- --------------------------------------------------------------------- [ EOH ]
module LectureOneSol

-- -------------------------------------------------------------- [ Question 1 ]
--
-- Implement the following function which constructs a vector that
-- contains n copies of a given item.

vrepeat : (n : Nat) -> a -> Vect n a
vrepeat Z     _ = [] 
vrepeat (S n) x = x :: vrepeat n x

-- -------------------------------------------------------------- [ Question 2 ]
--
-- Implement the following functions.
--
-- Do the types tell you enough to suggest what they should do?
--
vtake : (n : Nat) -> Vect (n + m) a -> Vect n a
vtake Z     xs      = []
vtake (S k) (x::xs) = x :: (vtake k xs)

vdrop : (n : Nat) -> Vect (n + m) a -> Vect m a
vdrop Z     xs      = xs
vdrop (S k) (x::xs) = vdrop k xs

-- -------------------------------------------------------------- [ Question 3 ]
--
-- A matrix is a 2-dimensional vector, and could be defined as follows:
--
Matrix :  Nat -> Nat -> Type -> Type
Matrix n m a = Vect n (Vect m a)

-- --------------------------------------------------------------------- [ Q3a ]
-- Using vrepeat (above) and Vect.zipWith, write a function which
-- transposes a matrix.
--
-- Hints: Remember to think carefully about its type first! zipWith
-- for vectors is defined as follows:
--
--    zipWith : (a -> b -> c) -> Vect a n -> Vect b n -> Vect c n
--    zipWith f []      []      = []
--    zipWith f (x::xs) (y::ys) = f x y :: zipWith f xs ys
--

transpose : Matrix n m a -> Matrix m n a
transpose {m} [] = vrepeat m []
transpose (xs :: xss) = zipWith (::) xs (transpose xss)

-- --------------------------------------------------------------------- [ Q3b ]
--
-- Write a function to multiply two matrices.


-- ---------------------------------------------------------------------- [ Q4 ]
--
-- The following view describes a pair of numbers as a difference:
--
data Cmp : Nat -> Nat -> Type where
  cmpLT : (y : _) -> Cmp x (x + S y)
  cmpEQ : Cmp x x
  cmpGT : (x : _) -> Cmp (y + S x) y

-- --------------------------------------------------------------------- [ Q4a ]
--
-- Implement the following function which proves that every pair of
-- numbers can be expressed in this way.

-- Hint: recall parity from the lecture. You will find the with
-- construct very useful!
--
cmp : (n:Nat) -> (m:Nat) -> Cmp n m
cmp Z Z = cmpEQ
cmp Z (S n) = cmpLT n
cmp (S n) Z = cmpGT n
cmp (S n) (S m) with (cmp n m)
  cmp (S n) (S (n + S d)) | cmpLT d = cmpLT d
  cmp (S n) (S n)         | cmpEQ = cmpEQ
  cmp (S (m + S d)) (S m) | cmpGT d = cmpGT d


-- --------------------------------------------------------------------- [ Q4b ]
--
-- Assume you have a vector xs : Vect a n, where n is unknown. How
-- could you use cmp to construct a suitable input to vtake and vdrop
-- from xs?

-- ---------------------------------------------------------------------- [ Q5 ]
--
-- Implement the following functions:
--
plus_nSm : (n : Nat) -> (m : Nat) -> n + S m = S (n + m)
plus_nSm Z m = refl
plus_nSm (S n) m =
  let ih = plus_nSm n m in ?plus_nSm_step


plus_commutes : (n : Nat) -> (m : Nat) -> n + m = m + n
plus_commutes Z m = ?plus_commutes_base
plus_commutes (S n) m =
  let ih = plus_commutes n m in ?plus_commutes_step


plus_assoc : (n : Nat) -> (m : Nat) -> (p : Nat) ->
             n + (m + p) = (n + m) + p
plus_assoc Z m p = refl
plus_assoc (S n) m p =
  let ih = plus_assoc n m p in ?plus_assoc_step


-- ---------------------------------------------------------------------- [ Q6 ]
--
-- One way to define a reverse function for lists is as follows:

reverse : List a -> List a
reverse xs = revAcc [] xs
             where
               revAcc : List a -> List a -> List a
               revAcc acc [] = acc
               revAcc acc (x :: xs) = revAcc (x :: acc) xs

-- Write the equivalent function for vectors.
--
-- Hint: You can use the same structure as the definition for List,
-- but you will need to think carefully about the type for revAcc, and
-- may need to do some theorem proving.

vreverse : Vect a n -> Vect a n
vreverse = ?vreverseBody

-- ---------------------------------------------------------------------- [ Q7 ]
--
-- You are given the following definition of binary trees:

data Tree a = Leaf | Node (Tree a) a (Tree a)

-- Define a membership predicate ElemTree and a function elemInTree
-- which calculates whether a value is in the tree, and a
-- corresponding proof.

data ElemTree : a -> Tree a -> Type where
  {} -- constructors

elemInTree : DecEq a => (x : a) -> (t : Tree a) -> Maybe (ElemTree x t)
elemInTree = ?elemInTreeBody

-- --------------------------------------------------------------------- [ EOF ]

---------- Proofs ----------

LectureOneSol.plus_assoc_step = proof
  intros
  rewrite ih
  trivial

LectureOneSol.plus_commutes_step = proof
  intros
  rewrite (plusSuccRightSucc m n)
  rewrite ih
  trivial


LectureOneSol.plus_commutes_base = proof
  intros
  rewrite sym (plusZeroRightNeutral m)
  trivial


LectureOneSol.plus_nSm_step = proof
  intros
  rewrite ih
  trivial


  

