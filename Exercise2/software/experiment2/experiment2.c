// Copyright by Adam Kinsman, Henry Ko and Nicola Nicolici
// Developed for the Embedded Systems course (COE4DS4)
// Department of Electrical and Computer Engineering
// McMaster University
// Ontario, Canada

#include "define.h"

int main()
{
	printf("Start main...\n");

	IOWR(LED_GREEN_O_BASE, 0, 0x0);
	IOWR(LED_RED_O_BASE, 0, 0x0);

	init_button_irq();
	printf("PB initialized...\n");
	
	init_counter_irq();
	printf("Counter IRQ initialized...\n");
	
	printf("System is up!\n");

	IOWR(LED_RED_O_BASE, 0, 0xF);

	IOWR(MY_COMPONENT_WRAPPER_0_BASE, 1, 0x50800);
	int temp = 0;
	temp = IORD(MY_COMPONENT_WRAPPER_0_BASE, 0);
	printf("Read %x from memory", temp);
	while (1);
	
	return 0;
}
