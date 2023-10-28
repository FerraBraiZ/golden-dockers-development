FROM alpine:latest


RUN apk update && apk add --no-cache dcron

# Create a directory to store cron jobs
RUN mkdir -p /etc/cron.d

COPY crontab /etc/cron.d/crontab

# Give execute permissions to the cron job file
RUN chmod +x /etc/cron.d/crontab

# Start the cron service in the background
CMD ["crond", "-f"]
