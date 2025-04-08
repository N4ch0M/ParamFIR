//! @title Parameterized FIR filter
//! @author J. I. Morales (morales.juan.ignacio@gmail.com)
//! @version 1.2
//! @date 08/04/25
//! @brief Interpolation x2 FIR filter with parameterized number of coefficients

module firx2_param
 #(
    parameter   NBits  = 16,                            //! Number of Bits
    parameter   NCoeff = 81,                            //! Number of Coefficients
    parameter   Coeff_File = "M81_coefficients.dat"     //! Coefficients filename
  ) 
  (
    data_out, 
    data_in,
    rst,      
    clk       
  );

    output  [NBits-1:0]   data_out;         //! Output data (signed)
    input   [NBits-1:0]   data_in;          //! Input data (signed)
    input                     rst;          //! Reset
    input                     clk;          //! Clock


    // --------------------------------------------------------------- //
    //******************** Register Declarations **********************//
    // --------------------------------------------------------------- //
    reg     signed [NBits-1:0]      register [NCoeff-1:0];  //! Matrix for signed Registers
    reg     signed [NBits-1:0]      coeff    [NCoeff-1:0];  //! Matrix for signed Coefficients
    reg     signed [NBits*2-1:0]    prod     [NCoeff-1:0];  //! Partial Products (to handle overflow)
    reg     signed [NBits*2+3:0]    sum;                    //! Accumulated Sum (to handle overflow)

    // --------------------------------------------------------------- //
    integer                         i;                      //! Index for loops  

    // --------------------------------------------------------------- //
    // ********************** Interpolation Variables **************** //
    reg     signed [NBits-1:0]      data_out_int;           //! Interpolated Output
    reg     toggle;                                         //! Toggle between original data and zeros


    // --------------------------------------------------------------- //
    // ************************ Main Code  *************************** //
    // --------------------------------------------------------------- //

    // Coefficients init from file
    initial begin
        $readmemh(Coeff_File,coeff,0,NCoeff-1);  
    end

    //! Interpolation logic (insert zeros between data samples)
    always @(posedge clk) 
        begin: interpolation
        if (rst) 
            begin
            data_out_int <= {NBits{1'b0}};
            toggle       <= 0;
            end  
        else 
            begin
            if (toggle == 0) 
                data_out_int <= data_in;  
            else 
                data_out_int <= {NBits{1'b0}}; 
            
            toggle <= ~toggle;
            end
        end

    //! FIR filter logic (works with the same clock)
    always @(posedge clk) 
        begin: shift_register
        if (rst) 
            begin
            for (i= 0; i < NCoeff; i = i + 1)
                begin
                register[i] <= {NBits{1'b0}};
                end
            sum <= {NBits*2{1'b0}};
            end  
        else 
            begin
            // Shift the input samples in the delay line
            for (i = NCoeff-1; i > 0; i = i - 1) 
                begin
                register[i] <= register[i-1];  
                end
            register[0] <= data_out_int; 

            // Perform the accumulation of products (only for non-zero coefficients)
            sum = {NBits*2+4{1'b0}}; 
            for (i = 0; i < NCoeff; i = i + 1) 
                begin
                if (coeff[i] != 0) 
                    sum = sum + (coeff[i] * register[i]);  
                end
            end
        end

    //! Output Adder Truncation (previous scaling amplitude)
    assign data_out = sum*(2**6) >>> (NBits + 4); 

    endmodule
