EXTERN(vt)
ENTRY(Reset_Handler)

MEMORY
{
    flash (rx) : ORIGIN = 0x08000000, LENGTH = 128K
    ram (rwx) : ORIGIN = 0x20000000, LENGTH = 36K
}

SECTIONS
{
    .text : ALIGN(4) {
        KEEP(*(.vt))
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
        _etext = .;
    } > flash

    /* Shift .data load address to avoid overlap */
    .data : ALIGN(4) {
        _data = .;
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

PROVIDE(_stack = ORIGIN(ram) + LENGTH(ram));

