PLATFORM_IOS_ID = $(shell xcrun simctl list --json devices available iPhone | jq -r '[.devices | to_entries | sort_by(.key) | reverse | .[].value | select(length > 0) | .[0]][0].udid')
PLATFORM_IOS = iOS Simulator,id=$(PLATFORM_IOS_ID)

default: test

test: package-test example-test

package-test:
	swift test

example-generate:
	cd Examples \
		&& tuist install \
		&& tuist generate --no-open

example-test: example-generate
	cd Examples \
		&& xcodebuild test \
		-workspace MotionManager.xcworkspace \
		-scheme MotionManager \
		-configuration Debug \
		-destination "platform=$(PLATFORM_IOS)" \
		-derivedDataPath DerivedDataTuist \
		CODE_SIGNING_ALLOWED=NO \
		-quiet

format:
	find . \
		-name '*.swift' \
		-not -path '*/.*' \
		-not -path './updated-repos/*' \
		-print0 \
		| xargs -0 xcrun swift-format --ignore-unparsable-files --in-place

.PHONY: example-generate example-test format package-test test
