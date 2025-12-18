
# Apigee Proxy CI/CD Automation

## Overview
This repository contains Apigee API proxy bundles, CI/CD pipeline scripts, and integration tests for Google Apigee X. It automates linting, deployment, and testing of proxies using Azure Pipelines and Postman.

## Project Structure

- `mock-v1/`: Apigee proxy bundle (policies, endpoints, resources, configs)
- `test-call/`: Apigee proxy bundle (policies, endpoints, resources, configs)
- `scripts/`: Shell scripts for integration, revision, and undeploy operations
- `tests/integration/`: Postman collections for automated API testing
- `shared-pom.xml`: Maven parent POM for proxy build/deploy
- `apigeelint-pr.yml`: Azure Pipeline for PR linting and reporting
- `azure-pipelines.yml`: Main CI/CD pipeline for build, deploy, and test

## Getting Started

### Prerequisites
- Apigee X or Apigee Edge account
- Azure DevOps project with pipeline permissions
- Maven (for local builds)
- Node.js (for apigeelint and Newman)
- Postman (for collection authoring)

### Installation & Setup
2. Configure variable groups in Azure DevOps for `dev`, `uat`, and `prod` environments ([see Azure DevOps variable groups documentation](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups)).
2. Configure variable groups in Azure DevOps for `dev`, `uat`, and `prod` environments.
3. Set up service account credentials for Apigee deployment by configuring them as pipeline secrets or environment variables in Azure DevOps.

### Build & Deploy

- **Build locally:**  
	```sh
	mvn clean install -f mock-v1/pom.xml -Pdev
	mvn clean install -f test-call/pom.xml -Pdev
	```
- **Deploy via pipeline:**  
	Push or PR triggers Azure Pipelines for lint, build, deploy, and test.

### Linting

- Uses `apigeelint` to validate proxy bundles.
- Lint results are published as pipeline artifacts and posted to PRs.

### Integration Testing

- Postman collections in `tests/integration/` are run via Newman in the pipeline.
- Results are published as JUnit XML for reporting.

## Contributing

- Fork and create feature branches for changes.
- Submit PRs; lint and integration tests must pass.
- See `apigeelint-pr.yml` for PR validation details.

## References

- [Apigee X Documentation](https://cloud.google.com/apigee/docs)
- [apigeelint](https://github.com/apigee/apigeelint)
- [Apigee Deploy Maven Plugin](https://github.com/apigee/apigee-deploy-maven-plugin)
- [Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [Postman](https://www.postman.com/)
- [Newman](https://www.npmjs.com/package/newman)