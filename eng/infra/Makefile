
DATA := $(shell cat ../config/data.json)
GROUP = "Latency"

set:
	@az account set -s ''

deploy:
	@echo "=> Deploying platform..."
	@for row in $(shell echo '${DATA}' | jq -r '.regions[] | select(.enabled | tostring | contains("true")) | @base64'); do \
		echo "==> Constructing region `echo $$row | base64 --decode | jq -r '.location'`..."; \
		az deployment group create \
			--name "Microsoft.Region.`echo $$row | base64 --decode | jq -r '.country'`" \
			--resource-group $(GROUP) \
			--template-file ./main.bicep \
			--parameters name=`echo $$row | base64 --decode | jq -r '.name'` location=`echo $$row | base64 --decode | jq -r '.location'` \
			--verbose; \
	done

delete:
	@echo "=> Deleting platform..."
	@az group delete --name $(GROUP) --yes --verbose

purge:
	@echo "=> Purging resources..."
	@az keyvault list-deleted --query '[].name' -o tsv | xargs -rtL1 az keyvault purge --name
