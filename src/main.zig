const std = @import("std");
const microzig = @import("microzig");
const chip = microzig.chip;
const RCC = chip.peripherals.RCC;
const GPIOA = chip.peripherals.GPIOA;
const GPIO_TYPE = chip.types.peripherals.gpio_v2;

pub fn main() !void {
    setup_gpio();

    GPIOA.ODR.modify(.{
        .@"ODR[9]" = GPIO_TYPE.ODR.High,
        .@"ODR[10]" = GPIO_TYPE.ODR.Low,
    });

    while (true) {
        var i: u32 = 0;
        while (i < 100_000) {
            asm volatile ("nop");
            i += 1;
        }
        GPIOA.ODR.toggle(.{
            .@"ODR[9]" = GPIO_TYPE.ODR.High,
            .@"ODR[10]" = GPIO_TYPE.ODR.High,
        });
    }
}

fn setup_gpio() void {
    RCC.AHB2ENR.modify(.{
        .GPIOAEN = 1,
    });

    GPIOA.MODER.modify(.{
        .@"MODER[9]" = GPIO_TYPE.MODER.Output,
        .@"MODER[10]" = GPIO_TYPE.MODER.Output,
    });

    GPIOA.PUPDR.modify(.{
        .@"PUPDR[9]" = GPIO_TYPE.PUPDR.Floating,
        .@"PUPDR[10]" = GPIO_TYPE.PUPDR.Floating,
    });

    GPIOA.OTYPER.modify(.{
        .@"OT[9]" = GPIO_TYPE.OT.PushPull,
        .@"OT[10]" = GPIO_TYPE.OT.PushPull,
    });

    GPIOA.OSPEEDR.modify(.{
        .@"OSPEEDR[9]" = GPIO_TYPE.OSPEEDR.LowSpeed,
        .@"OSPEEDR[10]" = GPIO_TYPE.OSPEEDR.LowSpeed,
    });
}
