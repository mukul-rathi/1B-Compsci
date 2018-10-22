#include <stdlib.h>
#include <stdio.h>
#include "re.h"


arena_t create_arena(int size) { 
  arena_t a =(arena_t) malloc(sizeof(struct arena));
	a->regexps = (Regexp *) malloc(size*sizeof(Regexp));
	a->space = size;
  return a;
}

void arena_free(arena_t a) { 
	if(a!=NULL){
		free(a);
	}
}

Regexp *re_alloc(arena_t a) { 
	if(a->space<=0){
		return NULL;
	}
	else{
		a->space--;
		return a->regexps++;
	}
}

Regexp *re_chr(arena_t a, char c) { 
	Regexp *re = re_alloc(a);
	if(re!=NULL){
		re->data.chr = c;
		re->type = CHR;
}
  return re;
}

Regexp *re_alt(arena_t a, Regexp *r1, Regexp *r2) { 
	Regexp *re = re_alloc(a);
	if(re!=NULL){
		re->data.pair.fst = r1;
		re->data.pair.snd = r2;
		re->type = ALT;
}
  return re;
}

Regexp *re_seq(arena_t a, Regexp *r1, Regexp *r2) { 
	Regexp *re = re_alloc(a);
	if(re!=NULL){
		re->data.pair.fst = r1;
		re->data.pair.snd = r2;
		re->type = SEQ;
}
  return re;
}

int re_match(Regexp *r, char *s, int i) { 
  int j=-1;
	if (r != NULL && i>=0 && s[i]!='\0') { 
    switch (r->type) {
    case CHR:
				if(s[i]==r->data.chr){
					return i+1;
			}
			else{
					return -1;
			}
      break;
    case SEQ:
			i = re_match(r->data.pair.fst, s, i);
			return re_match(r->data.pair.snd, s, i);
    case ALT:
			 j = re_match(r->data.pair.fst, s, i);
			return (j>=0)? j : re_match(r->data.pair.snd, s, i);
    }
  } 
	else {// null regex or invalid index into string 
			return -1;
  }
}



void re_print(Regexp *r) { 
  if (r != NULL) { 
    switch (r->type) {
    case CHR: 
      printf("%c", r->data.chr);
      break;
    case SEQ:
      if (r->data.pair.fst->type == ALT) { 
	printf("(");
	re_print(r->data.pair.fst);
	printf(")");
      } else {
	re_print(r->data.pair.fst);
      }
      if (r->data.pair.snd->type == ALT) { 
	printf("(");
	re_print(r->data.pair.snd);
	printf(")");
      } else {
	re_print(r->data.pair.snd);
      }
      break;
    case ALT:
      re_print(r->data.pair.fst);
      printf("+");
      re_print(r->data.pair.snd);
      break;
    }
  } else { 
    printf("NULL");
  }
}    


      
  
