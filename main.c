#include <kos.h>

KOS_INIT_FLAGS(INIT_DEFAULT);

int main(int argc, char **argv) {
    dbgio_dev_default();
    printf("Dziala na konsoli Sega Dreamcast!\n");
    
    while(1) {
        // Główna pętla gry (narazie pusta)
    }
    return 0;
}
