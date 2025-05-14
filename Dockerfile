# Використовуємо офіційний образ Nginx
FROM nginx:alpine

# Копіюємо файли нашого застосунку в директорію nginx
COPY index.html /usr/share/nginx/html/index.html

# Відкриваємо порт 80
EXPOSE 80

# Запускаємо nginx
CMD ["nginx", "-g", "daemon off;"]
