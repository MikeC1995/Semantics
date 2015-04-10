-- Language Engineering
-- Denotational Semantics
-- CWK2

import Prelude hiding (lookup)

-- Type Definitions (Given)

data Aexp = N Integer | V Var | Add Aexp Aexp | Mult Aexp Aexp | Sub Aexp Aexp  deriving (Show)
data Bexp = TRUE | FALSE | Eq Aexp Aexp | Le Aexp Aexp | Neg Bexp | And Bexp Bexp   deriving (Show)
data Stm  = Ass Var Aexp | Skip | Comp Stm Stm | If Bexp Stm Stm | While Bexp Stm | Block DecV DecP Stm | Call Pname    deriving (Show)

type Var = String
type Pname = String
type DecV = [(Var,Aexp)]
type DecP = [(Pname,Stm)]

type Z = Integer
type T = Bool
type State = Var -> Z
type Loc = Z
type Store = Loc -> Z
type EnvV = Var -> Loc
type EnvP = Pname -> Store -> Store

next = 0

-- Semantic Functions (Copied from parts 1 and 2 of the coursework)

a_val :: Aexp -> State -> Z
a_val (N n) s = n
a_val (V x) s = s x
a_val (Add a1 a2) s = (a_val a1 s) + (a_val a2 s)
a_val (Sub a1 a2) s = (a_val a1 s) - (a_val a2 s)
a_val (Mult a1 a2) s = (a_val a1 s) * (a_val a2 s)

b_val :: Bexp -> State -> T
b_val TRUE s = True
b_val FALSE s = False
b_val (Eq a1 a2) s = (a_val a1 s) == (a_val a2 s)
b_val (Le a1 a2) s = (a_val a1 s) <= (a_val a2 s)
b_val (Neg b) s = not(b_val b s)
b_val (And b1 b2) s = (b_val b1 s) && (b_val b2 s)


fix :: (a -> a) -> a
fix ff = ff (fix ff)

-- Semantic Functions (To Do)

{-
new :: Loc -> Loc
lookup :: EnvV -> Store -> State
update :: Eq a => (a->b) -> b -> a -> (a->b)
s_ds' :: Stm -> EnvV -> Store -> Store
d_v_ds :: DecV -> (EnvV, Store) -> (EnvV, Store)	
d_p_ds :: DecP -> EnvV -> EnvP -> EnvP	
s_ds :: Stm -> EnvV -> EnvP -> Store -> Store
-}

{- TEST FUNCTIONs -}

ev :: EnvV
ev "x" = 1
ev _ = 0

q :: Store
q x 
    | x == 0 = 2
    | x == 1 = 0
    | otherwise = undefined

{-END TEST FUNCTIONS -}
    
    
    
new :: Loc -> Loc
new x = succ x

lookup :: EnvV -> Store -> State
lookup e s = s.e

update :: Eq a => (a->b) -> b -> a -> (a->b)
update f v x = g where g x = v


cond :: (a->T, a->a, a->a) -> (a->a)
cond (p, g1, g2) s = if p s then g1 s else g2 s

s_ds' :: Stm -> EnvV -> Store -> Store
s_ds' (Ass x a) e s = update s (a_val a (lookup e s)) (e x)
s_ds' Skip e s = id
s_ds' (If b ss1 ss2) e s = cond ((b_val b).(lookup e), s_ds' ss1 e, s_ds' ss2 e) s  {- WHY s ON THE END? -}
s_ds' (While b ss) e s = fix ff s where ff g = cond((b_val b).(lookup e), g . (s_ds' ss e), id)

{-(a_val a (lookup e s)) x-}
{-
s_ds (Ass x a) s =	update s (a_val a s) x
                            where
                            update s v x y = case x of
                                                    y -> v
                                                    _ -> s y
s_ds Skip s = id s
s_ds (Comp ss1 ss2) s = ((s_ds ss2) . (s_ds ss1)) s
s_ds (If b ss1 ss2) s = cond (b_val b, s_ds ss1, s_ds ss2) s
s_ds (While b ss) s = fix ff s where ff g = cond(b_val b, g . s_ds ss, id)
-}

{-s :: Stm
s = begin var x:=7; proc p is x:=0; begin var x:=5; call p end end-}


























