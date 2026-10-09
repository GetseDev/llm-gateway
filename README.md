# LLM Gateway

Una puerta de entrada única a modelos de IA con autenticación, presupuestos por equipo,
medición de costos y guardrails. Independiente del proveedor.

> Estado: etapa 1 (base). Este README es la plantilla del portafolio; cada sección se llena
> cuando la etapa correspondiente esté terminada.

## Por qué existe
<2-3 líneas: el problema de plataforma que resuelve>

## Arquitectura
Ver `docs/diagrams/architecture.md`. Pega aquí el diagrama cuando la etapa 2 esté lista.

## Qué demuestra
- Infraestructura como código en dos herramientas (Terraform y CDK), probada y comparada
- CI/CD sin llaves estáticas (OIDC) y mínimo privilegio con permissions boundary
- Presupuestos y medición de costo por equipo
- Cambio de proveedor de modelo sin romper clientes (patrón de adaptadores)

## Probarlo en 5 minutos (local, costo cero)
<pasos con uv y el adaptador fake — etapa 2>

## Desplegar en AWS
<bootstrap, apply, smoke test, destroy — ver scripts/>

## Seguridad
Resumen y enlace a `docs/threat-model.md`.

## Decisiones
Ver `docs/adr/`.

## Costos
<cuánto cuesta tenerlo encendido y cómo destruirlo con un comando>

## Estructura

La infraestructura existe en dos versiones equivalentes: Terraform y AWS CDK (TypeScript).
El código del gateway es uno solo. La comparación entre ambas está en `docs/comparativa-iac.md`.

```
infra/terraform/    bootstrap/, modules/, envs/dev/
infra/cdk/          bin/, lib/constructs/, lib/stacks/, test/
gateway/            código Python compartido (src/ + tests/)
evals/              prompts de prueba (etapa 4)
scripts/            bootstrap, smoke test, destroy
docs/               ADRs, diagramas, modelo de amenazas, comparativa IaC
```
