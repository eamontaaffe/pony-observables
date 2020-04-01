SRC_DIR := observables
BUILD_DIR := build
BENCH_DIR := bench
test_binary := $(BUILD_DIR)/test
bench_binary := $(BUILD_DIR)/bench
SOURCE_FILES := $(shell find $(SRC_DIR) -name \*.pony)
BENCH_SOURCE_FILES := $(shell find $(BENCH_DIR) -name \*.pony)

all: test bench

test: $(test_binary)
	./$(test_binary)

$(test_binary): $(SOURCE_FILES)
	ponyc -o $(BUILD_DIR) -b test $(SRC_DIR)

bench: $(bench_binary)
	./$(bench_binary)

$(bench_binary): $(BENCH_FILES) $(SOURCE_FILES)
	ponyc -o $(BUILD_DIR) -b bench $(BENCH_DIR)

clean:
	rm -rf $(BUILD_DIR)
	
.PHONY: test clean bench
