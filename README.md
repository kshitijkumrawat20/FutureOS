# FutureOS — Your Personal AI Life Operating System

> A persistent multi-agent assistant that turns long-term goals into practical plans, remembers progress, researches opportunities, and adapts its coaching.

**Hackathon track:** Personal AI  
**Hackathon infrastructure:** Nebius Token Factory  
**NVIDIA open model:** NVIDIA Nemotron 3.5 Lightning  
**Application framework:** Jac / byLLM

## What it does

FutureOS coordinates six focused agents around a user's goals:

- **Planner** turns a goal and timeline into structured missions.
- **Execution** tracks completed work and awards XP.
- **Memory** stores goal and session history in Jac's persistent graph.
- **Analytics** summarizes completion and progress.
- **Coach** generates personalized insights and next-step advice.
- **Research** searches for internships, courses, projects, and communities.

The application keeps the existing Jac graph-backed goal, mission, memory, and agent-activity data model. The LLM-backed planning, insights, and strategy functions now use NVIDIA Nemotron served by Nebius Token Factory.

## Nebius + NVIDIA integration

FutureOS uses the OpenAI-compatible Nebius Token Factory chat-completions API through Jac byLLM's documented custom-endpoint HTTP client.

Default model:

`nvidia/Nemotron-3_5-Lightning`

Default endpoint:

`https://api.tokenfactory.nebius.com/v1/chat/completions`

The default is Nemotron 3.5 Lightning, a current-generation NVIDIA model listed by Nebius for agentic reasoning, coding, and tool use. The model ID and endpoint can be overridden with environment variables. The application records a `Nebius Token Factory` agent event after a successful model response. If a model call fails, existing deterministic fallbacks keep the rest of the app usable; those fallback events are explicitly labelled so they are not confused with Nemotron inference.

## Run locally

### Requirements

- A supported Jac installation with the project's dependencies installed.
- Python 3.12 or newer.
- A Nebius Token Factory API key with access to the selected model.

### 1. Clone and install

```bash
git clone https://github.com/kshitijkumrawat20/FutureOS.git
cd FutureOS
jac install
```

### 2. Configure the environment

Copy the example file and provide your own API key. Never commit a real key.

**Windows PowerShell**

```powershell
Copy-Item .env.example .env
$env:NEBIUS_API_KEY = "YOUR_NEBIUS_TOKEN_FACTORY_KEY"
```

**macOS / Linux**

```bash
cp .env.example .env
export NEBIUS_API_KEY="YOUR_NEBIUS_TOKEN_FACTORY_KEY"
```

The application reads these variables:

| Variable | Default | Purpose |
|---|---|---|
| `NEBIUS_API_KEY` | empty | Token Factory API key |
| `NEBIUS_MODEL` | `nvidia/Nemotron-3_5-Lightning` | Token Factory model ID |
| `NEBIUS_TOKEN_FACTORY_CHAT_COMPLETIONS_URL` | `https://api.tokenfactory.nebius.com/v1/chat/completions` | Full chat-completions endpoint |

The endpoint default is the Nebius US Central Token Factory endpoint. Set the environment variable to the endpoint shown in your Nebius console if your account uses a different regional URL.

### 3. Verify real Nemotron inference

Run the standalone smoke test before launching the app:

```bash
python scripts/test_nebius.py
```

The test sends a small prompt to Token Factory and prints the returned model, latency, token usage (when supplied by the API), and response. It does not print or persist your API key.

### 4. Start FutureOS

```bash
jac start --dev main.jac
```

Open the local URL printed by Jac, create a goal, and trigger mission generation, strategy, or insights. In the Agent Activity view, a successful hosted model request is recorded as **Nebius Token Factory — Nemotron inference completed**.

> Important: a working fallback is not proof of hackathon compliance. For the hackathon demo, configure a valid Nebius key, run the smoke test, and show a successful Nemotron-backed workflow.

## Suggested demo flow

1. Create a goal such as **"Become an AI Engineer in 90 days"**.
2. Generate the mission roadmap and show the structured mission list.
3. Open the Agent Activity feed and show the successful Nebius/Nemotron inference event.
4. Complete a mission and show the graph-backed memory entry and progress update.
5. Generate a strategy or coach insight based on the goal.
6. Restart or revisit the app and show that the goal and history remain available.

Keep the public demo video under three minutes. Show the working application and explicitly identify the Nebius Token Factory endpoint and NVIDIA Nemotron model.

## Existing-project update for this hackathon

FutureOS existed before the hackathon submission period. The hackathon-specific update is the migration of the LLM-backed Planner, Coach/Analytics, and Strategy workflows from the earlier provider configuration to NVIDIA Nemotron 3 Super served by Nebius Token Factory. The update also adds environment-based secret handling, a direct inference smoke test, and activity-feed events that distinguish successful hosted inference from local deterministic fallback behavior.

## Security

- Keep `.env` out of Git; it is ignored by the repository.
- Never paste API keys into source code, issues, screenshots, logs, or Devpost.
- Revoke any provider key that was previously committed to Git history and create a fresh key.
- Do not publish private user goal or memory data in demo screenshots or recordings.

## License

MIT. See [LICENSE](./LICENSE).
