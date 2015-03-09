.PHONY: role

name := $(NAME)

role:
	@mkdir -p $(name)/{defaults,files,handlers,meta,tasks,templates,vars}
	@touch $(name)/README.md
	@for i in defaults handlers meta tasks vars ; do echo "---\n# $$i for $(name) role" > $(name)/$$i/main.yml ; done
