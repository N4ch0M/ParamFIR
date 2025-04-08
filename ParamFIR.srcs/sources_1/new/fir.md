
# Entity: fir 
- **File**: fir.v
- **Title:**  FIR filter
- **Author:**  J. I. Morales (morales.juan.ignacio@gmail.com)
- **Version:**  1.0
- **Date:**  08/04/25
- **Brief:**  Simple FIR filter with preloaded coefficients (unsigned data)

## Diagram
![Diagram](fir.svg "Diagram")
## Description


## Ports

| Port name | Direction | Type        | Description |
| --------- | --------- | ----------- | ----------- |
| data_out  | output    | [NBits-1:0] | Output data |
| data_in   | input     | [NBits-1:0] | Input data  |
| rst       | input     |             | Reset       |
| clk       | input     |             | Clock       |

## Signals

| Name           | Type                | Description             |
| -------------- | ------------------- | ----------------------- |
| register [3:0] | reg     [NBits-1:0] | Matrix for Registers    |
| coeff  [3:0]   | reg     [NBits-1:0] | Matrix for Coefficients |
| sum            | reg     [NBits-1:0] | Matrix for Registers    |
| prod   [3:0]   | wire [NBits*2-1:0]  | Partial Products        |

## Processes
- shift_register_accumulation: ( @(posedge clk) )
  - **Type:** always
  - **Description**
  Pre-loaded Coefficients   Shift Register model 
