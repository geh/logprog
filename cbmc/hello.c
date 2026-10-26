// aryt.c
main() 
{
  int x;
  int y = 8, z = 0, w = 0;
  if (x) z = y - 1; else w = y + 1;
  assert (z == 5 || w == 9);
  __CPROVER_assert (z==7 || w == 9, "This is more reasonable");
}
