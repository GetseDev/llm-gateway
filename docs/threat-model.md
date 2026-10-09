# Modelo de amenazas

El mayor riesgo real de este proyecto es una llave filtrada que genera una factura.
Por eso costo y secretos encabezan la tabla.

| Amenaza | Qué sale mal | Control que lo mitiga | Etapa |
| --- | --- | --- | --- |
| Llave de AWS filtrada | Alguien despliega recursos en tu cuenta | OIDC en CI (sin llaves estáticas), `gitleaks` en pre-commit y CI, MFA en root | 1 |
| Gasto descontrolado | Bucle o abuso dispara la factura | AWS Budgets con alarma, presupuesto por equipo con corte, adaptador fake en CI | 1 y 3 |
| Rol de CI demasiado amplio | Un PR malicioso escala privilegios | Rol de plan solo lectura, rol de apply solo desde `main`, permissions boundary | 1 |
| Estado de Terraform expuesto | El estado contiene ARNs y a veces secretos | Bucket privado, cifrado, versionado, acceso solo a roles del pipeline | 1 |
| API key robada | Otro equipo gasta a tu nombre | Keys hasheadas, prefijo visible, revocación, límite por key | 2 |
| JWT forjado | `alg: none`, confusión HS256/RS256, `kid` manipulado | Lista fija de algoritmos, JWKS de un emisor fijo, validar iss, aud, exp | 2 |
| Fuerza bruta o DoS | Saturar el gateway o el proveedor | Throttling en API Gateway, límite por equipo, timeouts al proveedor | 2 |
| Prompt injection | El modelo ignora reglas o filtra datos | Guardrails de entrada y salida, sin secretos en prompts, pruebas en CI | 4 |
| Datos sensibles en logs | Prompts con PII quedan en CloudWatch | No loguear contenido por defecto, solo metadatos; retención corta | 2 y 3 |
| Llave del proveedor filtrada | Consumo en tu cuenta del proveedor | Secrets Manager o SSM, nunca en código ni variables en claro | 2 |
| Dependencia vulnerable | Paquete o imagen con CVE | `trivy`, Dependabot, versiones fijadas con lockfile de `uv` | 1+ |
| Mala configuración de infra | Bucket público, rol con `*` | `checkov` y `tflint` en cada PR | 1 |
