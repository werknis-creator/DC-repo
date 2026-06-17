#include <kos.h>

KOS_INIT_FLAGS(INIT_DEFAULT);

int main(int argc, char **argv) {
    dbgio_dev_default();
    printf("Działa na konsoli!\n");
    
    while(1) {
        // Tu będziemy pisać główną pętlę gry
    }
    return 0;
}
