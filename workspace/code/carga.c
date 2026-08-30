#include <stdio.h>

int main(void)
{
    int carga;

    if (scanf("%d", &carga) != 1)
    {
        fprintf(stderr, "Error: entrada invalida\n");
        return 1;
    }

    if (carga < 0)
    {
        fprintf(stderr, "Error: carga negativa\n");
        return 1;
    }

    int carga_respaldo = carga;

    if (carga < 100)
    {
        printf("Carga: ligera\n");
    }
    else if (carga <= 500)
    {
        printf("Carga: media\n");
    }
    else
    {
        printf("Carga: pesada\n");
    }

    return 0;
}
