# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    dut._log.info("Check initial seed value")
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value.integer == 1, f"Expected seed=1, got {dut.uo_out.value.integer}"

    # Now check that LFSR is shifting
    prev = dut.uo_out.value.integer
    await ClockCycles(dut.clk, 1)
    new = dut.uo_out.value.integer
    assert new != prev, f"LFSR did not shift: prev={prev}, new={new}"

    dut._log.info(f"LFSR shifted from {prev} to {new}")

    # Run for a few more cycles to make sure values change
    for i in range(5):
        prev = dut.uo_out.value.integer
        await ClockCycles(dut.clk, 1)
        new = dut.uo_out.value.integer
        dut._log.info(f"Cycle {i}: LFSR={new}")
        assert new != prev, "LFSR stuck at same value"

