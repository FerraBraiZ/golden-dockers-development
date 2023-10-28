FROM mysql:8.0

RUN apt-get update && apt-get install -y netcat-openbsd iputils-ping telnet vim nano net-tools && rm -rf /var/lib/apt/lists/*

EXPOSE 3306

# Set environment variables for MySQL (you can customize these as needed)
ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=mydb
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWORD=mypassword


