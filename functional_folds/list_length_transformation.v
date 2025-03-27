(* Start of list_length_transformation.v *)
(* Version of 250325 *)

(* ***************************** *)
(* Imports *)

Require Import List.

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
(** List Length Unit Test **)

Definition test_list_length (candidate : forall V : Type, list V -> nat) : bool :=
  (Nat.eqb (candidate nat nil) 0)
  &&
    (Nat.eqb (candidate nat (1 :: nil)) 1)
  &&
    (Nat.eqb (candidate nat (1 :: 2 :: nil)) 2)
  &&
    (Nat.eqb (candidate (list nat) nil) 0)
  &&
    (Nat.eqb (candidate (list nat) ((1 :: nil) :: nil)) 1)
  &&
    (Nat.eqb (candidate (list nat) ((1 :: nil) :: (2 :: nil) :: nil)) 2)
.

(* ***************************** *)
(* Start of Transformation process for list_length to list_length_v2 *)

(** List Length **)

Fixpoint list_length (V : Type) (ls : list V) : nat :=
     match ls with
    | nil => 0
    | l :: ls' => (list_length V ls') + 1
     end.

Compute (test_list_length list_length).

(** ************************* **)
(** Representing list_length using list_fold_right **)

Definition list_length_right (V : Type) (ls : list V) : nat :=
  list_fold_right
    V
    nat
    0
    (fun _ ih => ih + 1)
    ls.

Compute (test_list_length list_length_right).

(** ************************* **)
(** Changing codomain from Nat to (Nat -> Nat) **)

Definition list_length_right_acc (V : Type) (ls : list V) : nat :=
  list_fold_right
    V
    (nat -> nat)
    (fun acc => acc)
    (fun _ ih acc => ih (1 + acc))
    ls
    0.

Compute (test_list_length list_length_right_acc).

(* ************************* *)
(* Unfolding the call to list_fold_right and inlining is definiens *)

Definition list_length_right_acc_inlined_v1 (V' : Type) (ls : list V') : nat :=
  (let V := list V' in
   let W := (nat -> nat) in 
   let base_case := (fun acc => acc) in
   let cons_case := (fun _ ih acc => ih (1 + acc)) in
   let ls := ls in 
   let fix visit ls := 
        match ls with 
        | nil => base_case 
        | l :: ls' => cons_case l (visit ls')
        end
   in visit ls) 0.

Compute (test_list_length list_length_right_acc_inlined_v1).


(** ************************* **)
(** Unfolding the outer let expressions and commuting the "let fix visit" and the application to 0 **)

Definition list_length_right_acc_inlined_v2 (V : Type) (ls : list V) : nat :=
  let fix visit ls := 
    match ls with 
    | nil => (fun acc => acc)
    | l :: ls' => (fun _ ih acc => ih (1 + acc)) l (visit ls')
    end
  in visit ls 0.

Compute (test_list_length list_length_right_acc_inlined_v2).

(** ************************* **)
(** Beta Reduction **)

Definition list_length_right_acc_inlined_v3 (V : Type) (ls : list V) : nat :=
  let fix visit ls := 
    match ls with 
    | nil => (fun acc => acc)
    | l :: ls' => (fun acc => (visit ls') (1 + acc))
    end
  in visit ls 0.

Compute (test_list_length list_length_right_acc_inlined_v3).

(** ************************* **)
(** Commuting the match-expression and the lambda-abstraction **)

Definition list_length_right_acc_inlined_v4 (V :  Type) (ls : list V) : nat :=
  let fix visit ls := fun acc =>
    match ls with 
    | nil => acc
    | l :: ls' => (visit ls') (1 + acc)
    end
  in visit ls 0.

Compute (test_list_length list_length_right_acc_inlined_v4).

(** ************************* **)
(** Transforming the explicit lambda chaining to a curried multi-parameter syntax **)

Definition list_length_right_acc_inlined_v5 (V : Type) (ls : list V) : nat :=
  let fix visit ls acc := 
    match ls with 
    | nil => acc
    | l :: ls' => (visit ls') (1 + acc)
    end
  in visit ls 0.

Compute (test_list_length list_length_right_acc_inlined_v5).

(** ************************* **)
(** Lambda-lifting **)

Fixpoint list_length_v2_aux (V : Type) (ls : list V) (acc : nat) : nat :=
    match ls with 
    | nil => acc
    | l :: ls' => list_length_v2_aux V ls' (1 + acc)
    end.

Definition list_length_v2 (V : Type) (ls : list V) : nat :=
     list_length_v2_aux V ls 0.

Compute (test_list_length list_length_v2).

(** ************************* **)
(* ***************************** *)

(* End of File *)
