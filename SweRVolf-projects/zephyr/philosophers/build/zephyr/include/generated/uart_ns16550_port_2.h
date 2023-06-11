/*
 * Copyright (c) 2010, 2012-2015 Wind River Systems, Inc.
 * Copyright (c) 2019-2020 Intel Corp.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * This file is a template for cmake and is not meant to be used directly!
 */

#if DT_NODE_HAS_STATUS(DT_DRV_INST(2), okay)

#ifdef CONFIG_UART_INTERRUPT_DRIVEN
static void irq_config_func_2(const struct device *port);
#endif

static const struct uart_ns16550_device_config uart_ns16550_dev_cfg_2 = {
#ifdef UART_NS16550_ACCESS_IOPORT
	.port = DT_INST_REG_ADDR(2),
#elif !DT_INST_PROP(2, pcie)
	DEVICE_MMIO_ROM_INIT(DT_DRV_INST(2)),
#endif
	.sys_clk_freq = DT_INST_PROP(2, clock_frequency),

#ifdef CONFIG_UART_INTERRUPT_DRIVEN
	.irq_config_func = irq_config_func_2,
#endif

#if DT_INST_NODE_HAS_PROP(2, pcp)
	.pcp = DT_INST_PROP(2, pcp),
#endif

#if DT_INST_PROP(2, pcie)
	.pcie = true,
	.pcie_bdf = DT_INST_REG_ADDR(2),
	.pcie_id = DT_INST_REG_SIZE(2),
#endif
};

static struct uart_ns16550_dev_data_t uart_ns16550_dev_data_2 = {
#if DT_INST_NODE_HAS_PROP(2, current_speed)
	.uart_config.baudrate = DT_INST_PROP(2, current_speed),
#endif
	.uart_config.parity = UART_CFG_PARITY_NONE,
	.uart_config.stop_bits = UART_CFG_STOP_BITS_1,
	.uart_config.data_bits = UART_CFG_DATA_BITS_8,
#if DT_INST_PROP(2, hw_flow_control)
	.uart_config.flow_ctrl = UART_CFG_FLOW_CTRL_RTS_CTS,
#else
	.uart_config.flow_ctrl = UART_CFG_FLOW_CTRL_NONE,
#endif
#if DT_INST_NODE_HAS_PROP(2, dlf)
	.dlf = DT_INST_PROP(2, dlf),
#endif
};

DEVICE_AND_API_INIT(uart_ns16550_2, DT_INST_LABEL(2),
		    &uart_ns16550_init,
		    &uart_ns16550_dev_data_2, &uart_ns16550_dev_cfg_2,
		    PRE_KERNEL_1, CONFIG_KERNEL_INIT_PRIORITY_DEVICE,
		    &uart_ns16550_driver_api);

#if DT_INST_IRQ_HAS_CELL(2, sense)
#define INST_2_IRQ_FLAGS  DT_INST_IRQ(2, sense)
#else
#define INST_2_IRQ_FLAGS 0
#endif

#ifdef CONFIG_UART_INTERRUPT_DRIVEN
static void irq_config_func_2(const struct device *dev)
{
	ARG_UNUSED(dev);

#if DT_INST_PROP(2, pcie)
#if DT_INST_IRQN(2) == PCIE_IRQ_DETECT

	/* PCI(e) with auto IRQ detection */

	BUILD_ASSERT(IS_ENABLED(CONFIG_DYNAMIC_INTERRUPTS),
		     "NS16550 PCI auto-IRQ needs CONFIG_DYNAMIC_INTERRUPTS");

	unsigned int irq;

	irq = pcie_wired_irq(DT_INST_REG_ADDR(2));

	if (irq == PCIE_CONF_INTR_IRQ_NONE) {
		return;
	}

	irq_connect_dynamic(irq,
			    DT_INST_IRQ(2, priority),
			    (void (*)(const void *))uart_ns16550_isr,
			    DEVICE_GET(uart_ns16550_2),
			    INST_2_IRQ_FLAGS);

	pcie_irq_enable(DT_INST_REG_ADDR(2), irq);

#else

	/* PCI(e) with fixed or MSI IRQ */

	IRQ_CONNECT(DT_INST_IRQN(2),
		    DT_INST_IRQ(2, priority),
		    uart_ns16550_isr,
		    DEVICE_GET(uart_ns16550_2),
		    INST_2_IRQ_FLAGS);

	pcie_irq_enable(DT_INST_REG_ADDR(2),
			DT_INST_IRQN(2));

#endif
#else

	/* not PCI(e) */

	IRQ_CONNECT(DT_INST_IRQN(2),
		    DT_INST_IRQ(2, priority),
		    uart_ns16550_isr,
		    DEVICE_GET(uart_ns16550_2),
		    INST_2_IRQ_FLAGS);

	irq_enable(DT_INST_IRQN(2));

#endif
}
#endif

#endif
