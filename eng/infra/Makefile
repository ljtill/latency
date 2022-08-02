deploy:
	@echo "=> Deploying platform..."
	@az deployment sub create --name "Microsoft.Resources" --location "westus2" --template-file "./resources.bicep" --verbose

delete:
	@echo "=> Deleting platform..."
	@az group list --output json | jq -r '.[].name' | xargs -rtL1 az group delete --yes --name