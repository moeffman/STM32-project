EXTERN(vector_table)
ENTRY(Reset_Handler)

MEMORY
{
    flash (rx) : ORIGIN = 0x08000000, LENGTH = 16K
    ram (rwx) : ORIGIN = 0x20000000, LENGTH = 36K
}

SECTIONS
{
    .text : ALIGN(4) {
        KEEP(*(.vector_table))
        _stext = .;
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
        _etext = .;
    } > flash

    .data : ALIGN(4) {
        _sdata = .;
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > ram AT > flash

    _data_loadaddr = LOADADDR(.data);

    .bss : ALIGN(4) {
        _sbss = .;
        __bss_start__ = _sbss;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
        __bss_end__ = _ebss;
    } > ram

    .noinit (NOLOAD) : {
        *(.noinit*)
    } > ram

    . = ALIGN(4);
    end = .;
}

PROVIDE(_sstack = ORIGIN(ram));
PROVIDE(_estack = ORIGIN(ram) + LENGTH(ram));
