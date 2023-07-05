create-%:
	tanzu apps workload create tekton-pipeline-fails-at-$* \
		--git-repo https://github.com/garethjevans/where-for-dinner \
		--git-branch main \
		--sub-path where-for-dinner-availability \
		--build-env BP_JVM_VERSION=17 \
		--param fail-at=$* \
		--label app.kubernetes.io/part-of=tekton-pipeline-fails-at-$* \
		--type tekton \
		--yes

delete-%:
	kubectl delete workload tekton-pipeline-fails-at-$* --ignore-not-found

apply: delete-runnable-task delete-norunnable-task delete-runnable-pipeline delete-norunnable-pipeline delete-nothing create-runnable-task create-norunnable-task create-runnable-pipeline create-norunnable-pipeline create-nothing
	ytt --ignore-unknown-comments --file ./config --data-values-file values.yaml | kubectl apply -f -
	kubectl delete workload tekton-pipeline-test-app-parallel-stages --ignore-not-found

debug-%:
	@echo "Debugging tekton-pipeline-fails-at-$*"
	tanzu apps workload get tekton-pipeline-fails-at-$* | grep " $* "
	@echo ""

debug: debug-runnable-task debug-norunnable-task debug-runnable-pipeline debug-norunnable-pipeline
