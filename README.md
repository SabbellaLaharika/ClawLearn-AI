# ClawLearn AI: Personalized Telegram Learning Assistant

ClawLearn AI is a personalized, self-hosted AI learning assistant built with the [OpenClaw](https://openclaw.dev/) framework. This Telegram bot acts as your proactive daily study partner. It autonomously onboards new users to learn their technical domains, experience level, and learning goals. Then, every evening, it proactively researches the web to deliver a tailored technical brief containing 5 customized interview questions and 3-5 insightful tech tidbits.

## Features

- **Conversational Onboarding**: Gathers your specific interests, career level, goals, and timezone.
- **Persistent Memory**: Uses OpenClaw's `memory_store` tool to remember your profile across sessions.
- **Autonomous Research**: Employs the `web_search` tool to actively look for fresh, relevant tech news instead of relying solely on static model weights.
- **Automated Daily Delivery**: Uses OpenClaw's Cron engine to autonomously push your daily brief directly to your Telegram app.
- **Privacy-First**: Designed to run entirely on your own hardware using containerization, supporting local models via Ollama.

## Setup Instructions

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) and Docker Compose installed.
- A Telegram Bot Token (obtained from [@BotFather](https://t.me/botfather) on Telegram).
- (Optional but Recommended) A running local instance of [Ollama](https://ollama.ai/) with the `llama3:8b` (or similar) model pulled.

### 1. Configure the Environment
Clone the repository and set up your environment variables.

```bash
git clone https://github.com/your-username/clawlearn-ai.git
cd clawlearn-ai

# Copy the example environment file
cp .env.example .env
```

Open `.env` in your text editor and paste your Telegram Bot Token:
```env
TELEGRAM_BOT_TOKEN=your_actual_token_here
```

### 2. Start the Agent via Docker
Use Docker Compose to build and start the OpenClaw agent container. This will mount a volume for memory persistence so your profile isn't lost when the container restarts.

```bash
docker-compose up -d --build
```

You can view the logs to ensure the gateway connected to Telegram successfully:
```bash
docker-compose logs -f
```

### 3. Initialize the Automation Triggers

To set up the automated behavior, you will need to add a Standing Order (for onboarding) and a Cron Job (for the daily quiz). Open a terminal inside the running container (or run these commands against your local gateway if installed locally):

**Set up the Onboarding Trigger:**
```bash
docker exec -it openclaw-telegram-agent openclaw standing-orders add \
  --name "trigger-user-onboarding" \
  --if "memory.user_profile_{{user.id}} does not exist" \
  --run-skill "user-onboarding"
```

**Set up the Daily Quiz Trigger:**
*Note: Ensure you update the timezone to match the user's actual timezone collected during onboarding.*
```bash
docker exec -it openclaw-telegram-agent openclaw cron add \
  --name "nightly-tech-brief" \
  --cron "0 21 * * *" \
  --tz "America/New_York" \
  --session isolated \
  --message "Run the daily-quiz skill for the primary user. Use their stored preferences to generate and send the daily brief." \
  --announce \
  --channel telegram
```

### 4. Interact with the Bot
Open Telegram, search for your bot, and send it a message like "Hello". Because your profile does not exist in memory yet, the Standing Order will immediately trigger the `user-onboarding` skill.

## Design Decisions

### Onboarding Trigger: Standing Order vs. Webhook
For initiating the onboarding flow with new users, I chose to implement a **Standing Order** rather than relying on an external Webhook. 

**Rationale:**
1. **State-Awareness**: A Standing Order allows the gateway to dynamically evaluate a condition against its own internal persistent memory (`if "memory.user_profile_{{user.id}} does not exist"`). This means the system autonomously decides whether to onboard the user *before* routing the message to the default chat flow.
2. **Reduced Complexity**: Webhooks require exposing an endpoint, managing external routing, and ensuring the external service can communicate back to the OpenClaw gateway. A Standing Order keeps this core logic entirely contained within the OpenClaw agent's rule engine.
3. **Resilience**: Because it evaluates the state locally on every incoming message, it is highly resilient to dropped connections or container restarts, unlike an external webhook listener that might miss an event.

## Project Structure

- `/skills/user-onboarding/SKILL.md`: The conversational logic for collecting user preferences.
- `/skills/daily-quiz/SKILL.md`: The generation workflow for utilizing web search and creating the structured brief.
- `/config/openclaw.json`: The core configuration linking the Telegram plugin and defining the LLM provider.
- `Dockerfile` & `docker-compose.yml`: Infrastructure as code to cleanly isolate and deploy the agent.
