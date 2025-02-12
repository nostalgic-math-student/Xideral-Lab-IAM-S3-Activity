# 9. **Reporte final**
##**Ejercicio IAM y S3: Pruebas de validación**
##### Josue Rojas Noble
### **Escenario**
#### **Pruebas de validación**

1. **Usuarios del grupo de lectura** (`usuario1` y `usuario2`):  
   - Con AWS CLI (o la consola web), **listar** el bucket:
   - <img width="299" alt="image" src="https://github.com/user-attachments/assets/da10163c-74d0-41fd-859a-20abef0353ff" />

   - Intentar **descargar** un objeto de la carpeta `/public/`.
   - <img width="614" alt="image" src="https://github.com/user-attachments/assets/9693c0fe-f49b-4f85-bfaf-d85812970c28" />

   - Intentar **leer** un objeto de `/private/`. Debe **fallar** por falta de permisos.
   - <img width="614" alt="image" src="https://github.com/user-attachments/assets/764c3d34-287b-429b-a60c-32b81248587f" />

   - Intentar **subir** y/o **borrar** objetos en `/public/`. Debe fallar.
   - <img width="798" alt="image" src="https://github.com/user-attachments/assets/c2c29627-bb37-4227-8254-93bdd450b57c" />

2. **Usuario administrador** (`admin-s3`):
   - **Listar** y **leer** todos los objetos.
   - <img width="479" alt="image" src="https://github.com/user-attachments/assets/a6591258-6b02-4d2a-8a3c-2ca07f2352dc" />

   - **Subir** un objeto a `/private/`. Debe funcionar.
   - <img width="582" alt="image" src="https://github.com/user-attachments/assets/747f9e1b-5be8-4a4e-b7a6-544f51e2f06a" />

   - **Borrar** un objeto en `/public/`. Debe funcionar.
   - <img width="590" alt="image" src="https://github.com/user-attachments/assets/08a23f55-04af-4b25-b275-0c1a26d97e10" />

3. **Instancia EC2 con rol `EC2S3ReadOnlyRole`**:  
   - Conéctate a la instancia EC2 (SSH o Session Manager).  
   - Ejecuta: 
     ```bash
     aws s3 ls s3://bucket-lab-iam
     aws s3 cp s3://bucket-lab-iam/private/ejemplo.txt .
     aws s3 cp s3://bucket-lab-iam/public/otro-archivo.txt .
     ```
     Resultado:
     <img width="620" alt="image" src="https://github.com/user-attachments/assets/39f6f748-f12a-4e31-b0a2-a0edb75b5de7" />
     
   - Intenta **subir** un archivo (ej. `aws s3 cp localfile.txt s3://bucket-lab-iam/private/`) y confirma que falle debido a permisos insuficientes.
   - <img width="748" alt="image" src="https://github.com/user-attachments/assets/1197a19b-2fc9-4c0f-ae09-a32d7d2fcd63" />


4. (Opcional) **Revisar CloudTrail**:  
   - Confirma que los eventos IAM y S3 estén siendo registrados.
   <img width="572" alt="image" src="https://github.com/user-attachments/assets/9ca2a6b4-e6ea-4b6e-9a1a-a3b12c18bdd5" />



---

## Resultados solicitados:

1. **Capturas de pantalla o logs** de la consola o del AWS CLI demostrando:  
   - Los accesos exitosos/fallidos según cada usuario.  
   - Los accesos exitosos/fallidos desde la instancia EC2 con el rol.  
2. **Políticas en formato JSON**:  
   - `LecturaS3PublicPolicy`.
```json 
   {
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "ListBucket",
			"Effect": "Allow",
			"Action": "s3:ListBucket",
			"Resource": "arn:aws:s3:::bucket-lab-iam-xideral-josue"
		},
		{
			"Sid": "GetPublicObjects",
			"Effect": "Allow",
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::bucket-lab-iam-xideral-josue/public/*"
		}
	]
}
```
   - La política de acceso completo utilizada (ya sea la administrada de AWS o una personalizada).
     Para admin-s3 utilicé *AmazonS3FullAccess*
     <img width="827" alt="image" src="https://github.com/user-attachments/assets/ab61ab97-44b5-410a-ac50-c1113f81230d" />

   - La política asignada al rol `EC2S3ReadOnlyRole` (o, en su defecto, la referencia a la política administrada de AWS si usaste `AmazonS3ReadOnlyAccess`).
```json
     {
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "ReadOnlyPolicy",
			"Effect": "Allow",
			"Action": [
				"s3:GetObject",
				"s3:ListBucket"
			],
			"Resource": [
				"arn:aws:s3:::bucket-lab-iam-xideral-josue/*",
				"arn:aws:s3:::bucket-lab-iam-xideral-josue"
			]
		}
	]
}
```

3. **Configuración del rol** de IAM (`EC2S3ReadOnlyRole`) y evidencia de que se asoció correctamente a la instancia EC2.
<img width="719" alt="image" src="https://github.com/user-attachments/assets/59dfc3ec-a670-446a-8fc7-9676b755283d" />

<img width="704" alt="image" src="https://github.com/user-attachments/assets/cd8be026-bbed-4782-a7a8-c49a6eb900e1" />


4. (Opcional) **Extracto de CloudTrail** donde se reflejen las operaciones realizadas.
   <img width="572" alt="image" src="https://github.com/user-attachments/assets/9ca2a6b4-e6ea-4b6e-9a1a-a3b12c18bdd5" />

---
