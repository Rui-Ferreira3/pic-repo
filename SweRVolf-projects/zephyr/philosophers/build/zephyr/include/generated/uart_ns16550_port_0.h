/*
 * Copyright (c) 2010, 2012-2015 Wind River Systems, Inc.
 * Copyright (c) 2019-2020 Intel Corp.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * This file is a template for cmake and is not meant to be used directly!
 */

#if DT_NODE_HAS_STATUS(DT_DRV_INST(0), okay)

#ifdef CONFIG_UART_INTERRUPT_DRIVEN
static void irq_config_func_0(const struct device *port);
#endif

static const struct uart_ns16550_device_config uart_ns16550_dev_cfg_0 = {
#ifdef UART_NS16550_ACCESS_IOPORT
	.port = DT_INST_REG_ADDR(0),
#elif !DT_INST_PROP(0, pcie)
	DEVICE_MMIO_ROM_INIT(DT_DRV_INST(0)),
#endif
	.sys_clk_freq = DT_INST_PROP(0, clock_frequency),

#ifdef CONFIG_UART_INTERRUPT_DRIVEN
	.irq_config_func = irq_config_func_0,
#endif

#if DT_INST_NODE_HAS_PROP(0, pcp)
	.pcp = DT_INST_PROP(0, pcp),
#endif

#if DT_INST_PROP(0, pcie)
	.pcie = true,
	.pcie_bdf = DT_INST_REG_ADDR(0),
	.pcie_id = DT_INST_REG_SIZE(0),
#endif
};

static struct uart_ns16550_dev_data_t uart_ns16550_dev_data_0 = {
#if DT_INST_NODE_HAS_PROP(0, current_speed)
	.uart_config.baudrate = DT_INST_PROP(0, current_speed),
#endif
	.uart_config.parity = UART_CFG_PARITY_NONE,
	.uart_config.stop_bits = UART_CFG_STOP_BITS_1,
	.uart_config.data_bits = UART_CFG_DATA_BITS_8,
#if DT_INST_PROP(0, hw_flow_control)
	.uart_config.flow_ctrl = UART_CFG_FLOW_CTRL_RTS_CTS,
#else
	.uart_config.flow_ctrl = UART_CFG_FLOW_CTRL_NONE,
#endif
#if DT_INST_NODE_HAS_PROP(0, dlf)
	.dlf = DT_INST_PROP(0, dlf),
#endif
};

DEVICE_AND_API_INIT(uart_ns16550_0, DT_INST_LABEL(0),
		    &uart_ns16550_init,
		    &uart_ns16550_dev_data_0, &uart_ns16550_dev_cfg_0,
		    PRE_KERNEL_1, CONFIG_KERNEL_INIT_PRIORITY_DEVICE,
		    &uart_ns16550_driver_api);

#if DT_INST_IRQ_HAS_CELL(0, sense)
#define INST_0_IRQ_FLAGS  DT_INST_IRQ(0, sense)
#else
#define INST_0_IRQ_FLAGS 0
#endif

#ifdef CONFIG_UART_INTERRUPT_DRIVEN
static void irq_config_func_0(const struct device *dev)
{
	ARG_UNUSED(dev);

#if DT_INST_PROP(0, pcie)
#if DT_INST_IRQN(0) == PCIE_IRQ_DETECT

	/* PCI(e) with auto IRQ detection */

	BUILD_ASSERT(IS_ENABLED(CONFIG_DYNAMIC_INTERRUPTS),
		     "NS16550 PCI auto-IRQ needs CONFIG_DYNAMIC_INTERRUPTS");

	unsigned int irq;

	irq = pcie_wired_irq(DT_INST_REG_ADDR(0));

	if (irq == PCIE_CONF_INTR_IRQ_NONE) {
		return;
	}

	irq_connect_dynamic(irq,
			    DT_INST_IRQ(0, priority),
			    (void (*)(const void *))uart_ns16550_isr,
			    DEVICE_GET(uart_ns16550_0),
			    INST_0_IRQ_FLAGS);

	pcie_irq_enable(DT_INST_REG_ADDR(0), irq);

#else

	/* PCI(e) with fixed or MSI IRQ */

	IRQ_CONNECT(DT_INST_IRQN(0),
		    DT_INST_IRQ(0, priority),
		    uart_ns16550_isr,
		    DEVICE_GET(uart_ns16550_0),
		    INST_0_IRQ_FLAGS);

	pcie_irq_enable(DT_INST_REG_ADDR(0),
			DT_INST_IRQN(0));

#endif
#else

	/* not PCI(e) */

	IRQ_CONNECT(DT_INST_IRQN(0),
		    DT_INST_IRQ(0, priority),
		    uart_ns16550_isr,
		    DEVICE_GET(uart_ns16550_0),
		    INST_0_IRQ_FLAGS);

	irq_enable(DT_INST_IRQN(0));

#endif
}
#endif

#endif
