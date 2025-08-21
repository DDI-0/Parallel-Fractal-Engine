#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <stdint.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"

#define HW_REGS_BASE (ALT_STM_OFST)
#define HW_REGS_SPAN (0x04000000)
#define HW_REGS_MASK( HW_REGS_SPAN - 1)

// memory mapped register offsets
#define REG_CONTROL_OFST    0x00
#define REG_SEED_REAL_OFST  0x04
#define REG_SEED_IMAG_OFST  0x08
#define REG_STATUS_OFST     0x0C

// control register bitmasks
#define CONTROL_MODE    (1 << 0)
#define CONTROL_START   (1 << 1)
#define CONTROL_ANIMATE (1 << 2)
#define CONTROL_PAUSE   (1 << 3)

// status register bitmasks
#define STATUS_READY    (1 << 0)
#define STATUS_DONE     (1 << 1)

typedef struct {
    float real;
    float imag;
} complex_seed;

int main() {
    void *virtual_base;
    int fd;

    // Pointers to the mm registers
    void *control_reg;
    void *seed_real_reg;
    void *seed_imag_reg;
    void *status_reg;

    if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
        printf("ERROR: could not open");
        return 1;
    }

    virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);

    if (virtual_base == MAP_FAILED) {
        printf("ERROR: mmap failed");
        close(fd);
        return 1;
    }

    control_reg     = virtual_base + REG_CONTROL_OFST;
    seed_real_reg   = virtual_base + REG_SEED_REAL_OFST;
    seed_imag_reg   = virtual_base + REG_SEED_IMAG_OFST;
    status_reg      = virtual_base + REG_STATUS_OFST;

    printf("Starting Mandelbort\n");
    *(uint32_t *)control_reg = CONTROL_START;

    while (!(*(uint32_t *)status_reg & STATUS_DONE));

    printf("Mandelbrot complete\n");

    printf("Starting Julia with seed -0.7 + 0.6i\n");

    *(float *)seed_real_reg = -0.7f;
    *(float *)seed_imag_reg = 0.6f;

    complex_seed animation_seeds[] = {
        {-0.6 , 0.6},
        {-0.5 , 0.6},
        {-0.4 , 0.6},
        {-0.8 , 0.3},
        {-0.8 , 0.2},
        {-0.6 , 0.5},
        {-0.3 , 0.6}
    };

    int num_seeds = sizeof(animation_seeds) / sizeof(complex_seed);

    for (int i = 0; i < num_seeds; i++) {        
        printf("animating frame %d with seed (%.1f, %.1f)", i + 1, animation_seeds[i].real, animation_seeds[i].imag);

        // write the seed for the current frame 
        *(float *)seed_real_reg = animation_seeds[i].real;
        *(float *)seed_imag_reg = animation_seeds[i].imag;

        // start the frame generation
        *(uint32_t *)control_reg = CONTROL_MODE | CONTROL_ANIMATE | CONTROL_START;

        while (!(*(uint32_t *)status_reg & STATUS_DONE));

        usleep(500000);
    }
    
    printf("animation complete");

    // clean up memory map and exit
    if (munmap(virtual_base, HW_REGS_SPAN) != 0) {
        printf("Error: munmap() failed\n");
        close(fd);
        return 1;
    }

    close(fd);
    return 0;

}

    


