#!/bin/bash
set -e

export RISCV=$1
export MARCH=$2
export MABI=$3
export PYTHON=$4
export OFFSET=$5
export BASEDIR=$6
export OVP=$7

ELF2COE=$BASEDIR/soft/py/64bit/elf2coe.py
ELF2DAT=$BASEDIR/soft/py/64bit/elf2dat.py
ELF2MIF=$BASEDIR/soft/py/64bit/elf2mif.py
ELF2HEX=$BASEDIR/soft/py/64bit/elf2hex.py

if [ ! -d "${BASEDIR}/build" ]; then
  mkdir ${BASEDIR}/build
fi

rm -rf ${BASEDIR}/build/ovp
mkdir ${BASEDIR}/build/ovp

mkdir ${BASEDIR}/build/ovp/elf
mkdir ${BASEDIR}/build/ovp/dump
mkdir ${BASEDIR}/build/ovp/coe
mkdir ${BASEDIR}/build/ovp/dat
mkdir ${BASEDIR}/build/ovp/mif
mkdir ${BASEDIR}/build/ovp/hex

if [ -d "${BASEDIR}/soft/src/riscv-ovp" ]; then
  rm -rf ${BASEDIR}/soft/src/riscv-ovp
fi

if [ ! -f "${OVP}" ]; then
  echo "${OVP} not exist"
  exit
fi

unzip ${OVP} -d ${BASEDIR}/soft/src/riscv-ovp

cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-env/*.h ${BASEDIR}/soft/src/ovp/env/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-env/p ${BASEDIR}/soft/src/ovp/env/

cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/env/*.h ${BASEDIR}/soft/src/ovp/env/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv32i_m/C/src/* ${BASEDIR}/soft/src/ovp/rv32c/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv32i_m/I/src/* ${BASEDIR}/soft/src/ovp/rv32i/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv32i_m/M/src/* ${BASEDIR}/soft/src/ovp/rv32m/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv32i_m/Zba/src/* ${BASEDIR}/soft/src/ovp/rv32b/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv32i_m/Zbb/src/* ${BASEDIR}/soft/src/ovp/rv32b/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv32i_m/Zbc/src/* ${BASEDIR}/soft/src/ovp/rv32b/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv32i_m/Zbs/src/* ${BASEDIR}/soft/src/ovp/rv32b/

cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv64i_m/C/src/* ${BASEDIR}/soft/src/ovp/rv64c/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv64i_m/I/src/* ${BASEDIR}/soft/src/ovp/rv64i/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv64i_m/M/src/* ${BASEDIR}/soft/src/ovp/rv64m/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv64i_m/Zba/src/* ${BASEDIR}/soft/src/ovp/rv64b/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv64i_m/Zbb/src/* ${BASEDIR}/soft/src/ovp/rv64b/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv64i_m/Zbc/src/* ${BASEDIR}/soft/src/ovp/rv64b/
cp -r ${BASEDIR}/soft/src/riscv-ovp/imperas-riscv-tests/riscv-test-suite/rv64i_m/Zbs/src/* ${BASEDIR}/soft/src/ovp/rv64b/

make -f ${BASEDIR}/soft/src/ovp/Makefile || exit

shopt -s nullglob
for filename in ${BASEDIR}/build/ovp/elf/rv32*.dump; do
  echo $filename
  ${PYTHON} ${ELF2COE} ${filename%.dump} 0x0 ${OFFSET} ${BASEDIR}/build/ovp
  ${PYTHON} ${ELF2DAT} ${filename%.dump} 0x0 ${OFFSET} ${BASEDIR}/build/ovp
  ${PYTHON} ${ELF2MIF} ${filename%.dump} 0x0 ${OFFSET} ${BASEDIR}/build/ovp
  ${PYTHON} ${ELF2HEX} ${filename%.dump} 0x0 ${OFFSET} ${BASEDIR}/build/ovp
done

shopt -s nullglob
for filename in ${BASEDIR}/build/ovp/elf/rv32*.dump; do
  mv ${filename} ${BASEDIR}/build/ovp/dump/
done
