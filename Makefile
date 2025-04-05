# ================================
# Define Library Build Location
# ================================
LIBRARY_DIR := ./libs/stm32g071rb

# ================================
# Detect Firmware Directories
# ================================
FIRMWARES := $(notdir $(wildcard firmware/*))

# ================================
# Default Target: Build All
# ================================
all: library $(FIRMWARES)

# ================================
# Build Library
# ================================
library:
	@echo "==== Building the library ===="
	@$(MAKE) --no-print-directory -C $(LIBRARY_DIR) all

# ================================
# Build Each Firmware
# ================================
$(FIRMWARES):
	@echo "==== Building $@ ===="
	@$(MAKE) --no-print-directory -C firmware/$@ all

# ================================
# Clean All Firmware Builds
# ================================
clean:
	@echo "==== Cleaning all firmware and library ===="
	@for fw in $(FIRMWARES); do \
		$(MAKE) --no-print-directory -C firmware/$$fw clean; \
	done
	@$(MAKE) --no-print-directory -C $(LIBRARY_DIR) clean
	@echo "All firmware and library cleaned!"

# ================================
# Size Report for Each Firmware
# ================================
size:
	@for fw in $(FIRMWARES); do \
		$(MAKE) --no-print-directory -C firmware/$$fw size; \
	done

# ================================
# Help Menu
# ================================
help:
	@echo "Available targets:"
	@echo "  make all         - Build all firmware and library"
	@echo "  make <target>    - Build a specific firmware (e.g., make blinky)"
	@echo "  make clean       - Clean all firmware and library builds"
	@echo "  make size        - Show size of all firmware builds"
	@echo "  make flash-<fw>  - Flash a specific firmware (e.g., make flash-blinky)"

.PHONY: all $(FIRMWARES) clean size flash-% help
