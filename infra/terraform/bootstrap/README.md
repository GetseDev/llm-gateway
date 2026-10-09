# bootstrap

Se aplica **una sola vez, a mano**, desde tu máquina. Resuelve el huevo y la gallina:
el bucket del estado remoto no puede guardar su propio estado antes de existir.

## Qué crea (usando los módulos de `../modules/`)
- `budget-alarm` — primero que nada
- `state-backend` — bucket S3 del estado
- `github-oidc` — proveedor OIDC de GitHub
- `permissions-boundary`
- `ci-roles` — roles `ci-plan` y `ci-apply`

## Secuencia (escribe tú los comandos en `scripts/bootstrap.sh`)
1. Aplicar con estado local.
2. Agregar el bloque `backend "s3"` apuntando al bucket recién creado.
3. Migrar el estado local al bucket (`terraform init -migrate-state`).
4. Verificar que el `.tfstate` local ya no se necesita y que no está en git.

## Pregunta
¿Con qué credenciales corres esto la primera vez, si el pipeline todavía no existe?
¿Qué harías para no dejar esas credenciales activas después?
