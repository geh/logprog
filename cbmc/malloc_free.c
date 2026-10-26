void f (_Bool i)
{
    int *p, y;
    p = malloc(sizeof(int)*10);
    if (i) p = &y;
    free(p);
}
