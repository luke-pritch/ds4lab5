#include "define.h"


void handle_my_component_interrupts(){
	int local_val;
	local_val = IORD(MY_COMPONENT_0_BASE, 2);
	printf("I can read this from my IRQ memory:%x\n", local_val);
	IOWR(MY_COMPONENT_0_BASE, 3, 0);
}

void init_my_component_irq(){
	IOWR(MY_COMPONENT_0_BASE, 3, 0);
	alt_irq_register(MY_COMPONENT_0_IRQ, NULL, (void*)handle_my_component_interrupts );
}


