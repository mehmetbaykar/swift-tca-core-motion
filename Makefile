EXAMPLES_WORKSPACE = Examples/MotionManager.xcworkspace
XCODEBUILD_FLAGS = -configuration Debug -derivedDataPath Examples/DerivedDataTuist CODE_SIGNING_ALLOWED=NO -quiet
IOS_SIMULATOR_ID = $(shell xcrun simctl list --json devices available iPhone | jq -r '[.devices | to_entries | sort_by(.key) | reverse | .[].value | select(length > 0) | .[0]][0].udid')
IOS_SIMULATOR_DESTINATION = platform=iOS Simulator,id=$(IOS_SIMULATOR_ID)

default: test

test: test-package test-examples

test-package:
	swift test

generate-examples:
	cd Examples && tuist install
	cd Examples && tuist generate --no-open

test-examples: generate-examples
	test -n "$(IOS_SIMULATOR_ID)"
	test "$(IOS_SIMULATOR_ID)" != "null"
	xcodebuild test \
		-workspace "$(EXAMPLES_WORKSPACE)" \
		-scheme MotionManager \
		$(XCODEBUILD_FLAGS) \
		-destination '$(IOS_SIMULATOR_DESTINATION)'

format:
	swift format --in-place --recursive \
		./Examples ./Package.swift ./Sources ./Tests

.PHONY: \
	default \
	format \
	generate-examples \
	test \
	test-examples \
	test-package
