cmake_minimum_required(VERSION 3.12)

# Import Pico SDK
include(pico_sdk_import.cmake)
project(main)

# Initialize the SDK
pico_sdk_init()

add_executable(main
    src/main.c
)

FILE(GLOB FreeRTOS_src FreeRTOS-Kernel/*.c)

add_library(FreeRTOS STATIC
    ${FreeRTOS_src}
    FreeRTOS-Kernel/portable/GCC/ARM_CM0/port.c
    FreeRTOS-Kernel/portable/MemMang/heap_4.c
)

target_include_directories(FreeRTOS PUBLIC
    FreeRTOS-Kernel/include
    include
    FreeRTOS-Kernel/portable/GCC/ARM_CM0
)

target_link_libraries(main
    pico_stdlib
    hardware_gpio
    FreeRTOS
)

# enable usb output, uart output
pico_enable_stdio_usb(main 1)
pico_enable_stdio_uart(main 1)

pico_add_extra_outputs(main)