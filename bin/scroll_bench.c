// http://relaxedcolumn.blog8.fc2.com/blog-entry-167.html
// Usage: command time ./scroll_bench

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

void setline(char *s, int n)
{
    int l = random() % n;
    int j;
    for(j = 0; j < l; ++j) {
        s[j] = 'A' + (random() % 60);
    }
    s[j] = 0;
}

int main(int argc, char *argv[])
{
    int n;
    if(argc == 1) {
        n = 1000000;
    }
    else {
        n = atoi(argv[1]);
    }

    int i;
    for(i = 0; i < n; ++i) {
        char buffer[100];
        setline(buffer, sizeof(buffer) - 1);
        printf("%s\n", buffer);
        if(i % 50 == 0) {
            printf("%c[H", 27);
        }
    }

    printf("\n\n");
    return 0;
}
