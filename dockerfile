# Fase 01 - install
FROM python:3.11-slim as builder

WORKDIR /app

RUN pip install --upgrade pip
COPY requirements.txt .

RUN pip install -r requirements.txt

# Fase 02 - builder
FROM python:3.11-slim

WORKDIR /app

# Criar um usuario não-root para segurança
RUN addgroup --system appgroup && adduser --ingroup appgroup appuser

# Copiando a instalação do python
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/uvicorn

# Copiar o APP
COPY app/ ./app/

USER appuser
EXPOSE 8080
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
  


  
