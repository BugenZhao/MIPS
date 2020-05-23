AS      = mips32-elf-as
OBJDUMP = mips32-elf-objdump
ASFLAGS = -O0 -mips32 -EB
SRCS    = $(wildcard *.mips)
LSTS    = $(SRCS:.mips=.lst)

all: $(LSTS)

%.lst:%.mips
	$(AS) $< $(ASFLAGS)
	$(OBJDUMP) -d a.out > $@
	rm a.out

clean:
	rm -f *.out *.lst *.bin
