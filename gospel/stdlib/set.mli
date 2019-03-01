
(*@ Specification file, implicitly comment out all lines *)


type 'a set


(*---------------------------------------------------------------------*)
(** Constructors *)

value empty : 'a list

function single (x:'a) : 'a set

function union (s1 s2:'a set) : 'a set

function inter (s1 s2:'a set) : 'a set

function diff (s1 s2:'a set) : 'a set

function card (x:'a) : int


(*---------------------------------------------------------------------*)
(** Notation *)

Notation Infix "∩" := union.
Notation Infix "∪" := inter.
Notation Infix "∖" := diff.
Notation Infix "⊂" := diff.


(*---------------------------------------------------------------------*)
(** Predicates *)

predicate finite (s:'a set) : prop

predicate mem (x:'a) (s:'a set) : prop

predicate incl (s1 s2:'a set) : prop

predicate disjoint (s1 s2:'a set) : prop

predicate foreach (p:'a->prop) (s:'a set) : prop

predicate fold (f:'a->'b) (m:'b monoid) (s:'a set) : prop
  (* alias map_reduce *)


(*---------------------------------------------------------------------*)
(** Characterization *)

Section Facts.
Implicit Quantifiers ('a : type) (s* : 'a set) (x* y* : 'a).

fact mem_empty :
  mem x empty = false

fact mem_single :
  mem x (single y) = (x = y)

fact mem_union :
  mem x (union s1 s2) = (mem x s1 \/ mem x s2)

fact mem_inter :
  mem x (inter s1 s2) = (mem x s1 /\ mem x s2)

fact mem_diff :
  mem x (diff s1 s2) = (mem x s1 /\ ~ mem x s2)

fact incl_mem :
  incl s1 s2 = (forall x, mem x s1 -> mem x s2)

fact disjoint_mem :
  disjoint s1 s2 = (forall x, mem x s1 -> mem x s2 -> false)

fact eq_mem :
  (s1 = s2) = (forall x, mem x s1 = mem x s2)

fact foreach_mem :
  foreach p s = (forall x, mem x s -> p x)

fact fold_empty :
  fold f m empty = m.neutral

fact fold_single :
  fold f m (single x) = f x

fact fold_union :
  commutative_monoid m ->
  finite s1 ->
  finite s2 ->
  fold f m (union s1 s2) = m.op (fold f m s1) (fold f m s2)

fact card_empty :
  card empty = 0

fact card_single :
  card (single x) = 1

fact card_union_disjoint :
  finite s1 ->
  finite s2 ->
  disjoint s1 s2 ->
  card (union s1 s2) = card s1 + card s2

(* Note: cardinal characterization is incomplete at the moment *)


(*---------------------------------------------------------------------*)
(** Additional derived facts ---- no need to include them in this file! *)

fact eq_incl :
  (s1 = s2) = (incl s1 s2 /\ incl s2 s1)

fact card_inter_le_l :
  finite s1 ->
  card (s1 \n s2) <= card s1

fact card_inter_le_r :
  finite s2 ->
  card (s1 \n s2) <= card s2

fact foreach_empty :
  foreach p empty = true

fact foreach_single :
  foreach p (single x) = (p x)

fact foreach_union :
  foreach p (union s1 s2) = (foreach p s1 /\ foreach p s2)

fact foreach_incl :
  foreach p s2 ->
  incl s1 s2 ->
  foreach p s1

fact associative_inter :
  associative inter

fact commutative_inter :
  commutative inter

fact absorb_inter :
  absorb inter empty

fact commutative_monoid_union :
  commutative_monoid (monoid_make union empty)

fact distrib_union_inter
  inter s1 (union s2 s3) = union (inter s1 s2) (inter s1 s3)

(* and many many others *)

End Facts.
