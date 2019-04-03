
(*@ use Seq *)

type 'a t
(*@ mutable model view: 'a seq *)

val create : unit -> 'a t
(** Return a new queue, initially empty. *)
(*@ q = create ()
      ensures q.view == empty *)

val push : 'a -> 'a t -> unit
(** [add x q] adds the element [x] at the end of the queue [q]. *)
(*@ push x q
      modifies q
      ensures  q.view == snoc (old q.view) x *)

val pop : 'a t -> 'a
(** [take q] removes and returns the first element in queue [q],
   or raises [Empty] if the queue is empty. *)
(*@ r = take q
      requires q.view <> empty
      modifies q
      ensures  old q.view == cons r q.view *)

val is_empty : 'a t -> bool
(** Return [true] if the given queue is empty, [false] otherwise. *)
(*@ b = is_empty q
      ensures b <-> q.view = empty *)

val transfer : 'a t -> 'a t -> unit
(** [transfer q1 q2] adds all of [q1]'s elements at the end of
   the queue [q2], then clears [q1]. It is equivalent to the
   sequence [iter (fun x -> add x q2) q1; clear q1], but runs
   in constant time. *)
(*@ transfer q1 q2
      modifies q1.view, q2.view
      ensures  q1.view == empty
      ensures  q2.view == old q2.view ++ old q1.view *)
