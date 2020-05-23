`define assert(signal, value) if (signal != value) $warning("ASSERTION FAILED: signal(%08X) != value(%08X)", signal, value);

`define iverilog_init \
        initial begin \
            $dumpfile("wave.vcd"); \
            $dumpvars; \
        end
