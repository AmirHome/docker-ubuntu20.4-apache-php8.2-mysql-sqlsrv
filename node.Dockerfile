FROM node:18.15.0

# Set working directory
WORKDIR /var/www/html/client

# Install dependencies
# COPY package.json .
# COPY yarn.lock .
RUN yarn install

# Copy source code
COPY . .

# Set environment variables
ENV NODE_ENV=development
ENV PORT=3000

# Expose the port
EXPOSE 3000

# Start the Next.js development server
CMD ["yarn", "dev", "-p", "3000"]
