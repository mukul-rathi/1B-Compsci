#include <stdio.h>
#include <string.h>

int main(int argc, char **argv) {
    char a[2];

    a[0] = 'a';

    if(!strcmp(a, "a")) {  //UNDEFINED as a[1] not initialised so not '\0' therefore a is not a valid string
        puts("a is \"a\"");
    }

    return 0;
}
