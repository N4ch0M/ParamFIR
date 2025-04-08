
# Entity: firx2_param 
- **File**: firx2_param.v
- **Title:**  Parameterized FIR filter
- **Author:**  J. I. Morales (morales.juan.ignacio@gmail.com)
- **Version:**  1.2
- **Date:**  08/04/25
- **Brief:**  Interpolation x2 FIR filter with parameterized number of coefficients

## Diagram
![Diagram](firx2_param.svg "Diagram")
## Description


## Ports

| Port name | Direction | Type        | Description          |
| --------- | --------- | ----------- | -------------------- |
| data_out  | output    | [NBits-1:0] | Output data (signed) |
| data_in   | input     | [NBits-1:0] | Input data (signed)  |
| rst       | input     |             | Reset                |
| clk       | input     |             | Clock                |

## Signals

| Name                  | Type                         | Description                            |
| --------------------- | ---------------------------- | -------------------------------------- |
| register [NCoeff-1:0] | reg     signed [NBits-1:0]   | Matrix for signed Registers            |
| coeff    [NCoeff-1:0] | reg     signed [NBits-1:0]   | Matrix for signed Coefficients         |
| prod     [NCoeff-1:0] | reg     signed [NBits*2-1:0] | Partial Products (to handle overflow)  |
| sum                   | reg     signed [NBits*2+3:0] | Accumulated Sum (to handle overflow)   |
| i                     | integer                      | Index for loops                        |
| data_out_int          | reg     signed [NBits-1:0]   | Interpolated Output                    |
| toggle                | reg                          | Toggle between original data and zeros |

## Processes
- interpolation: ( @(posedge clk) )
  - **Type:** always
  - **Description**
  Interpolation logic (insert zeros between data samples) 
- shift_register: ( @(posedge clk) )
  - **Type:** always
  - **Description**
  FIR filter logic (works with the same clock) 
