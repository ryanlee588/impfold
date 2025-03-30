(* Start of list_max.v *)
(* Version of 300325 *)

(* ***************************** *)
(* Imports *)

Require Import List.
Require Import Arith.

(* ***************************** *)
(* list_fold_right *)

Definition list_fold_right (V W : Type) (base_case : W) (cons_case : V -> W -> W )(ls : list V) : W :=
  let fix visit ls :=
    match ls with
    | nil => base_case
    | l :: ls' => cons_case l (visit ls')
    end
  in visit ls.

(* ***************************** *)
(** List Max Unit Test **)

Definition test_list_max (candidate : list nat -> nat) : bool :=
  (Nat.eqb (candidate nil) 0)
  &&
    (Nat.eqb (candidate (1 :: nil)) 1)
  &&
    (Nat.eqb (candidate (1 :: 2 :: nil)) 2)
  &&
    (Nat.eqb (candidate (1 :: 2 :: 3 :: nil)) 3)
  &&
    (Nat.eqb (candidate (3 :: 2 :: 1 :: nil)) 3)
  &&
    (Nat.eqb (candidate (1 :: 3 :: 2 :: nil)) 3)
.


(* ***************************** *)
(* List Max Optimization*)

(** List Max **)

Fixpoint list_insert (a : nat) (ls : list nat) : list nat :=
  match ls with
  | nil => a :: nil
  | l :: ls' => if (Nat.ltb l a) then a :: l :: ls' else l :: list_insert a ls'
  end.                                                                           

Definition list_sort (ls : list nat) : list nat :=
  list_fold_right
    nat
    (list nat)
    nil
    list_insert
    ls.

Definition list_head (ls : list nat) : nat :=
  match ls with
  | nil => 0
  | l :: ls' => l
  end.

Definition list_max (ls : list nat) : nat :=
  list_head (list_sort ls).

Compute (test_list_max list_max).
                     
(* ***************************** *)
(** List Max Optimized **)

Definition list_max_v2 (ls : list nat) : nat :=
  list_fold_right
    nat
    nat
    0
    (fun l ih => if (Nat.ltb ih l) then l else ih)
    ls.
                                       
Compute (test_list_max list_max_v2).

(** ************************* **)
(* ***************************** *)

(* End of File *)
