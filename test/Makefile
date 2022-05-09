MPL=mpl
FLAGS=-default-type int64 -default-type word64

TESTS=stable-merge stable-sort

$(TESTS): phony
	$(MPL) $(FLAGS) -output $@ $@.mlb

.PHONY: clean phony

phony:

clean:
	rm -rf $(TESTS)
