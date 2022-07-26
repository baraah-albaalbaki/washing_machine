# Washing Machine VHDL ModelSim
## Introduction
This project will imitate the behaviour of a washimg machine using modelsim.

## Process
- stand --> fill --> wash --> drain --> fill --> rinse --> drain --> spin --> finish


## FSM
![](images/FSM1.png)

### Sensors
- full (at the top)
- empty (at the bottom)

### Outputs
- Inlet valve
- Outlet valve
- Alarm
- Motor forward
- Motor Reverse
- Lock door

### Timers
- washing
- Rinsing 
- Spinning
- alarm

## Simulation Results
![](images/simulation.png)

## Future Enhancements
- Different washing modes
- Able to adjust washing time and rinsing times
- Fill tub to different levels
- Heating 
- Modify spinning speed

## Author
Baraah
