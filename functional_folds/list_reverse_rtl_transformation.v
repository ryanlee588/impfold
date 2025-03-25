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
(* Start of Transformation process for list_reverse to list_reverse_v2 *)

(** List Reverse Right to Left **)
Fixpoint list_reverse_rtl
(V : Type)
(ls : list V) : list V :=
  match ls with
  | nil => nil
  | l :: ls' => 
        list_reverse_rtl V ls' ++ (l :: nil)
  end.

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

(** ************************* **)
(** Unfolding the outer let expressions and commuting the "let fix visit" and the application to nil **)

Definition list_reverse_right_acc_inlined_v2 (V : Type) (ls : list V) : list V :=
  let fix visit ls := 
    match ls with 
    | nil => (fun acc => acc)
    | l :: ls' => (fun l ih acc => ih (l :: acc)) l (visit ls')
    end
  in visit ls nil.

(** ************************* **)
(** Beta Reduction **)

Definition list_reverse_right_acc_inlined_v3 (V : Type) (ls : list V) : list V :=
  let fix visit ls := 
    match ls with 
    | nil => (fun acc => acc)
    | l :: ls' => (fun acc => (visit ls') (l :: acc))
    end
  in visit ls nil.

(** ************************* **)
(** Commuting the match-expression and the lambda-abstraction **)

Definition list_reverse_right_acc_inlined_v4 (V : Type) (ls : list V) : list V :=
  let fix visit ls := fun acc =>
    match ls with 
    | nil => acc
    | l :: ls' => (visit ls') (l :: acc)
    end
  in visit ls nil.

(** ************************* **)
(** Transforming the explicit lambda chaining to a curried multi-parameter syntax **)

Definition list_reverse_right_acc_inlined_v5 (V : Type) (ls : list V) : list V :=
  let fix visit ls acc := 
    match ls with 
    | nil => acc
    | l :: ls' => (visit ls') (l :: acc)
    end
  in visit ls nil.

(** ************************* **)
(** Lambda-lifting **)

Fixpoint list_reverse_v2_aux (V : Type) (ls : list V) (acc : list V) : list V :=
    match ls with 
    | nil => acc
    | l :: ls' => list_reverse_v2_aux V ls' (l :: acc) 
    end.

Definition list_reverse_v2 (V : Type) (ls : list V) : list V :=
     list_reverse_v2_aux V ls nil.
(** ************************* **)
(* ***************************** *)

(* End of File *)
