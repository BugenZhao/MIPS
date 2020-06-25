AS      = mips32-elf-as
OBJDUMP = mips32-elf-objdump
OBJCOPY = mips32-elf-objcopy
ASFLAGS = -O0 -mips1 -EB
SRCS    = $(wildcard *.mips)
LSTS    = $(SRCS:.mips=.mem)
OUTDIR  = ./Products

all: $(LSTS)

%.mem: %.mips
	mkdir -p $(OUTDIR)
	$(AS) -o a.out $< $(ASFLAGS)
	$(OBJDUMP) -d a.out > $(OUTDIR)/$(@:.mem=.lst)
	$(OBJCOPY) --dump-section .text=a.bin a.out
	$(OBJCOPY) -I binary -O binary --reverse-bytes=4 a.bin r.bin
	od -An -v -t x4 r.bin | tr ' ' '\n' | sed '/^$$/d' > $(OUTDIR)/$@
	sed '/00000000/d' $(OUTDIR)/$@ > $(OUTDIR)/$(@:.mem=_compact.mem)
	rm a.bin a.out r.bin

%.mem: %.c
	mkdir -p $(OUTDIR)
	$(CC) -o a.out $< $(CCFLAGS)
	$(OBJDUMP) -d a.out > $(OUTDIR)/$(@:.mem=.lst)
	$(OBJCOPY) --dump-section .text=a.bin a.out
	$(OBJCOPY) -I binary -O binary --reverse-bytes=4 a.bin r.bin
	echo "241d0100\n241f0400\n" > $(OUTDIR)/$@
	od -An -v -t x4 r.bin | tr ' ' '\n' | sed '/^$$/d' >> $(OUTDIR)/$@
	sed '/00000000/d' $(OUTDIR)/$@ > $(OUTDIR)/$(@:.mem=_compact.mem)
	rm a.bin a.out r.bin

clean:
	rm -rf $(OUTDIR)
