#!/bin/bash

DEVICE=25k
PIN_DEF=ulx3s_v20.lpf
IDCODE=0x21111043 # 12f
PACKAGE=CABGA381
TOP=Logic_Sniffer
NAME=sniffer

SRCS="../src/async_fifo.v ../src/BRAM4k8bit.v ../src/controller.v ../src/core.v ../src/data_align.v ../src/decoder.v ../src/delay_fifo.v ../src/demux.v ../src/filter.v ../src/flags.v ../src/iomodules.v ../src/Logic_Sniffer.v ../src/meta.v ../src/regs.v ../src/rle_enc.v ../src/sampler.v ../src/serial_receiver.v ../src/serial_transmitter.v ../src/serial.v ../src/sram_interface.v ../src/stage.v ../src/sync.v ../src/trigger.v ../src/ecp5_pll.v"

./clean.sh

yosys -q -f "verilog -Dulx3s" -l ${NAME}.log -p "synth_ecp5 -top ${TOP} -abc2 -json ${NAME}.json" ${SRCS}
nextpnr-ecp5 --${DEVICE} --freq 50 --package ${PACKAGE} --lpf ${PIN_DEF} --json ${NAME}.json --textcfg ${NAME}.config
ecppack --idcode ${IDCODE} ${NAME}.config ${NAME}.bit
