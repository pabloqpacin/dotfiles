#!/bin/bash

# @ExplainingComputers: RPi 5 Cooling Benchmarking -- (https://www.youtube.com/watch?v=vYUF1H-_7TQ)

for f in {1..10}; do
    vcgencmd measure_temp
    # Sysbench command to factor prime numbers for 120 seconds, output suppressed
    sysbench cpu --cpu-max-prime=50000 --threads=4 --time=120 run >/dev/null 2>&1
done

    vcgencmd measure_temp

