OMICROB_OPTS=-no-shortcut-initialization
include ../../../../../etc/config.make

OMICROBC=$(BIN)/omicrob

code: main.c

main.c: main.ml
	$(OMICROBC) $(OMICROB_OPTS) -platform_dir ../.. -v -mlopt -verbose -o main.c main.ml

sim:
	./main.byte

check:
ifeq ($(QUARTUS_ROOTDIR),)
	@echo "** Do not forget to run nios2_command_shell script before invoking this makefile !"
endif

build: check main.c
	make -f Makefile.platform

run: check main.elf
	make -f Makefile.platform download-elf && nios2-terminal

term: check
	nios2-terminal

clean: 
	@rm -f *.cmo *.cmi
	@rm -f *.c *.byte
	@rm -f *.elf *.map *.objdump 
	@rm -rf obj
	@rm -f Makefile Makefile.platform
	@rm -f *~ 
