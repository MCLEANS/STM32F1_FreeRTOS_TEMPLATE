
# list of source files
#CXX SOURCE_FILES
CXX_SOURCES = main.cpp

CXX_OBJS += main.o

#C SOURCE FILES
#SOURCES  = main.c
SOURCES  += ./dependencies/system_stm32f10x.c
#SOURCES += ./dependencies/stm32f10x_it.c
SOURCES += ./startup/startup_stm32f10x_md.s
#FreeRTOS dependencies
SOURCES += ./FreeRTOS/Source/croutine.c
SOURCES += ./FreeRTOS/Source/event_groups.c
SOURCES += ./FreeRTOS/Source/list.c 
SOURCES += ./FreeRTOS/Source/queue.c 
SOURCES += ./FreeRTOS/Source/stream_buffer.c 
SOURCES += ./FreeRTOS/Source/tasks.c 
SOURCES += ./FreeRTOS/Source/timers.c 
SOURCES += ./FreeRTOS/Source/portable/GCC/ARM_CM3/port.c
SOURCES += ./FreeRTOS/Source/portable/MemMang/heap_4.c

CC_OBJS += system_stm32f10x.o
#CC_OBJS += stm32f10x_it.o
CC_OBJS += startup_stm32f10x_md.o
CC_OBJS += croutine.o
CC_OBJS += event_groups.o
CC_OBJS += list.o
CC_OBJS += queue.o
CC_OBJS += stream_buffer.o
CC_OBJS += tasks.o
CC_OBJS += timers.o
CC_OBJS += port.o
CC_OBJS += heap_4.o

# name for output binary files
PROJECT = main

# compiler, objcopy (should be in PATH)
CC = arm-none-eabi-gcc
CXX = arm-none-eabi-g++
OBJCOPY = arm-none-eabi-objcopy

# path to st-flash (or should be specified in PATH)
ST_FLASH = st-flash

# specify compiler flags
CFLAGS  = -g -O2 -Wall -c
CFLAGS += -T  stm32_flash.ld -specs=nano.specs -specs=nosys.specs
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m3 -mthumb-interwork
CFLAGS += -mfloat-abi=soft -mfpu=fpv4-sp-d16
CFLAGS += -DSTM32F10X_MD 
CFLAGS += -Wl,--gc-sections
CFLAGS += -I ./Includes
CFLAGS += -I .
CFLAGS += -I ./FreeRTOS/Source/portable/GCC/ARM_CM3
CFLAGS += -I ./FreeRTOS/Source/include/

LD_FLAGS = -mlittle-endian -mthumb
LD_FLAGS += -DSTM32F10X_MD  -T  stm32_flash.ld
LD_FLAGS +=  -mfpu=fpv4-sp-d16 -specs=nano.specs -specs=nosys.specs
LD_FLAGS += -Wl,--gc-sections

all: $(PROJECT).elf

# compile
$(PROJECT).elf: $(CXX_SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) 
	$(CXX) $(CFLAGS) $(CXX_SOURCES) 
	$(CXX) $(LD_FLAGS) $(CC_OBJS) $(CXX_OBJS) -o $@ 
	$(OBJCOPY) -O ihex $(PROJECT).elf $(PROJECT).hex
	$(OBJCOPY) -O binary $(PROJECT).elf $(PROJECT).bin

# remove binary files
clean:
	rm -f *.o *.elf *.hex *.bin

# flash
flash:
	sudo $(ST_FLASH) write $(PROJECT).bin 0x8000000
