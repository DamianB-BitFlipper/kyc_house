.PHONY: all compile clean

PYTHON=python3
GOAL=goal

APP_ID=126 # Be sure to update after every `deploy` call
SMART_CONTRACT=approval_program
CLEAR_PROGRAM=clear_program

CREATOR=LZJPRU7XX4JSSF76YGTYP33VCDKRSW6DFWWFJWJ34Q4YTNY757BHLLOTVQ # alice

all: compile

compile:
	$(PYTHON) ./assets/$(SMART_CONTRACT).py > ./assets/$(SMART_CONTRACT).teal

deploy: compile
	$(GOAL) app create --creator $(CREATOR) --global-byteslices 0 --global-ints 1 --local-byteslices 0 --local-ints 0 --approval-prog ./assets/$(SMART_CONTRACT).teal --clear-prog ./assets/$(CLEAR_PROGRAM).teal

update: compile
	$(GOAL) app update --app-id $(APP_ID) --approval-prog ./assets/$(SMART_CONTRACT).teal --clear-prog ./assets/$(CLEAR_PROGRAM).teal --from $(CREATOR)

call:
	$(GOAL) app call --app-id $(APP_ID) --from $(CREATOR)

read_state:
	$(GOAL) app read --global --app-id $(APP_ID)

clean:
	$(GOAL) app delete --app-id $(APP_ID) --from $(CREATOR)
	rm ./assets/$(SMART_CONTRACT).teal
