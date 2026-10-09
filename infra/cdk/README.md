# infra/cdk — versión CDK (TypeScript)

La misma infraestructura que `infra/terraform/`, escrita en CDK para practicar lo que se usa
en el trabajo. CDK sintetiza CloudFormation; el estado lo guarda CloudFormation, no tú.

## Arrancar
`cdk init` exige una carpeta vacía. Haz el init en una carpeta temporal y copia aquí
`package.json`, `tsconfig.json`, `cdk.json` y `jest.config.js`, o mueve antes los placeholders.

```
npx cdk init app --language typescript
```

## Equivalencias con Terraform
| Terraform | CDK |
| --- | --- |
| `modules/` | `lib/constructs/` |
| `envs/dev/` | `lib/stacks/` + `bin/app.ts` |
| `bootstrap/` | `cdk bootstrap` + `CiAccessStack` desplegado una vez a mano |
| `terraform plan` | `cdk diff` |
| `terraform test` | Jest + `Template.fromStack` |
| `checkov` / `tflint` | `cdk-nag` (y `checkov` sobre `cdk.out/`) |

## Stacks
- `CiAccessStack` — OIDC, roles de CI, boundary, alarma de costo (etapa 1)
- `GatewayStack` — API Gateway, Lambda, DynamoDB, secretos (etapas 2 y 3)
- `ObservabilityStack` — logs, alarmas, dashboard (etapas 3 a 5)

## Antes de `cdk bootstrap` — riesgo de seguridad
Por defecto, el rol de ejecución de CloudFormation que crea el bootstrap tiene permisos de
administrador. Revisa en la guía de bootstrapping de tu versión de CDK las opciones
`--cloudformation-execution-policies` y `--custom-permissions-boundary`, y documenta tu elección
en un ADR.

## Pregunta
Si el rol de GitHub solo puede asumir los roles del bootstrap, ¿dónde quedó el poder real
de crear recursos y qué tienes que proteger por eso?

## Regla de costo
No tengas desplegadas la versión Terraform y la CDK a la vez en la misma cuenta,
o usa prefijos distintos (`tf-` / `cdk-`).
