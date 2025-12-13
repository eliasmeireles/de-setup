multapps:
	@echo "🔍 Checking if Multipass is installed..."
	@which multipass > /dev/null 2>&1 || { echo "❌ Multipass is not installed. Please install it first."; exit 1; }

	@echo "🚀 Launching Multipass instance 'dev' with 4 CPUs and 4GB RAM..."
	@if multipass info dev >/dev/null 2>&1; then \
		echo "⚙️  Instance 'dev' already exists. Skipping creation..."; \
	else \
		multipass launch -n dev --cpus 4 --memory 4G --disk 20G --mount $$(pwd):/home/ubuntu/k8s; \
	fi

	@echo "🔗 Connecting to the 'dev' instance..."
	multipass shell dev
