# LLM Gateway

A single, provider-agnostic entry point to LLMs on AWS, with authentication, per-team budgets,
cost metering and guardrails. Built as a platform-engineering portfolio project by
[Josué Getsemani](https://getsedev.github.io/GetseDev/) (DevOps / Platform Engineer).

> **Status: stage 1 (foundation) done, stage 2 (gateway code) in progress.**
> The infrastructure and CI/CD are in place; the Python gateway (`gateway/src/llm_gateway`) is still scaffolding.
> Design docs are written in Spanish.

## Why it exists

Teams that call LLM providers directly end up with scattered API keys, no cost visibility and no
way to switch provider. This project puts one gateway in front of them: one auth model, one budget
per team, one place to measure tokens, latency and cost, and an adapter layer so changing model
provider does not break clients.

## Architecture

```
Clients → API Gateway → Lambda (Python): auth → per-team limit/budget → guardrails → provider router → metering
                              │                                                  │
                         DynamoDB (keys, budgets, usage)        fake · Ollama (local) · hosted API · Bedrock (optional)
                         Secrets Manager / SSM · CloudWatch · AWS Budgets
```

Full Mermaid diagrams: [`docs/diagrams/architecture.md`](docs/diagrams/architecture.md).
Locally, API Gateway + Lambda are replaced by FastAPI and DynamoDB by SQLite.

## What is already built

- **Terraform modules, each with `terraform test` suites** (mock provider): `budget-alarm`, `ci-roles`, `data-store`, `gateway-api`, `github-oidc`, `observability`, plus a `bootstrap` stack and a `dev` environment.
- **Same infrastructure ported to AWS CDK (TypeScript)** with constructs for the API, data store, secrets, observability, OIDC and a permissions boundary, plus CDK tests. The goal is a reasoned Terraform-vs-CDK comparison ([`docs/comparativa-iac.md`](docs/comparativa-iac.md), being filled in as each stage is ported).
- **CI/CD with GitHub Actions and no static keys (OIDC)**: plan on pull request, apply on `main`, CDK diff/deploy, gateway CI. Least-privilege roles with a permissions boundary.
- **Cost guardrail**: monthly AWS Budgets alarm module, tested.
- **Threat model and ADRs**: [`docs/threat-model.md`](docs/threat-model.md), [`docs/adr/`](docs/adr/).

## Roadmap

| Stage | Scope | Status |
| --- | --- | --- |
| 1 | IaC base (Terraform + CDK), OIDC CI/CD, budget alarm | Done |
| 2 | Gateway: auth, routing, fake + local provider | In progress |
| 3 | Metering: tokens, latency, cost per team | Planned |
| 4 | Quality: evals and guardrails | Planned |
| 5 | Multi-provider and final documentation | Planned |

## Layout

```
infra/terraform/    bootstrap/, modules/, envs/dev/
infra/cdk/          bin/, lib/constructs/, lib/stacks/, test/
gateway/            shared Python code (src/ + tests/)
evals/              test prompts (stage 4)
docs/               ADRs, diagrams, threat model, IaC comparison
.github/workflows/  plan/apply, CDK diff/deploy, gateway CI
```

## Run the Terraform tests

```bash
cd infra/terraform/modules/budget-alarm
terraform init -backend=false
terraform test
```

(Same for the other modules. No AWS credentials needed, tests use a mock provider.)

## Cost

Designed to stay close to zero when idle (API Gateway + Lambda + DynamoDB on-demand) with an AWS Budgets alarm as a safety net.
