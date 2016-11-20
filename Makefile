arch ?= armv7
kernel := build/plaid-$(arch).elf
kernel_img := build/plaid-$(arch).bin
target ?= $(arch)-unknown-linux-gnueabihf
rust_os := target/$(target)/debug/libPlaidOS.a

linker_script := src/arch/$(arch)/linker.ld
assembly_source_files := $(wildcard src/arch/$(arch)/*.S)
assembly_object_files := $(patsubst src/arch/$(arch)/%.S, \
	build/arch/$(arch)/%.o, $(assembly_source_files))

.PHONY: all clean run

all: $(kernel)

clean:
	@rm -r build

run: $(kernel)
	qemu-system-arm -M versatilepb -kernel $(kernel)

$(kernel): cargo $(rust_os) $(assembly_object_files) $(linker_script)
	arm-none-eabi-ld --defsym=HEAPSIZE=0x400 --defsym=STACKSIZE=0x1C000 -n -T $(linker_script) -o $(kernel) $(assembly_object_files) $(rust_os)
	arm-none-eabi-objcopy $(kernel) -O binary $(kernel_img) 

cargo:
	@xargo build --target $(target)

build/arch/$(arch)/%.o: src/arch/$(arch)/%.S
	mkdir -p $(shell dirname $@)
	arm-none-eabi-as $< -o $@
