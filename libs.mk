WORKING_DIR:=$(realpath .)
FOLDERS=$(shell find '$(LIBDIR)' -name 'ft_lib')
LIBRAIRIES=$(dir $(FOLDERS))
INCLUDE=$(addprefix -I,$(addsuffix includes, $(LIBRAIRIES)))
LIBPATHS=$(addprefix -L,$(LIBRAIRIES))
LINKS=$(foreach file,$(FOLDERS), $(addprefix -l,$(shell cat $(file))))

default: $(NAME)

mod_info:
	@echo "Usage: MODS"
	@echo "---------------------"
	@echo "\tmod_info\t--\tDisplayes this prompt"
	@echo "\tmod_init\t--\tClones all defined submodule"
	@echo "\tmod_remove\t--\tRemoves the cloned repo (MOD)"
	@echo ""
	@echo "Usage: DEPENDENCIES"
	@echo "---------------------"
	@echo "\tdep_build\t--\tBuilds all the dependencies"
	@echo "\tdep_fclean\t--\tCleans all the dependencies"
	@echo "\tdep_re\t\t--\tRebuilds all depenencies unless (LIB) is specified"
	@echo ""
	@echo "Usage: PROJECT"
	@echo "---------------------"
	@echo "\tprj_build\t--\tBuilds the project"
	@echo ""
	@echo Installed modules:
	@for i in $(LIBRAIRIES); do \
		echo '\t'$$i;	\
	done

mod_init:
	@echo "Cloning submodules:"
	@for i in $(shell cat $(WORKING_DIR)/dep/modules); do \
		echo '\t'$$i;	\
		cd $(WORKING_DIR)/dep; \
		git clone $$i -q; \
	done

mod_remove:
	@if [ ! -z "$(MOD)" -a "$(MOD)" != " "  ]; then \
		rm -rf $(WORKING_DIR)/dep/$(MOD); \
	else \
		echo "You need to define a mod: MOD=mod_name"; \
	fi

mod_sync:
	@for i in $(LIBRAIRIES); do \
		cd $$i;	\
		git pull; \
	done

mod_push:
	git add .; \
	git commit -m "$(MSG)"; \
	git push
	@for i in $(LIBRAIRIES); do \
		echo "$$i"; \
		cd $$i;	\
		git add *; \
		git commit -m "$(MSG)"; \
		git push; \
	done

prj_build: $(NAME)

ifdef LIB
TARGS=$(LIBDIR)/$(LIB)
else
TARGS=$(LIBRAIRIES)
endif

dep_build:
	@for i in $(LIBRAIRIES); do \
		echo "Making: $$i"; \
		make -C $$i LIBDIR=$(LIBDIR) -s; \
	done

dep_fclean:
	@echo -n "Cleaning"
	@for i in $(LIBRAIRIES); do \
		make -C $$i fclean -s;\
		echo -n "."; \
	done
	@echo Done

dep_re:
	@echo "Rebuilding..."
	@for i in $(TARGS); do \
		make -C $$i re LIBDIR=$(LIBDIR) -s ;\
	done

dep_pack: dep_fclean
	@echo -n "Packing"
	#@mkdir -f pack
	@e=0; \
	for i in $(LIBRAIRIES); do \
		s=$$(basename $$i); \
		echo $$s; \
		tar -cf pack/dep_$$s.tar dep/$$s; \
		rm -rf $$i; \
		((e++)); \
		echo -n "."; \
	done
	@echo Done

PACKS=$(shell find pack -type f)
dep_unpack:
	@echo "Unacking"
	for i in $(PACKS); do \
		echo $$i; \
		tar -xvf $$i; \
	done
	@echo Done

