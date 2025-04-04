# SLL Max

Version of 300325

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

## SLL Insert

```c
Sllnode* sll_insert (Sllnode* ele) (Sllnode* ls_ptr) {
    if (ls_ptr == NULL) {
        ele->next = NULL;
        return ele;
    } else {
        if (ls_ptr->value > ele->value) {
            Sllnode* new_ls = sll_insert ele ls_ptr->next;
            ls_ptr->next = new_ls;
            return ls_ptr;
        } else {
            ele->next = ls_ptr;
            return ele;
        }
    }
}
```

## SLL Sort

```c
Sllnode* sll_sort (Sllnode* ls_ptr) {
    return sll_impfoldr
            nil
            sll_insert
            ls_pointer;
}
```

## SLL First Value

```c
int sll_first_value (Sllnode* ls_ptr) {
    if (ls_ptr == NULL) {
        return 0;
    } else {
        return ls_ptr->value;
    }
}
```

## SLL Max

```c
int sll_max (Sllnode* ls_ptr) {
    return sll_first_value (sll_sort ls_ptr);
}
```

## SLL Max Optimized

```c
int sll_max_v2 (Sllnode* ls_ptr) {
    sll_impfoldr
    0
    (int [] (Sllnode* node_ptr) (int ih) = {
       if (node_ptr->value > ih) {
            return node_ptr->value;
       } else {
            return ih;
       }
    })
    ls_ptr;
}
```
