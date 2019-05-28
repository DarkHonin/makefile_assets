include $(LIB_CFG)
ifndef SRC_DIR
SRC_DIR=$(WORKING_DIR)/srcs
endif
OBJ_DIR=$(WORKING_DIR)/objs
INCLUDE_DIR=$(WORKING_DIR)/includes

SRCS=$(foreach src, $(SRC_DIR), $(shell find '$(WORKING_DIR)/$(src)' -type f))

OBJS:=$(foreach obj,$(notdir $(SRCS)),$(addprefix $(OBJ_DIR)/,$(addsuffix .o,$(obj))))

$(NAME): $(LIB_CFG)
	@echo "Current_path: $(realpath .)"
	@echo "Object path: $(OBJ_DIR)"
	@echo "Config path: $(LIB_CFG)"
	@echo "Src dir: $(SRC_DIR)"
	@echo "Sources found: $(words $(SRCS))"
	@for i in $(LIBRAIRIES); do \
		echo "Librairy found: $$i"; \
	done
	@echo "Making $(NAME)"
	@for i in $(SRCS); do \
		echo "Discovered: $$i"; \
	done
	
	$(MAKE) make

$(OBJS): $(OBJ_DIR)
	@echo "Creating: $@"
	@gcc $(shell find $(SRC_DIR) $(OS_D) -name $(notdir $*) -type f ) -o $@ $(INCLUDE) -I $(INCLUDE_DIR) -c $(FLAGS)

$(OBJ_DIR):
	mkdir $(OBJ_DIR)

clean: $(OBJ_DIR)
	rm -r $(OBJ_DIR)

fclean: clean
	rm $(NAME)

re: fclean $(NAME)

info:
	@echo WORKING_DIR $(WORKING_DIR)
	@echo SRC_DIR $(SRC_DIR)