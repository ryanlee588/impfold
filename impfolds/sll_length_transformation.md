# SLL Length Transformation

Version of 270325

## Type Definitions

```c
typedef struct Sllnode {
    V value;
    struct Sllnode* next;
} Sllnode;
```

## SLL Impfold Right

```c
V sll_impfoldr (V base_case) (V (*cons_case)[] (Sllnode*) (V)) (Sllnode* sllnode_ptr) {
    if (sllnode_ptr == NULL) {
        return base_case;
    } else {
        Sllnode* next_ptr = sllnode_ptr->next;
        V ih = sll_impfoldr base_case cons_case next_ptr;
        return cons_case sllnode_ptr ih;
    }
}
```

## Transformation process for sll_length to sll_length_v2

### SLL Length

```c
int sll_length (Sllnode* ls_ptr) {
    if (ls_ptr == NULL) {
        return 0
    } else {
        Sllnode* next_ptr = sllnode_ptr->next;
        int ih = sll_length T next_ptr
        return ih + 1;
    }
```

### Representing sll_length using sll_impfoldr

```c
int sll_length_right (Sllnode* ls_ptr) {
    return sll_impfoldr
            0
            (int [] (Sllnode* node_ptr) (int ih) = {
               return ih + 1;
            })
            ls_pointer;
}
```

### Changing codomain from Int to (Int -> Int)

```c
int sll_length_right_acc (Sllnode* ls_ptr) {
    return sll_impfoldr
            (int [] (int acc) = {
               return acc;
            })
            (int [] (Sllnode* node_ptr) (int ih[] (int))
                (int acc) = {
               return ih (1 + acc);
            })
            ls_ptr
            0;
}
```

### Unfolding the call to sll_impfoldr and defining its definiens as separate variables

```c
int sll_length_right_acc_inlined_v1 (Sllnode* ls_ptr) {
    int base_case = ([] (Sllnode* acc) = {
                return acc
            });
    int cons_case = ([] (Sllnode* node_ptr) (int ih[] (int)) (int acc) = {
               return ih (1 + acc);
            });
    int visit (Sllnode* sllnode_ptr) = {
        if (sllnode_ptr == NULL) {
            return base_case;
        } else {
            Sllnode* next_ptr = sllnode_ptr->next;
            int ih[] (int) = visit next_ptr
            return cons_case sllnode_ptr ih;
        }
    };
    return (visit ls_ptr) 0;
};
```

### Unfolding the variable declarations except visit and commuting "visit ls_ptr" and the application to 0

```c
int sll_length_right_acc_inlined_v2 (Sllnode* ls_ptr) {
    int visit (Sllnode* sllnode_ptr) = {
        if (sllnode_ptr == NULL) {
            return ([] (int acc) = {
                return acc
            });
        } else {
            Sllnode* next_pointer = sllnode_ptr->next;
            int ih[] (int) = visit next_pointer;
            return ([] (Sllnode* node_ptr)
            (int ih[] (int)) (int acc) = {
               return ih (1 + acc);
            }) sllnode_ptr ih;
        }
    };
    return visit ls_ptr 0;
};
```

### Beta-reduction

```c
int sll_length_right_acc_inlined_v3 (Sllnode* ls_ptr) {
    int visit (Sllnode* sllnode_ptr) =
        if (sllnode_ptr == NULL) {
            return ([] (int acc) = {
                return acc
            });
        } else {
            Sllnode* next_pointer = sllnode_ptr->next;
            int ih = visit next_pointer;
            return ([] (int acc) = {
               return ih (1 + acc);
            })
        };
    return visit ls_ptr 0;
};
```

### Commuting the conditional and the lambda-abstraction

```c
int sll_length_right_acc_inlined_v4 (Sllnode* ls_ptr) {
    int visit (Sllnode* sllnode_ptr) = {[] (int acc) = {
        if (sllnode_ptr == NULL) {
            return acc
        } else {
            Sllnode* next_pointer = sllnode_ptr->next;
            int ih[] (int) = visit next_pointer;
            return ih (1 + acc);
        }
    }};
    return visit ls_ptr 0;
};
```

### Transforming the explicit lambda chaining to a curried multi-parameter syntax

```c
int sll_length_right_acc_inlined_v5 (Sllnode* ls_ptr) {
    int visit (Sllnode* sllnode_ptr) (int acc) = {
        if (sllnode_ptr == NULL) {
            return acc
        } else {
            Sllnode* next_pointer = sllnode_ptr->next;
            int ih[] (int) = visit next_pointer;
            return ih (1 + acc);
        }
    };
    return visit ls_ptr 0;
};
```

### Lambda-lifting and inlining ih

```c
int sll_length_v2_aux (Sllnode* ls_ptr) (int acc) {
    if (ls_ptr == NULL) {
        return acc
    } else {
        Sllnode* next_ptr = sllnode_ptr->next;
        return sll_length_v2_aux next_ptr (1 + acc);
    }

int sll_length_v2 (Sllnode* ls_ptr) {
    return sll_length_v2_aux ls_ptr 0;
    }
```
