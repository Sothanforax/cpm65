MEMORY {
    zp : ORIGIN = 2, LENGTH = 0x8e
    ram (rw) : ORIGIN = 0x800, LENGTH = 0x1000
	bootstrap (rw) : ORIGIN = 0x6000, LENGTH = 0x2000
}

SECTIONS {
	.zp : {
		*(.zp .zp.*)
		__USERZEROPAGE_START__ = .;
		__USERZEROPAGE_END__ = 0xff;

		. = 0x80;
		*(.loaderzp)
	} >zp

	.bootstrap : {
		*(.bootstrap)
		*(.init)
		bios_load_addr = .;
	} >bootstrap
	
	.text : {
		bios_exec_addr = .;
		*(.text .text.*)
	} >ram AT>bootstrap
	
	.data : {
		 . = ALIGN(16);
		 *(.aligned.16)
		*(.data .data.* .rodata .rodata.*)
		bios_end_addr = .;
	} >ram AT>bootstrap
	
	.noinit (NOLOAD) : {
		*(.bss .bss.*)
		*(.noinit .noinit.*)
		. = ALIGN(256);
		__USERTPA_START__ = .;
		__USERTPA_END__ = 0xff00;
	} >ram AT>bootstrap
}

OUTPUT_FORMAT {
	TRIM(bootstrap)
}

