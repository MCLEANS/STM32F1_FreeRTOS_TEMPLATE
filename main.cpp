#include "stm32f10x.h"
#include <FreeRTOS.h>
#include <task.h>
#include <portmacro.h>

TaskHandle_t blink_task;

void blinky(void* pvParam){
  while(1){
    GPIOC->ODR ^= (1<<13);
    vTaskDelay(pdMS_TO_TICKS(100));
  }
}

int main(void) {

  /* Enable GPIO RCC */
  RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;
  /* Configure to output mode */
  GPIOC->CRH |= GPIO_CRH_MODE13;
  /* Configure to General Purpose Push Pull */
  GPIOC->CRH &= ~GPIO_CRH_CNF13;

  xTaskCreate(blinky,
              "Led Blinker",
              100,
              NULL,
              1,
              &blink_task);

  vTaskStartScheduler();

  while(1){
  }
}