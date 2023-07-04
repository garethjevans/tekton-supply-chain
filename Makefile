apply:
	ytt --ignore-unknown-comments --file ./config --data-values-file values.yaml | kubectl apply -f -
	kubectl delete workload tekton-pipeline-test-app --ignore-not-found
	kubectl delete workload tekton-pipeline-test-app-parallel-stages --ignore-not-found
	kubectl delete workload tekton-pipeline-fails-at-runnable-task --ignore-not-found
	tanzu apps workload create tekton-pipeline-fails-at-runnable-task \
		--git-repo https://github.com/garethjevans/where-for-dinner \
		--git-branch main \
		--sub-path where-for-dinner-availability \
		--build-env BP_JVM_VERSION=17 \
		--param fail-at=runnable-task \
		--label app.kubernetes.io/part-of=tekton-pipeline-fails-at-runnable-task \
		--type tekton \
		--yes
	tanzu apps workload create tekton-pipeline-fails-at-runnable-pipeline \
		--git-repo https://github.com/garethjevans/where-for-dinner \
		--git-branch main \
		--sub-path where-for-dinner-availability \
		--build-env BP_JVM_VERSION=17 \
		--param fail-at=runnable-pipeline \
		--label app.kubernetes.io/part-of=tekton-pipeline-fails-at-runnable-pipeline \
		--type tekton \
		--yes
