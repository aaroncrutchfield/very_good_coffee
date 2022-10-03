PACKAGES := $(wildcard packages/*)

print:
	for package in $(PACKAGES); do \
		echo $${package} ; \
	done

pods-clean:
	rm -Rf ios/Pods ; \
	rm -Rf ios/.symlinks ; \
	rm -Rf ios/Flutter/Flutter.framework ; \
	rm -Rf ios/Flutter/Flutter.podspec ; \
	rm ios/Podfile ; \
	rm ios/Podfile.lock ; \


get:
	flutter pub get
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Updating dependencies on $${package}" ; \
		flutter pub get ; \
		cd ../../ ; \
	done

upgrade:
	flutter pub upgrade
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Updating dependencies on $${package}" ; \
		flutter pub upgrade ; \
		cd ../../ ; \
	done

lint:
	flutter analyze

format:
	flutter format --set-exit-if-changed .

testing:
	flutter test
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running test on $${package}" ; \
		flutter test ; \
		cd ../../ ; \
	done

test-coverage:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running test on $${package}" ; \
		flutter test --coverage ; \
		genhtml coverage/lcov.info -o coverage/html ; \
		open coverage/html/index.html ; \
		cd ../../ ; \
	done

clean:
	flutter clean
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running clean on $${package}" ; \
		flutter clean ; \
		cd ../../ ; \
	done

build-runner:
	flutter pub run build_runner build --delete-conflicting-outputs
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running build-runner on $${package}" ; \
		flutter pub run build_runner build --delete-conflicting-outputs ; \
		cd ../../ ; \
	done