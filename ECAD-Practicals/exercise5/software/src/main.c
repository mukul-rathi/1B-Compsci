
int rem(int a, int b);
int div(int a, int b);
int get_time(void);
void hex_output(int value)
{
	int *hex_leds = (int *) 0x04000080;  // define a pointer to the register
	*hex_leds = value;                   // write the value to that address
}
void debug_print(int value)
{
	asm ("csrw	0x7B2, %0" : : "r" (value) );
}

int BCDtime(int time){
	int mins = div(div(time,60*50*1000),1000);
	int secs = rem(div(time, 50*1000*1000),60);
	int centisecs = div(rem(time,50*1000*1000), 50*1000*10);
	int val = div(mins,10);
	val = (val<<4) + rem(mins,10);
	val = (val<<4) + div(secs,10);
	val = (val<<4) + rem(secs,10);
	val = (val<<4) + div(centisecs,10);
	val = (val<<4) + rem(centisecs,10);
	return val;
}

int main(void)
{	
	for(int i=0; i<100000000; i++){
		int time = BCDtime(get_time());
		hex_output(time);
	}
	return 0;
}
