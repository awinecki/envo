test: ## Test with shellspec
	shellspec

# -----------------------------------------------------------
# -----  EVERYTHING BELOW THIS LINE IS NOT IMPORTANT --------
# -----       (Makefile helpers and decoration)      --------
# -----------------------------------------------------------
#
# Decorative Scripts - Do not edit below this line unless you know what it is

.PHONY: help build tag push release deploy-dev
.DEFAULT_GOAL := help

NO_COLOR    = \033[0m
INDENT      = -30s
BIGINDENT   = -50s
GREEN       = \033[36m
BLUE        = \033[34m
DIM         = \033[2m

help:
	@printf '$(DIM)Commands:$(NO_COLOR)\n'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN) % $(BIGINDENT)$(NO_COLOR) - %s\n", $$1, $$2}'
