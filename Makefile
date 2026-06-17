TARGET = gra.elf
OBJS = main.o

include $(KOS_BASE)/Makefile.rules

all: $(TARGET) 1st_read.bin

1st_read.bin: $(TARGET)
	$(KOS_OBJCOPY) -R .stack -O binary $(TARGET) 1st_read.bin

clean:
	rm -f $(TARGET) $(OBJS) 1st_read.bin
