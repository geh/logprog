int nondet_int();
 
/** GLOBALS */
int buf[4];
int hi = 0;
int lo = 0;
int size = 4;
 
/** FUNCTION enqueue */
void enqueue (int x)
{
    buf [hi] = x;
    hi = (hi + 1);
}
 
/** FUNCTION dequeue */
int dequeue ()
{
    int res = buf [lo];
    lo = (lo + 1);
    return res;
}
 
/** FUNCTION queue_test */
void queue_test (void)
{
    while (nondet_int ()) {
        if (nondet_int ()) {
            int x = nondet_int ();
            enqueue (x);
        }
        else
            dequeue ();
    }
}
