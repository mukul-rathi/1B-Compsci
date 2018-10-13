#include <stdio.h>
#include <stdlib.h>
#include "list.h"

List *cons(int head, List *tail) { 
  /* malloc() will be explained in the next lecture! */
  List *cell = malloc(sizeof(List));
  cell->head = head;
  cell->tail = tail;
  return cell;
}

/* Functions for you to implement */

int sum(List *list) {
  if(list==NULL){
    return 0;
  }
  else{
  return list->head + sum(list->tail);
  }
}

void iterate(int (*f)(int), List *list) {
  if(list!=NULL){
  list->head = f(list->head);
  iterate(*f, list->tail);
  }
}

void print_list(List *list) { 
  List *currentList = NULL;
  printf("[");
  if(list!=NULL){
    printf("%d", list->head);
    currentList = list->tail;
  }
  while(currentList!=NULL){
    printf(", %d", currentList->head);
    currentList = currentList->tail;
  }
  printf("]\n");
}

/**** CHALLENGE PROBLEMS ****/

List *merge(List *list1, List *list2) { 
  //base cases
  if(list1 == NULL){
    return list2;
  }
  if(list2 == NULL){
    return list1;
  }
  //compare heads
 if(list1->head < list2->head){
   if(list1->tail==NULL){ 
     list1->tail = list2;
   }
   else{
    list1->tail = merge(list1->tail, list2);
   }
  return list1;

 }
 else{
   //swap lists - avoiding code duplication
   return merge(list2,list1);
 }
}

void split(List *list, List **list1, List **list2) { 
*list1 = list;
*list2 = list;
if(list!=NULL){
	split(list->tail, list2, &((*list1)->tail));
}
}

/* You get the mergesort implementation for free. But it won't
   work unless you implement merge() and split() first! */

List *mergeSort(List *list) { 
  if (list == NULL || list->tail == NULL) { 
    return list;
  } else { 
    List *list1;
    List *list2;
    split(list, &list1, &list2);
    list1 = mergeSort(list1);
    list2 = mergeSort(list2);
    return merge(list1, list2);
  }
}
