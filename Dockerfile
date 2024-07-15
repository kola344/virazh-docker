# Используем базовый образ Python для FastAPI
FROM python:3.9-slim AS fastapi

WORKDIR /app

COPY virazhapi/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY virazhapi .

# Используем базовый образ Node.js для Next.js
FROM node:20.5.0

ENV API_URL="http://127.0.0.1:8000"
ENV NEXTAUTH_SECRET="JwFTCiKtLyRPHVpuYzgcMwOqqbll1JnDTzx7KTTpZ2k"
ENV NEXTAUTH_URL="http://127.0.0.1:3000"

WORKDIR /app

# Копируем package.json и package-lock.json для установки зависимостей
COPY cafevirage/package.json cafevirage/package-lock.json ./
RUN npm install

# Копируем остальные файлы проекта
COPY cafevirage .

# Выполняем сборку приложения
RUN npm run build

# Открываем порт 3000 для приложения
EXPOSE 3000

# Указываем команды запуска для обоих приложений
CMD ["sh", "-c", "uvicorn virazhapi.main:app --host 0.0.0.0 --port 10000 & npm start"]