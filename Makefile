SRC_DIR := observables
BUILD_DIR := build
BENCH_DIR := bench
EXAMPLE_DIR := example
test_binary := $(BUILD_DIR)/test
bench_binary := $(BUILD_DIR)/bench
example_binary := $(BUILD_DIR)/example
SOURCE_FILES := $(shell find $(SRC_DIR) -name \*.pony)
BENCH_SOURCE_FILES := $(shell find $(BENCH_DIR) -name \*.pony)
EXAMPLE_SOURCE_FILES := $(shell find $(EXAMPLE_DIR) -name \*.pony)

all: test example bench

test: $(test_binary)
	./$(test_binary)

$(test_binary): $(SOURCE_FILES)
	ponyc -d -o $(BUILD_DIR) -b test $(SRC_DIR)

bench: $(bench_binary)
	./$(bench_binary)

$(bench_binary): $(BENCH_SOURCE_FILES) $(SOURCE_FILES)
	ponyc -d -o $(BUILD_DIR) -b bench $(BENCH_DIR)

example: $(example_binary)
	./$(example_binary)

$(example_binary): $(SOURCE_FILES) $(EXAMPLE_SOURCE_FILES)
	ponyc -d -o $(BUILD_DIR) -b example $(EXAMPLE_DIR)

clean:
	rm -rf $(BUILD_DIR)
	
.PHONY: test clean bench
