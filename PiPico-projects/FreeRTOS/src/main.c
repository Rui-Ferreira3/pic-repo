#include <stdio.h>

#include "pico/stdlib.h"
#include "hardware/gpio.h"

#include "FreeRTOS.h"
#include "FreeRTOSConfig.h"
#include "task.h"

#define LED_PIN 25

#define GPIO_ON     1
#define GPIO_OFF    0

void BlinkLEDTask(void *param) {
    while(true) {
        gpio_put(LED_PIN, GPIO_ON);
        vTaskDelay(1000);
        gpio_put(LED_PIN, GPIO_OFF);
        vTaskDelay(1000);
    }
}

void printHelloWorldTask(void *param) {
    while(true) {
        printf("Hello, world!\n");
        vTaskDelay(5000);
    }
}

int main() 
{
    stdio_init_all();

    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);

    TaskHandle_t LEDtask = NULL;
    TaskHandle_t pHelloWorldtask = NULL;

    uint32_t status = xTaskCreate(
                    printHelloWorldTask,
                    "Hello World",
                    1024,
                    NULL,
                    1,
                    &pHelloWorldtask);

    status = xTaskCreate(
                    BlinkLEDTask,
                    "LED",
                    1024,
                    NULL,
                    tskIDLE_PRIORITY,
                    &LEDtask);

    vTaskStartScheduler();

    for( ;; )
    {
        //should never get here
    }

}