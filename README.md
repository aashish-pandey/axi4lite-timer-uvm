# **AXI4-Lite Timer – RTL Design + UVM Verification**

## **Overview**
This project implements a fully synthesizable **AXI4-Lite Timer Peripheral** along with a complete **UVM verification environment**.  
The design includes:

- AXI4-Lite slave interface  
- Register block  
- Timer core  
- Interrupt logic  
- Full UVM verification stack (agent, env, sequences, scoreboard, tests)

This repository demonstrates both **RTL design and verification**, matching real **ASIC development flows** used across the semiconductor industry.


---

## **Project Features**

### 🔧 **RTL Design**
- AXI4-Lite interface  
- Register block  
- Timer core (count, reload, overflow, interrupt generation)  
- Fully synthesizable SystemVerilog RTL  

### 🧪 **UVM Verification Environment**
- AXI4-Lite agent (driver, monitor, sequencer, transaction class)  
- Constrained-random sequences  
- Functional coverage shell  
- Scoreboard shell  
- Tests (basic + random)  
- Testbench top with clock/reset generation  
- Virtual interface configuration using `uvm_config_db`  


---

## **Skills Demonstrated**
- AXI bus-level understanding  
- RTL design proficiency  
- UVM methodology fundamentals  
- Transaction-level modeling  
- Sequencer–Driver–Monitor flow  
- Functional coverage planning  
- Scoreboarding principles  
- Ability to build full **design + verification** environments  
