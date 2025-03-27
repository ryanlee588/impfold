(* Start of list_reverse_rtl_transformation.v *)
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
(* List eqb *)

Fixpoint eqb_list (V : Type) (eqb_V : V -> V -> bool) (v1s v2s : list V) : bool :=
  match v1s with
    nil =>
    match v2s with
      nil =>
      true
    | v2 :: v2s' =>
      false
    end
  | v1 :: v1s' =>
    match v2s with
      nil =>
      false
    | v2 :: v2s' =>
      eqb_V v1 v2 && eqb_list V eqb_V v1s' v2s'
    end
  end.

(* ***************************** *)
(* list Reverse Unit Test *)

Definition test_list_reverse (candidate : forall V : Type, list V -> list V) : bool :=
  (eqb_list nat Nat.eqb (candidate nat nil) nil)
  &&
    (eqb_list nat Nat.eqb (candidate nat (1 :: nil)) (1 :: nil))
  &&
    (eqb_list nat Nat.eqb (candidate nat (1 :: 2 :: nil)) (2 :: 1 :: nil))
  &&
    (eqb_list (list nat) (eqb_list nat Nat.eqb) (candidate (list nat) nil) nil)
  &&
    (eqb_list (list nat) (eqb_list nat Nat.eqb) (candidate (list nat) ((1 :: nil) :: nil)) ((1 :: nil) :: nil))
  &&
    (eqb_list (list nat) (eqb_list nat Nat.eqb) (candidate (list nat) ((1 :: nil) :: (2 :: nil) :: nil)) ((2 :: nil):: (1 :: nil) :: nil))
.

(* ***************************** *)
(* Transformation process for list_reverse_rtl to list_reverse_v2 *)

(** List Reverse Right to Left **)
Fixpoint list_reverse_rtl
(V : Type)
(ls : list V) : list V :=
  match ls with
  | nil => nil
  | l :: ls' => 
        list_reverse_rtl V ls' ++ (l :: nil)
  end.

Compute (test_list_reverse list_reverse_rtl).

(** ************************* **)
(** Representing list_reverse_rtl using list_fold_right **)

Definition list_reverse_right (V : Type)
(ls : list V) : list V :=
  list_fold_right
    V
    (list V)
    nil
    (fun l ih => ih ++ (l :: nil))
    ls.

Compute (test_list_reverse list_reverse_right).

(** ************************* **)
(** Changing codomain from List V to (List V -> List V) **)

Definition list_reverse_right_acc (V : Type) (ls : list V) : list V :=
  list_fold_right
    V
    (list V -> list V)
    (fun acc => acc)
    (fun l ih acc => ih (l :: acc))
    ls
    nil.

Compute (test_list_reverse list_reverse_right_acc).

(* ************************* *)
(* Unfolding the call to list_fold_right and inlining is definiens *)

Definition list_reverse_right_acc_inlined_v1 (V' : Type) (ls : list V') : list V' :=
  (let V := list V' in
   let W := (list V' -> list V') in 
   let base_case := (fun acc => acc) in
   let cons_case := (fun l ih acc => ih (l :: acc)) in
   let ls := ls in 
   let fix visit ls := 
        match ls with 
        | nil => base_case 
        | l :: ls' => cons_case l (visit ls')
        end
   in visit ls) nil.

Compute (test_list_reverse list_reverse_right_acc_inlined_v1).

(** ************************* **)
(** Unfolding the outer let expressions and commuting the "let fix visit" and the application to nil **)

Definition list_reverse_right_acc_inlined_v2 (V : Type) (ls : list V) : list V :=
  let fix visit ls := 
    match ls with 
    | nil => (fun acc => acc)
    | l :: ls' => (fun l ih acc => ih (l :: acc)) l (visit ls')
    end
  in visit ls nil.

Compute (test_list_reverse list_reverse_right_acc_inlined_v2).

(** ************************* **)
(** Beta Reduction **)

Definition list_reverse_right_acc_inlined_v3 (V : Type) (ls : list V) : list V :=
  let fix visit ls := 
    match ls with 
    | nil => (fun acc => acc)
    | l :: ls' => (fun acc => (visit ls') (l :: acc))
    end
  in visit ls nil.

Compute (test_list_reverse list_reverse_right_acc_inlined_v3).

(** ************************* **)
(** Commuting the match-expression and the lambda-abstraction **)

Definition list_reverse_right_acc_inlined_v4 (V : Type) (ls : list V) : list V :=
  let fix visit ls := fun acc =>
    match ls with 
    | nil => acc
    | l :: ls' => (visit ls') (l :: acc)
    end
  in visit ls nil.

Compute (test_list_reverse list_reverse_right_acc_inlined_v4).

(** ************************* **)
(** Transforming the explicit lambda chaining to a curried multi-parameter syntax **)

Definition list_reverse_right_acc_inlined_v5 (V : Type) (ls : list V) : list V :=
  let fix visit ls acc := 
    match ls with 
    | nil => acc
    | l :: ls' => (visit ls') (l :: acc)
    end
  in visit ls nil.

Compute (test_list_reverse list_reverse_right_acc_inlined_v5).

(** ************************* **)
(** Lambda-lifting **)

Fixpoint list_reverse_v2_aux (V : Type) (ls : list V) (acc : list V) : list V :=
    match ls with 
    | nil => acc
    | l :: ls' => list_reverse_v2_aux V ls' (l :: acc) 
    end.

Definition list_reverse_v2 (V : Type) (ls : list V) : list V :=
  list_reverse_v2_aux V ls nil.

Compute (test_list_reverse list_reverse_v2).
(** ************************* **)
(* ***************************** *)

(* End of File *)
