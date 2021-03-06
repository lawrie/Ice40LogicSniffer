#!/bin/bash

TOP=Logic_Sniffer
NAME=sniffer
PACKAGE=tq144:4k

# ../src/trigger_adv.v

SRCS="../src/async_fifo.v ../src/BRAM4k8bit.v ../src/controller.v ../src/core.v ../src/data_align.v ../src/decoder.v ../src/delay_fifo.v ../src/demux.v ../src/filter.v ../src/flags.v ../src/iomodules.v ../src/Logic_Sniffer.v ../src/meta.v ../src/regs.v ../src/rle_enc.v ../src/sampler.v ../src/serial_receiver.v ../src/serial_transmitter.v ../src/serial.v ../src/sram_interface.v ../src/stage.v ../src/sync.v ../src/trigger.v"

./clean.sh

yosys -q -f "verilog -Duse_sb_io" -l ${NAME}.log -p "synth_ice40 -top ${TOP} -abc2 -json ${NAME}.json" ${SRCS}
nextpnr-ice40 --hx8k --freq 25 --package ${PACKAGE} --pcf blackice.pcf --json ${NAME}.json --asc ${NAME}.txt --placer heap --opt-timing
icepack ${NAME}.txt ${NAME}.bin
icetime -d hx8k -P ${PACKAGE} -t ${NAME}.txt
truncate -s 135104 ${NAME}.bin
