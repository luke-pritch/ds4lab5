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

	IOWR(MY_COMPONENT_0_BASE, 1, 0x250ffff);
	IOWR(MY_COMPONENT_0_BASE, 1, 0x2801234);
	IOWR(MY_COMPONENT_0_BASE, 1, 0x0501111);
	int temp;
	temp = IORD(MY_COMPONENT_0_BASE, 0);
	printf("I wrote %x\n", temp);

	init_my_component_irq();
	IOWR(MY_COMPONENT_0_BASE, 3, 0xfff00001);

	IOWR(LED_RED_O_BASE, 0, 0xF);

		
	while (1);
	
	return 0;
}
