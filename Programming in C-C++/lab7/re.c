#include <stdlib.h>
#include <stdio.h>
#include "re.h"

arena_t create_arena(int size) { 
  /* TODO */
  return NULL;
}

void arena_free(arena_t a) { 
  /* TODO */
}

Regexp *re_alloc(arena_t a) { 
  /* TODO */
  return NULL;
}

Regexp *re_chr(arena_t a, char c) { 
  /* TODO */
  return NULL;
}

Regexp *re_alt(arena_t a, Regexp *r1, Regexp *r2) { 
  /* TODO */
  return NULL;
}

Regexp *re_seq(arena_t a, Regexp *r1, Regexp *r2) { 
  /* TODO */
  return NULL;
}

int re_match(Regexp *r, char *s, int i) { 
  /* TODO */
  return -1;
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


      
  
