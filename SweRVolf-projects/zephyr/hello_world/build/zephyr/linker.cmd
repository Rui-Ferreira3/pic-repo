 OUTPUT_ARCH("riscv")
 OUTPUT_FORMAT("elf32-littleriscv")
MEMORY
{
    RAM (rwx) : ORIGIN = 0x0, LENGTH = ((8192) << 10)
    IDT_LIST (wx) : ORIGIN = 0xFFFFF7FF, LENGTH = 2K
}
ENTRY("__start")
SECTIONS
    {
 .rel.plt :
 {
 *(.rel.plt)
 PROVIDE_HIDDEN (__rel_iplt_start = .);
 *(.rel.iplt)
 PROVIDE_HIDDEN (__rel_iplt_end = .);
 }
 .rela.plt :
 {
 *(.rela.plt)
 PROVIDE_HIDDEN (__rela_iplt_start = .);
 *(.rela.iplt)
 PROVIDE_HIDDEN (__rela_iplt_end = .);
 }
 .rel.dyn :
 {
 *(.rel.*)
 }
 .rela.dyn :
 {
 *(.rela.*)
 }
    .plt :
 {
  *(.plt)
 }
    .iplt :
 {
  *(.iplt)
 }
   
    _image_rom_start = .;
    vector :
    {
  . = ALIGN(4);
  KEEP(*(.vectors.*))
    } > RAM
    reset :
    {
  KEEP(*(.reset.*))
    } > RAM
    exceptions :
    {
   KEEP(*(".exception.entry.*"))
   *(".exception.other.*")
    } > RAM
    text :
 {
  . = ALIGN(4);
  KEEP(*(.openocd_debug))
  KEEP(*(".openocd_debug.*"))
  _image_text_start = .;
  *(.text)
  *(".text.*")
  *(.gnu.linkonce.t.*)
  *(.eh_frame)
 } > RAM
    _image_text_end = .;
 initlevel :
 {
  __init_start = .;
  __init_PRE_KERNEL_1_start = .; KEEP(*(SORT(.init_PRE_KERNEL_1[0-9]*))); KEEP(*(SORT(.init_PRE_KERNEL_1[1-9][0-9]*)));
  __init_PRE_KERNEL_2_start = .; KEEP(*(SORT(.init_PRE_KERNEL_2[0-9]*))); KEEP(*(SORT(.init_PRE_KERNEL_2[1-9][0-9]*)));
  __init_POST_KERNEL_start = .; KEEP(*(SORT(.init_POST_KERNEL[0-9]*))); KEEP(*(SORT(.init_POST_KERNEL[1-9][0-9]*)));
  __init_APPLICATION_start = .; KEEP(*(SORT(.init_APPLICATION[0-9]*))); KEEP(*(SORT(.init_APPLICATION[1-9][0-9]*)));
  __init_SMP_start = .; KEEP(*(SORT(.init_SMP[0-9]*))); KEEP(*(SORT(.init_SMP[1-9][0-9]*)));
  __init_end = .;
 } > RAM
 sw_isr_table :
 {
  . = ALIGN(0);
  *(.gnu.linkonce.sw_isr_table*)
 } > RAM
 initlevel_error :
 {
  KEEP(*(SORT(.init_[_A-Z0-9]*)))
 }
 ASSERT(SIZEOF(initlevel_error) == 0, "Undefined initialization levels used.")
 app_shmem_regions :
 {
  __app_shmem_regions_start = .;
  KEEP(*(SORT(.app_regions.*)));
  __app_shmem_regions_end = .;
 } > RAM
 bt_l2cap_fixed_chan_area : SUBALIGN(4) { _bt_l2cap_fixed_chan_list_start = .; KEEP(*(SORT(._bt_l2cap_fixed_chan.static.*))); _bt_l2cap_fixed_chan_list_end = .; } > RAM
 bt_gatt_service_static_area : SUBALIGN(4) { _bt_gatt_service_static_list_start = .; KEEP(*(SORT(._bt_gatt_service_static.static.*))); _bt_gatt_service_static_list_end = .; } > RAM
 log_const_sections :
 {
  __log_const_start = .;
  KEEP(*(SORT(.log_const_*)));
  __log_const_end = .;
 } > RAM
 log_backends_sections :
 {
  __log_backends_start = .;
  KEEP(*("._log_backend.*"));
  __log_backends_end = .;
 } > RAM
 shell_area : SUBALIGN(4) { _shell_list_start = .; KEEP(*(SORT(._shell.static.*))); _shell_list_end = .; } > RAM
 shell_root_cmds_sections :
 {
  __shell_root_cmds_start = .;
  KEEP(*(SORT(.shell_root_cmd_*)));
  __shell_root_cmds_end = .;
 } > RAM
 font_entry_sections :
 {
  __font_entry_start = .;
  KEEP(*(SORT("._cfb_font.*")))
  __font_entry_end = .;
 } > RAM
 tracing_backend_area : SUBALIGN(4) { _tracing_backend_list_start = .; KEEP(*(SORT(._tracing_backend.static.*))); _tracing_backend_list_end = .; } > RAM
    rodata :
 {
   . = ALIGN(4);
   *(.srodata)
   *(".srodata.*")
   *(.rodata)
   *(".rodata.*")
   *(.gnu.linkonce.r.*)
 } > RAM
    _image_rom_end = .;
    __data_rom_start = .;
   
   
    datas :
 {
   . = ALIGN(4);
   _image_ram_start = .;
   __data_ram_start = .;
   *(.data)
   *(".data.*")
   *(.sdata .sdata.* .gnu.linkonce.s.*)
   *(.sdata2 .sdata2.* .gnu.linkonce.s2.*)
 } > RAM
 devices :
 {
  __device_start = .;
  __device_PRE_KERNEL_1_start = .; KEEP(*(SORT(.device_PRE_KERNEL_1[0-9]*))); KEEP(*(SORT(.device_PRE_KERNEL_1[1-9][0-9]*)));
  __device_PRE_KERNEL_2_start = .; KEEP(*(SORT(.device_PRE_KERNEL_2[0-9]*))); KEEP(*(SORT(.device_PRE_KERNEL_2[1-9][0-9]*)));
  __device_POST_KERNEL_start = .; KEEP(*(SORT(.device_POST_KERNEL[0-9]*))); KEEP(*(SORT(.device_POST_KERNEL[1-9][0-9]*)));
  __device_APPLICATION_start = .; KEEP(*(SORT(.device_APPLICATION[0-9]*))); KEEP(*(SORT(.device_APPLICATION[1-9][0-9]*)));
  __device_SMP_start = .; KEEP(*(SORT(.device_SMP[0-9]*))); KEEP(*(SORT(.device_SMP[1-9][0-9]*)));
  __device_end = .;
  FILL(0x00); __device_init_status_start = .; . = . + (((((__device_end - __device_start) / 0x10) + 31) / 32) * 4); __device_init_status_end = .;
 
 } > RAM
 initshell :
 {
  __shell_module_start = .;
  KEEP(*(".shell_module_*"));
  __shell_module_end = .;
  __shell_cmd_start = .;
  KEEP(*(".shell_cmd_*"));
  __shell_cmd_end = .;
 } > RAM
 log_dynamic_sections :
 {
  __log_dynamic_start = .;
  KEEP(*(SORT(.log_dynamic_*)));
  __log_dynamic_end = .;
 } > RAM
 _static_thread_data_area : SUBALIGN(4) { __static_thread_data_list_start = .; KEEP(*(SORT(.__static_thread_data.static.*))); __static_thread_data_list_end = .; } > RAM
 k_timer_area : SUBALIGN(4) { _k_timer_list_start = .; *(SORT(._k_timer.static.*)); _k_timer_list_end = .; } > RAM
 k_mem_slab_area : SUBALIGN(4) { _k_mem_slab_list_start = .; *(SORT(._k_mem_slab.static.*)); _k_mem_slab_list_end = .; } > RAM
 k_mem_pool_area : SUBALIGN(4) { _k_mem_pool_list_start = .; *(SORT(._k_mem_pool.static.*)); _k_mem_pool_list_end = .; } > RAM
 k_heap_area : SUBALIGN(4) { _k_heap_list_start = .; *(SORT(._k_heap.static.*)); _k_heap_list_end = .; } > RAM
 k_mutex_area : SUBALIGN(4) { _k_mutex_list_start = .; *(SORT(._k_mutex.static.*)); _k_mutex_list_end = .; } > RAM
 k_stack_area : SUBALIGN(4) { _k_stack_list_start = .; *(SORT(._k_stack.static.*)); _k_stack_list_end = .; } > RAM
 k_msgq_area : SUBALIGN(4) { _k_msgq_list_start = .; *(SORT(._k_msgq.static.*)); _k_msgq_list_end = .; } > RAM
 k_mbox_area : SUBALIGN(4) { _k_mbox_list_start = .; *(SORT(._k_mbox.static.*)); _k_mbox_list_end = .; } > RAM
 k_pipe_area : SUBALIGN(4) { _k_pipe_list_start = .; *(SORT(._k_pipe.static.*)); _k_pipe_list_end = .; } > RAM
 k_sem_area : SUBALIGN(4) { _k_sem_list_start = .; *(SORT(._k_sem.static.*)); _k_sem_list_end = .; } > RAM
 k_queue_area : SUBALIGN(4) { _k_queue_list_start = .; *(SORT(._k_queue.static.*)); _k_queue_list_end = .; } > RAM
 _net_buf_pool_area : SUBALIGN(4)
 {
  _net_buf_pool_list = .;
  KEEP(*(SORT("._net_buf_pool.static.*")))
 } > RAM
    __data_ram_end = .;
    bss (NOLOAD) :
 {
   . = ALIGN(4);
   __bss_start = .;
   *(.sbss)
   *(".sbss.*")
   *(.bss)
   *(".bss.*")
   *(COMMON)
    __bss_end = ALIGN(4);
 } > RAM
noinit (NOLOAD) :
{
        *(.noinit)
        *(".noinit.*")
} > RAM
     _image_ram_end = .;
     _end = .;
.intList :
{
 KEEP(*(.irq_info*))
 KEEP(*(.intList*))
} > IDT_LIST
    
 .stab 0 : { *(.stab) }
 .stabstr 0 : { *(.stabstr) }
 .stab.excl 0 : { *(.stab.excl) }
 .stab.exclstr 0 : { *(.stab.exclstr) }
 .stab.index 0 : { *(.stab.index) }
 .stab.indexstr 0 : { *(.stab.indexstr) }
 .gnu.build.attributes 0 : { *(.gnu.build.attributes .gnu.build.attributes.*) }
 .comment 0 : { *(.comment) }
 .debug 0 : { *(.debug) }
 .line 0 : { *(.line) }
 .debug_srcinfo 0 : { *(.debug_srcinfo) }
 .debug_sfnames 0 : { *(.debug_sfnames) }
 .debug_aranges 0 : { *(.debug_aranges) }
 .debug_pubnames 0 : { *(.debug_pubnames) }
 .debug_info 0 : { *(.debug_info .gnu.linkonce.wi.*) }
 .debug_abbrev 0 : { *(.debug_abbrev) }
 .debug_line 0 : { *(.debug_line .debug_line.* .debug_line_end ) }
 .debug_frame 0 : { *(.debug_frame) }
 .debug_str 0 : { *(.debug_str) }
 .debug_loc 0 : { *(.debug_loc) }
 .debug_macinfo 0 : { *(.debug_macinfo) }
 .debug_weaknames 0 : { *(.debug_weaknames) }
 .debug_funcnames 0 : { *(.debug_funcnames) }
 .debug_typenames 0 : { *(.debug_typenames) }
 .debug_varnames 0 : { *(.debug_varnames) }
 .debug_pubtypes 0 : { *(.debug_pubtypes) }
 .debug_ranges 0 : { *(.debug_ranges) }
 .debug_macro 0 : { *(.debug_macro) }
    /DISCARD/ : { *(.note.GNU-stack) }
    .riscv.attributes 0 :
 {
 KEEP(*(.riscv.attributes))
 KEEP(*(.gnu.attributes))
 }
}
