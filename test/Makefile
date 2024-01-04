MPL=mpl
MLTON=mlton -codegen c
FLAGS=-default-type int64 -default-type word64

TESTS=stable-merge stable-sort stable-merge-low-span delayed-seq chunk-treap read-write merge-bench 

MLTON_TESTS := $(addsuffix .mlton,$(TESTS))

all: $(TESTS) $(MLTON_TESTS)

$(MLTON_TESTS): %.mlton: phony
	$(MLTON) $(FLAGS) -mlb-path-var 'COMP mlton' -output $@ $*.mlb

$(TESTS): phony
	$(MPL) $(FLAGS) -mlb-path-var 'COMP mpl' -output $@ $@.mlb

.PHONY: clean phony

phony:

clean:
	rm -rf $(TESTS)
