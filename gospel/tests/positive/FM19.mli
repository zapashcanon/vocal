(**************************************************************************)
(*                                                                        *)
(*  GOSPEL -- A Specification Language for OCaml                          *)
(*                                                                        *)
(*  Copyright (c) 2018- The VOCaL Project                                 *)
(*                                                                        *)
(*  This software is free software, distributed under the MIT license     *)
(*  (as described in file LICENSE enclosed).                              *)
(**************************************************************************)

(*@ open Seq *)

type 'a t
(*@ mutable model view: 'a seq *)

val push: 'a -> 'a t -> unit
(*@ push v q
    modifies q
    ensures  q.view = cons v (old q.view) *)

val pop: 'a t -> 'a
(*@ v = pop q
    requires q.view <> empty
    modifies q
    ensures  old q.view = q.view ++ (cons v empty) *)

val is_empty: 'a t -> bool
(*@ b = is_empty q
    ensures b <-> q.view = empty *)

val create: unit -> 'a t
(*@ q = create ()
    ensures q.view = empty *)

val in_place_concat: 'a t -> 'a t -> unit
(*@ in_place_concat q1 q2
    modifies q1, q2
    ensures  q1.view = empty
    ensures  q2.view = old q1.view ++ old q2.view *)

val in_place_destructive_concat: 'a t -> 'a t -> unit
(*@ in_place_destructive_concat q1 q2
    consumes q1  modifies q2
    ensures  q2.view = old q1.view ++ old q2.view *)

val nondestructive_concat: 'a t -> 'a t -> 'a t
(*@ q3 = nondestructive_concat q1 q2
    ensures q3.view = q1.view ++ q2.view *)

val map: ('a -> 'b) -> 'a t -> 'b t
(*@ r = map f q
    ensures length r.view = length q.view
    ensures forall i. 0 <= i < length q.view ->
                      r.view[i] = f q.view[i] *)

(*@ function power (x y: integer): integer *)

val power_2_below: int -> int
(*@ r, [k: integer] = power_2_below n
    requires n >= 1
    ensures  r = power 2 k && r <= n < 2 * r *)

type rand_state
(*@ mutable model internal: unit *)

val random_init: int -> rand_state

val random_int: rand_state -> int -> int
(*@ n = random_int s m
    requires m > 0  modifies s  ensures  0 <= n < m *)

(*@ open Set *)
(*@ open Map *)

type elem
(*@ type uf_instance *)
(*@ mutable model dom: elem set *)
(*@ mutable model rep: elem -> elem *)
(*@ mutable model internal: unit *)
(*@ invariant forall x. mem x dom -> mem (rep x) dom *)
(*@ invariant forall x. mem x dom -> rep (rep x) = rep x *)

val equiv: elem -> elem -> bool
(*@ b = equiv [uf: uf_instance] e1 e2
    requires mem e1 uf.dom && mem e2 uf.dom
    modifies uf.internal
    ensures  b <-> uf.rep e1 = uf.rep e2 *)

(*@ val create_instance: unit -> uf_instance *)
(*@ uf = create_instance ()
    ensures uf.dom = {} *)

val make: unit -> elem
(*@ e = make [uf: uf_instance] ()
    modifies uf
    ensures  not (mem e (old uf.dom))
    ensures  uf.dom = union (old uf.dom) {:e:}
    ensures  uf.rep = (old uf.rep)[e <- e] *)

type type1
type type2

(* name differs from the paper, because type t is already defined in
   this scope. *)

type tt
(*@ mutable model left:  type1 *)
(*@ mutable model right: type2 *)

val f: tt -> tt -> tt -> tt -> int -> tt * tt * int
(*@ p5, p6, m, [h: integer] = f p1 p2 p3 p4 n [g: integer]
    requires true (* P in the paper *)
    modifies p1, p2.left  consumes p3
    ensures  true (* Q in the paper *) *)