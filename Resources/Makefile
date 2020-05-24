AS      = mips32-elf-as
OBJDUMP = mips32-elf-objdump
OBJCOPY = mips32-elf-objcopy
BIN2HEX = mips32-elf-bin2hex
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
	$(BIN2HEX) -w 32 r.bin $(OUTDIR)/$@
	rm a.bin a.out r.bin

clean:
	rm -rf $(OUTDIR)
