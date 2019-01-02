#include "avalon_addr.h"

int avalon_read(unsigned int address)
{
	volatile int *pointer = (volatile int *) address;
	return pointer[0];
}

void avalon_write(unsigned int address, int data)
{
	volatile int *pointer = (volatile int *) address;
	pointer[0] = data;
}
int rem(int a, int b);


// our pixel format in memory is 5 bits of red, 6 bits of green, 5 bits of blue
#define PIXEL16(r,g,b) (((r & 0x1F)<<11) | ((g & 0x3F)<<5) | ((b & 0x1F)<<0))
// ... but for ease of programming we refer to colours in 8/8/8 format and discard the lower bits
#define PIXEL24(r,g,b) PIXEL16((r>>3), (g>>2), (b>>3))

#define PIXEL_WHITE PIXEL24(0xFF, 0xFF, 0xFF)
#define PIXEL_BLACK PIXEL24(0x00, 0x00, 0x00)
#define PIXEL_RED   PIXEL24(0xFF, 0x00, 0x00)
#define PIXEL_GREEN PIXEL24(0x00, 0xFF, 0x00)
#define PIXEL_BLUE  PIXEL24(0x00, 0x00, 0xFF)

#define DISPLAY_WIDTH	480
#define DISPLAY_HEIGHT	272

void vid_set_pixel(int x, int y, int colour)
{
	// derive a pointer to the framebuffer described as 16 bit integers
	volatile short *framebuffer = (volatile short *) (FRAMEBUFFER_BASE);

	// make sure we don't go past the edge of the screen
	if ((x<0) || (x>DISPLAY_WIDTH-1))
		return;
	if ((y<0) || (y>DISPLAY_HEIGHT-1))
		return;

	framebuffer[x+y*DISPLAY_WIDTH] = colour;
}
void debug_print(int value)
{
	asm ("csrw	0x7B2, %0" : : "r" (value) );
}

void clear_screen(void){
	for(int x=0; x<DISPLAY_WIDTH; x++){
		for(int y=0; y<DISPLAY_HEIGHT;y++){
			vid_set_pixel(x,y, PIXEL_BLACK);
		}
	}
}
int diff(int curr, int prev){ //calculate curr-prev over discontinuity of 255
	if(curr>200 && prev<50){
		return curr-prev-256;
	}
	else if(curr<50 && prev>200){
		return curr-prev+256;
	}
	else{
		return curr-prev;
	}
}
int modulo(int num, int div){
	while(num<0){
		num+=div;
	}
	while(num>=div){
		num-=div;
	}
	return num;
}

int main(void){

	//position on screen
	int x_pos = 0;
	int y_pos = 0;
	
	//initialise rotary encoder values
	int prev_rot_left = 0x00;
	int prev_rot_right = 0x00;
	int curr_rot_left = 0x00;
	int curr_rot_right = 0x00;

	int left_click = avalon_read(PIO_BUTTONS) & BUTTONS_MASK_DIALL_CLICK;
	int right_click = avalon_read(PIO_BUTTONS) & BUTTONS_MASK_DIALR_CLICK;

	while(1){ //infinite loop to continue rendering to screen

		left_click = avalon_read(PIO_BUTTONS) & BUTTONS_MASK_DIALL_CLICK;
		right_click = avalon_read(PIO_BUTTONS) & BUTTONS_MASK_DIALR_CLICK;
		if(left_click || right_click){
			clear_screen();
		}
		curr_rot_left = avalon_read(PIO_ROTARY_L);
		curr_rot_right = avalon_read(PIO_ROTARY_R);
		

		//update position of x,y by considering relative rotary change
		x_pos = modulo(x_pos + diff(curr_rot_left,prev_rot_left), DISPLAY_WIDTH);
		y_pos = modulo(y_pos + diff(curr_rot_right,prev_rot_right),DISPLAY_HEIGHT);

		vid_set_pixel(x_pos,y_pos, PIXEL_WHITE);
		prev_rot_left = curr_rot_left;
		prev_rot_right = curr_rot_right;
	}


	return 0;
}
	

	
