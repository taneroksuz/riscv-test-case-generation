/*======================================================================*/
/* Proxy kernel linker script                                           */
/*======================================================================*/
/* This is the linker script used when building the proxy kernel. */

/*----------------------------------------------------------------------*/
/* Setup                                                                */
/*----------------------------------------------------------------------*/

/* The OUTPUT_ARCH command specifies the machine architecture where the
   argument is one of the names used in the BFD library. More
   specifically one of the entires in bfd/cpu-mips.c */

OUTPUT_ARCH( "riscv" )
ENTRY(rvtest_entry_point)

MEMORY
{
  iram : ORIGIN = 0x000000, LENGTH = 2M
  dram : ORIGIN = 0x200000, LENGTH = 2M
}

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/

SECTIONS
{

  /* text: test code section */
  .text.init : {
    . = 0x0;
    *(.text.init)
  } > iram

  .text : { *(.text) } > iram

  /* data segment */
  .rodata : { *(.rodata) } > dram

  /* data segment */
  .data : { *(.data) } > dram

  .sdata : {
    __global_pointer$ = . + 0x800;
    *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  } > dram

  /* bss segment */
  .sbss : {
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
  } > dram
  .bss : { *(.bss) } > dram

  /* thread-local data segment */
  .tdata :
  {
    _tdata_begin = .;
    *(.tdata)
    _tdata_end = .;
  } > dram
  .tbss :
  {
    *(.tbss)
    _tbss_end = .;
    /* End of uninitalized data segement */
    _end = .;
  } > dram

  .tohost : {
    . = ALIGN(0x1000);
    *(.tohost)
  } > dram
}
