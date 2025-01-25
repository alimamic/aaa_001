include version.mk

DOCKER_COMPOSE := docker compose -f ./docker-compose.yml
DOCKER_COMPOSE_BOT_DB := bot-db
DOCKER_COMPOSE_BOT := trade-bot
DOCKER_COMPOSE_KEY_MANAGER := key-manager
DOCKER_COMPOSE_NOTIFY_BOT := notify-bot

RUN_DB := $(DOCKER_COMPOSE) up -d $(DOCKER_COMPOSE_BOT_DB)
STOP_DB := $(DOCKER_COMPOSE) stop $(DOCKER_COMPOSE_BOT_DB) && $(DOCKER_COMPOSE) rm -f $(DOCKER_COMPOSE_BOT_DB)

GO_BASE := $(shell pwd)
GO_BIN := $(GO_BASE)/dist
GO_ENV_VARS := GO_BIN=$(GO_BIN)
GO_BINARY_BOT := bot
GO_BINARY_BOT_TASK := bot-task
GO_CMD_BOT := $(GO_BASE)/cmd/bot
GO_CMD_BOT_TASK := $(GO_BASE)/cmd/bot-task

LDFLAGS += -X 'github.com/meme-bots/trade-bot.Version=$(VERSION)'
LDFLAGS += -X 'github.com/meme-bots/trade-bot.GitRev=$(GITREV)'
LDFLAGS += -X 'github.com/meme-bots/trade-bot.GitBranch=$(GITBRANCH)'
LDFLAGS += -X 'github.com/meme-bots/trade-bot.BuildDate=$(DATE)'

BUILD_BOT := $(GO_ENV_VARS) go build -ldflags "all=$(LDFLAGS)" -o $(GO_BIN)/$(GO_BINARY_BOT) $(GO_CMD_BOT)
BUILD_BOT_TASK := $(GO_ENV_VARS) go build -ldflags "all=$(LDFLAGS)" -o $(GO_BIN)/$(GO_BINARY_BOT_TASK) $(GO_CMD_BOT_TASK)

RUN_BOT := $(DOCKER_COMPOSE) up -d $(DOCKER_COMPOSE_BOT)
STOP_BOT := $(DOCKER_COMPOSE) stop $(DOCKER_COMPOSE_BOT) # && $(DOCKER_COMPOSE) rm -f $(DOCKER_COMPOSE_BOT)

RUN_KM := $(DOCKER_COMPOSE) up -d $(DOCKER_COMPOSE_KEY_MANAGER)
STOP_KM := $(DOCKER_COMPOSE) stop $(DOCKER_COMPOSE_KEY_MANAGER) && $(DOCKER_COMPOSE) rm -f $(DOCKER_COMPOSE_KEY_MANAGER)

RUN_NB := $(DOCKER_COMPOSE) up -d $(DOCKER_COMPOSE_NOTIFY_BOT)
STOP_NB := $(DOCKER_COMPOSE) stop $(DOCKER_COMPOSE_NOTIFY_BOT) && $(DOCKER_COMPOSE) rm -f $(DOCKER_COMPOSE_NOTIFY_BOT)

.PHONY: build
build: ## Build the bot binary locally into ./dist
	$(BUILD_BOT)

.PHONY: run-db
run-db: # Run the bot database
	$(RUN_DB)

.PHONY: stop-db
stop-db: # Stop the bot database
	$(STOP_DB)

.PHONY: run-bot
run-bot: # Run the bot
	$(RUN_BOT)

.PHONY: stop-bot
stop-bot: # Stop the bot
	$(STOP_BOT)

.PHONY: run-km
run-km: # Run the key manager
	$(RUN_KM)

.PHONY: stop-km
stop-km: # Stop the key manager
	$(STOP_KM)

.PHONY: run-nb
run-nb: # Run the notify bot
	$(RUN_NB)

.PHONY: stop-nb
stop-nb: # Stop the notify bot
	$(STOP_NB)

.PHONY: abi
abi: # Build abi
	cd network/evm/erc20 && abigen --abi=erc20.abi --pkg=erc20 --out=erc20.go
	cd network/evm/uniswap && find . -name "*.abi" | xargs -I {} sh -c 'abigen --abi=`basename {}` --pkg=`basename {} .abi` --out=`basename {} .abi`.go'
	cd network/evm/multisend && abigen --abi=multisend.abi --pkg=multisend --out=multisend.go

.DEFAULT_GOAL := help

.PHONY: help
help: ## Prints this help
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
