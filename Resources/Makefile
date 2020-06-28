AS      = mips32-elf-as
CC      = mips32-elf-gcc
OBJDUMP = mips32-elf-objdump
OBJCOPY = mips32-elf-objcopy
ASFLAGS = -O0 -mips1 -EB
CCFLAGS = -O0 -mips1 -EB -mabi=32 -Wall -nostdlib -fno-zero-initialized-in-bss -mno-local-sdata -Wl,--section-start=.text=0x8
SRCS    = $(wildcard *.mips *.c)
_LSTS   = $(SRCS:.mips=.mem)
LSTS    = $(_LSTS:.c=.mem)
OUTDIR  = ./Products

all: $(LSTS)
	@echo $(LSTS)
	find $(OUTDIR) -size 0 -print -delete

%.mem: %.mips
	mkdir -p $(OUTDIR)
	$(AS) -o a.out $< $(ASFLAGS)
	$(OBJDUMP) -d a.out > $(OUTDIR)/$(@:.mem=.lst)

	$(OBJCOPY) --dump-section .text=a.bin a.out
	$(OBJCOPY) -I binary -O binary --reverse-bytes=4 a.bin r.bin
	od -An -v -t x4 r.bin | tr ' ' '\n' | sed '/^$$/d' > $(OUTDIR)/$@

	$(OBJCOPY) --dump-section .data=a.data a.out
	od -An -v -t x1 a.data | tr ' ' '\n' | sed '/^$$/d' > $(OUTDIR)/$(@:.mem=.data)

	rm -f a.bin a.out r.bin a.data r.data

%.mem: %.c
	mkdir -p $(OUTDIR)
	$(CC) -o a.out $< $(CCFLAGS)
	$(OBJDUMP) -d a.out > $(OUTDIR)/$(@:.mem=.lst)

	$(OBJCOPY) --dump-section .text=a.bin a.out
	$(OBJCOPY) -I binary -O binary --reverse-bytes=4 a.bin r.bin
	echo "241d1000\n241f0400\n" > $(OUTDIR)/$@
	od -An -v -t x4 r.bin | tr ' ' '\n' | sed '/^$$/d' >> $(OUTDIR)/$@

	$(OBJCOPY) --dump-section .data=a.data a.out
	od -An -v -t x1 a.data | tr ' ' '\n' | sed '/^$$/d' > $(OUTDIR)/$(@:.mem=.data)

	rm -f a.bin a.out r.bin a.data r.data

clean:
	rm -rf $(OUTDIR)
