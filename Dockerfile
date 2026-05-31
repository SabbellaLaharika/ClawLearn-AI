# Use a lightweight Alpine-based Node.js image for optimization
FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Install OpenClaw globally
RUN npm install -g openclaw

# Create required directories for OpenClaw in the home directory
RUN mkdir -p /root/.openclaw/skills/user-onboarding \
             /root/.openclaw/skills/daily-quiz \
             /root/.openclaw/memory

# Copy local skills to the container
COPY skills/user-onboarding/SKILL.md /root/.openclaw/skills/user-onboarding/
COPY skills/daily-quiz/SKILL.md /root/.openclaw/skills/daily-quiz/

# Copy the configuration file
COPY config/openclaw.json /root/.openclaw/

# Start the OpenClaw gateway
CMD ["openclaw", "gateway", "start"]
