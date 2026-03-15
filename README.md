# 🚀 32-Bit Pipelined RISC-V Processor

[![Verilog](https://img.shields.io/badge/Language-Verilog_HDL-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![Architecture](https://img.shields.io/badge/Architecture-RISC--V-orange.svg)](https://riscv.org/)
[![Status](https://img.shields.io/badge/Status-Verified-success.svg)](#)

## 📋 Overview
This project implements a synthesizable **32-bit RISC-V processor** using a classic 5-stage pipeline architecture. The design is written in **Verilog HDL** and includes a dedicated hazard control unit to intelligently handle structural and data hazards, ensuring correct instruction execution without loss of cycle efficiency.

The implementation demonstrates the core concepts of modern processor design including pipelining, advanced hazard management, and Register Transfer Level (RTL) hardware development.

---

## 🏗️ Architecture Layout
The processor follows the standard five-stage RISC pipeline, sustained by intermediate pipeline registers to maintain proper instruction flow.

- **IF (Instruction Fetch):** Fetches the target instruction from instruction memory.
- **ID (Instruction Decode):** Decodes the instruction and simultaneously reads the register file.
- **EX (Execute):** Performs ALU (Arithmetic Logic Unit) operations and computes branch targets.
- **MEM (Memory Access):** Handles data load and store operations from/to data memory.
- **WB (Write Back):** Writes computed results back to the register file.

---

## 🚦 Hazard Control Unit
A dedicated hazard control unit is implemented to maintain strict pipeline correctness. 

**Techniques implemented:**
* ⚡ **Data Forwarding (Bypassing):** Actively resolves data hazards by forwarding computed results from later stages directly into the execution path, bypassing the register file write-delay.
* 🛑 **Pipeline Stalling:** Intelligently introduces stalls (bubbles) when forwarding alone cannot resolve structural or memory-read dependencies.
* 🧠 **Control Logic:** Ensures sequential correctness and strict instruction sequencing during hazard events and branch mispredictions.

*This unit significantly improves pipeline efficiency (IPC) while maintaining correct program execution.*

---

## ✨ Key Features
- Complete **32-bit RISC-V** processor design.
- **5-stage pipelined architecture** (IF, ID, EX, MEM, WB).
- Dedicated **hazard detection and forwarding unit**.
- Synchronous **pipeline register implementation**.
- **Synthesizable Verilog RTL** design.
- Functional verification through comprehensive simulation testbenches.

---

## 🛠️ Technologies Used
- **HDL:** Verilog
- **Methodology:** Digital Logic Design, RTL Design Flow
- **Simulation Tools:** ModelSim / Vivado / Icarus Verilog

---

## 💡 Learning Outcomes
This project demonstrates practical competence and implementation of:
- Deep processor pipeline design.
- Hazard detection, visualization, and resolution logic.
- Register Transfer Level (RTL) hardware development.
- Hardware verification strategies through simulation.

---

## 🚀 Future Improvements
- [ ] Integration of a **Dynamic Branch Prediction Unit**.
- [ ] Implementation of an **L1 Cache structure** (Split Instruction & Data caches).
- [ ] Support for **extended RISC-V instruction sets** (e.g., M for Multiplication/Division, F/D for floating-point).
- [ ] Physical **FPGA implementation** and on-board hardware testing.

---
*If you find this project interesting or helpful, feel free to ⭐ star the repository!*
