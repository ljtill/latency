deploy:
	@echo "=> Deploying platform..."
	@az account set --subscription $(AZURE_SUBSCRIPTION_ID)
	@az deployment sub create --name "Microsoft.Resources" --location "westus2" --template-file "./main.bicep"

delete:
	@echo "=> Deleting platform..."
	@az group list --output json | jq -r '.[].name' | xargs -rtL1 az group delete --yes --no-wait --name