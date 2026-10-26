int loop(int a){
	int i,r;
	r = 0;
	for(i=0;i<a;i++) r +=2;
	return r;
	__CPROVER_assert( r == 2*a,"In the function");
}

int main(void){
	int a;
	a = loop(10);
	__CPROVER_assert( a == 20,"It really works");
	__CPROVER_assert( a = 0,"That should fail");
}
