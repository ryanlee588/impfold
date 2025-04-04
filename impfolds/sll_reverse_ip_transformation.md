# SLL Reverse In Place Transformation

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

## Sll Append

```c
Sllnode* sll_append(Sllnode* ls_ptr, Sllnode* ls_ptr_2) {
    return sll_impfoldr
            ls_ptr_2
            (Sllnode* [] (Sllnode* node_ptr) (Sllnode* ih) = {
               node_ptr->next = ih;
                return node_ptr;
            })
            ls_ptr;
}
```

## Transformation process for sll_reverse_ip to sll_reverse_ip_v2

### SLL Reverse In Place

```c
Sllnode* sll_reverse_ip (Sllnode* ls_ptr) {
    if (ls_ptr == NULL) {
        return NULL
    } else {
        Sllnode* next_ptr = ls_ptr->next;

        Sllnode* ih = sll_reverse_ip next_ptr

        ls_ptr->next = NULL;

        return sll_append ih ls_ptr;
    }
```

### Representing sll_reverse_ip using sll_impfoldr

```c
Sllnode* sll_reverse_ip_right (Sllnode* ls_ptr) {
    return sll_impfoldr
            NULL
            (Sllnode* [] (Sllnode* node_ptr)
                (Sllnode* ih) = {
                   node_ptr->next = NULL;
                   return sll_append ih node_ptr;
            })
            ls_ptr;
}
```

### Changing codomain from Sllnode* to (Sllnode* -> Sllnode)

```c
Sllnode* sll_reverse_ip_right_acc (Sllnode* ls_ptr) {
    return sll_impfoldr
            (Sllnode* [] (Sllnode* acc) = {
                return acc
            })
            (Sllnode* [] (Sllnode* node_ptr) (Sllnode* ih[] (Sllnode*)) (Sllnode* acc) = {
               node_ptr->next = acc;
               return ih node_ptr;
            })
            ls_ptr
            NULL;
};
```

### Unfolding the call to sll_impfoldr and defining its definiens as separate variables

```c
Sllnode* sll_reverse_ip_right_acc_inlined_v1 (Sllnode* ls_ptr) {
    Sllnode* base_case = ([] (Sllnode* acc) = {
                return acc
            });
    Sllnode* cons_case = ([] (Sllnode* node_ptr) (Sllnode* ih[] (Sllnode*)) (Sllnode* acc) = {
               node_ptr->next = acc;
               return ih node_ptr;
            });
    Sllnode* visit (Sllnode* sllnode_ptr) = {
        if (sllnode_ptr == NULL) {
            return base_case;
        } else {
            Sllnode* next_ptr = sllnode_ptr->next;

            Sllnode* ih[] (Sllnode*) = visit next_ptr

            return cons_case sllnode_ptr ih;
        }
    };
    return (visit ls_ptr) NULL;
};
```

### Unfolding the variable declarations except visit and commuting "visit ls_ptr" and the application to NULL

```c
Sllnode* sll_reverse_ip_right_acc_inlined_v2 (Sllnode* ls_ptr) {
    Sllnode* visit (Sllnode* sllnode_ptr) = {
        if (sllnode_ptr == NULL) {
            return ([] (Sllnode* acc) = {
                return acc
            });
        } else {
            Sllnode* next_pointer = sllnode_ptr->next;

            Sllnode* ih[] (Sllnode*) = visit next_pointer;

            return ([] (Sllnode* node_ptr) (Sllnode* ih[] (Sllnode*)) (Sllnode* acc) = {
               node_ptr->next = acc;
               return ih node_ptr;
            }) sllnode_ptr ih;
        }
    };
    return visit ls_ptr NULL;
};
```

### Beta-reduction

```c
Sllnode* sll_reverse_ip_right_acc_inlined_v3 (Sllnode* ls_ptr) {
    Sllnode* visit (Sllnode* sllnode_ptr) =
        if (sllnode_ptr == NULL) {
            return ([] (Sllnode* acc) = {
                return acc
            });
        } else {
            Sllnode* next_pointer = sllnode_ptr->next;

            Sllnode* ih[] (Sllnode*) = visit next_pointer;

            return ([] (Sllnode* acc) = {
               sllnode_ptr->next = acc;
               return ih sllnode_ptr;
            })
        };
    return visit ls_ptr NULL;
};
```

### Commuting the conditional and the lambda-abstraction

```c
Sllnode* sll_reverse_ip_right_acc_inlined_v4 (Sllnode* ls_ptr) {
    Sllnode* visit (Sllnode* sllnode_ptr) = {[] (Sllnode* acc) = {
        if (sllnode_ptr == NULL) {
            return acc
        } else {
            Sllnode* next_pointer = sllnode_ptr->next;

            Sllnode* ih[] (Sllnode*) = visit next_pointer;

            sllnode_ptr->next = acc;
            return ih sllnode_ptr;
        }
    }};
    return visit ls_ptr NULL;
};
```

### Transforming the explicit lambda chaining to a curried multi-parameter syntax

```c
Sllnode* sll_reverse_ip_right_acc_inlined_v5 (Sllnode* ls_ptr) {
    Sllnode* visit (Sllnode* sllnode_ptr) (Sllnode* acc) = {
        if (sllnode_ptr == NULL) {
            return acc
        } else {
            Sllnode* next_pointer = sllnode_ptr->next;

            Sllnode* ih[] (Sllnode*) = visit next_pointer;

            sllnode_ptr->next = acc;
            return ih sllnode_ptr;
        }
    };
    return visit ls_ptr NULL;
};
```

### Lambda-lifting and inlining ih

```c
Sllnode* sll_reverse_ip_v2_aux (Sllnode* ls_ptr) (Sllnode* acc) {
    if (ls_ptr == NULL) {
        return acc
    } else {
        Sllnode* next_ptr = ls_ptr->next;

        ls_ptr->next = acc;

        return sll_reverse_ip_v2_aux next_ptr ls_ptr;
    }

Sllnode* sll_reverse_ip_v2 (Sllnode* ls_ptr) {
    return sll_reverse_ip_v2_aux ls_ptr NULL;
}
```
