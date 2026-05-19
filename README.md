# ⚡ FutureOS — Adaptive AI Life Operating System

> *Not a chatbot. An operating system for your life — powered by 6 autonomous AI agents that plan, remember, research, coach, execute, and analyze — all working together in real-time.*

---

## 🧠 What is FutureOS?

FutureOS is a **multi-agent AI life OS** built entirely in [Jac](https://www.jac-lang.org/) — a graph-native language by Jaseci. You tell it your long-term goal (e.g. "Become an AI Engineer in 6 months"), and a team of 6 autonomous agents immediately springs into action:

- 🗺️ **Planner Agent** — breaks your goal into milestones and generates a mission roadmap
- ⚡ **Execution Agent** — tracks every mission you complete, awards XP, updates progress
- 🧠 **Memory Agent** — auto-logs every session, builds your learning history over time
- 📊 **Analytics Agent** — tracks XP, streaks, completion rates, generates performance insights
- 💪 **Coach Agent** — monitors your trajectory, fires motivational signals at key milestones
- 🔍 **Research Agent** — crawls the web (DuckDuckGo) to find real internships, courses, and projects

Every agent action is logged to Jac's built-in graph database and visible in real-time on the Agent Activity page.

---

## 🚀 Inspiration

We were frustrated with productivity tools that are passive — they wait for you to tell them what to do. We wanted something that **acts like a team of advisors** working autonomously in the background. The inspiration came from asking: *"What if your to-do app had a Planner, a Coach, a Researcher, and an Analyst all working for you 24/7?"*

Jac's graph-native architecture and `by llm()` syntax made it uniquely suited to build this — each agent is a `def:priv` endpoint that reads/writes to a per-user graph, and LLM calls are just function signatures with `sem` descriptions. No boilerplate, no prompt engineering files, no separate vector DB.

---

## 🔧 What it does

| Feature | Description |
|---|---|
| **Goal Engine** | Add any long-term goal → agents auto-generate 5-7 missions using Gemini AI or smart keyword templates |
| **Daily Missions** | Checkable mission list with XP rewards, difficulty ratings, and tags |
| **Autonomous Memory** | Every completed mission auto-creates a `MemoryEntry` node — no manual logging |
| **Agent Activity Feed** | Real-time log of every agent action stored in the graph DB |
| **Analytics Dashboard** | Live charts: goal progress, mission completion %, focus scores, XP earned |
| **Opportunity Hub** | Research Agent crawls DuckDuckGo for real internships, courses, and projects |
| **AI Insights** | Coach + Analytics agents generate personalized insights about your progress |
| **Persistent Storage** | All data lives in Jac's graph store — survives restarts, per-user isolated |

---

## 🏗️ How we built it

**Stack:** Jac (Jaseci) — fullstack, backend + frontend in one language.

### Backend (`.jac` service)
- **6 node types** in the graph: `Goal`, `Mission`, `MemoryEntry`, `AgentLog`, `AIInsightEntry`, `AgentLog`
- **`def:priv` endpoints** — each user gets their own isolated `root` node; all data is per-user
- **`by llm()` AI functions** — Planner, Coach, Research, Analytics agents use Gemini 2.5 Flash via byllm
- **Rule-based fallback** — keyword-matched mission templates (AI/ML, engineering, startup, finance) when LLM quota is exceeded
- **Web crawling** — `duckduckgo_search` Python library for real-time opportunity discovery
- **Autonomous logging** — every CRUD action fires `log_agent()` which creates `AgentLog` nodes

### Frontend (`.cl.jac` components)
- **8 pages** wired to real backend data via `sv import`
- **Reactive state** with `has` fields (compiles to React `useState`)
- **Mount effects** with `async can with entry` (compiles to `useEffect`)
- **Tailwind v4** glassmorphism dark theme with electric blue/neon purple palette

### Key Jac patterns used:
```jac
# Graph persistence — no ORM, no SQL
goal = (root ++> Goal(title=title, progress=0))[0];

# Per-user isolation
def:priv get_goals() -> list[Goal] {
    return [root -->][?:Goal];
}

# LLM as a function signature
async def ai_plan_missions(goal_title: str, timeline: str) -> MissionPlan by llm(temperature=0.7);
sem ai_plan_missions = "You are the Planner Agent. Generate actionable missions for the user's goal.";

# Autonomous agent logging
def log_agent(agent_name: str, action: str, detail: str) -> None {
    (root ++> AgentLog(agent_name=agent_name, action=action, detail=detail));
}
```

---

## 🧱 Challenges we ran into

1. **`async def` without `await` can't update `has` state** — Jac compiles `has` fields to React `useState`. We discovered that only truly async functions (with real `await` calls) can trigger state updates. Solved by ensuring every state-updating function awaits at least one server call.

2. **Caller variable names become JSON keys** — Jac's RPC system uses the caller's local variable names as JSON keys. `add_mission(new_title, ...)` sends `{"new_title": ...}` but the server expects `{"title": ...}`. Fixed by aliasing: `title: str = new_title; add_mission(title, ...)`.

3. **`@apply` with custom component classes in Tailwind v4** — Tailwind v4 doesn't allow `@apply badge` inside `@layer components`. Had to expand all custom class references to their utility equivalents.

4. **`report` is a reserved keyword in Jac** — Named a variable `report` and got cryptic parse errors. Renamed to `insight_result`, `strategy_result`, etc.

5. **LLM quota exhaustion** — Free-tier Gemini keys hit daily limits quickly. Built a complete rule-based fallback system so the app works fully without LLM.

6. **`pass` doesn't exist in Jac** — Python habit. Used `err_msg: str = str(e);` as a no-op alternative in except blocks.

---

## 🏆 Accomplishments we're proud of

- **Fully autonomous agent loop** — add a goal, complete a mission, and watch 4 agents fire automatically with zero user input
- **Real web crawling** — Research Agent uses DuckDuckGo to find actual internships and courses, not hardcoded data
- **Zero external database** — everything persists in Jac's graph store; no Supabase, no MongoDB, no Redis
- **LLM-optional architecture** — the entire app works without a valid API key using intelligent fallbacks
- **Per-user data isolation** — `def:priv` gives every user their own graph subgraph automatically
- **Production-quality UI** — dark glassmorphism design with loading/empty/error states on every page

---

## 📚 What we learned

- **Jac's graph-native model is genuinely powerful** — `root ++> Node(...)` and `[root -->][?:Node]` replace entire ORM layers
- **`by llm()` is the cleanest LLM integration we've seen** — no prompt templates, no chain objects, just typed function signatures with `sem` descriptions
- **`def:priv` is a brilliant auth primitive** — per-user data isolation with zero boilerplate
- **Fullstack in one language reduces context switching** — writing backend and frontend in the same `.jac` syntax is surprisingly productive
- **Agent autonomy needs careful state management** — the key insight is that agents should fire on data events (mission completed, goal added), not on timers

---

## 🔮 What's next for FutureOS

- **Real-time agent notifications** — WebSocket push when agents complete tasks
- **Streak tracking** — consecutive day streaks with visual heatmaps
- **Multi-goal orchestration** — agents that coordinate across multiple goals and detect conflicts
- **Voice interface** — speak your goal, agents respond with a plan
- **Social layer** — share goals, compete on leaderboards, get peer accountability
- **Mobile app** — Jac's OSP (Object Spatial Protocol) enables seamless mobile sync
- **Agent memory graph** — long-term memory that connects sessions, identifies patterns, predicts burnout
- **Paid API key management** — settings page to bring your own Gemini/OpenAI key

---

## 🛠️ Setup & Run

```bash
# Clone and install
git clone <repo>
cd futureos

# Add your Gemini API key (optional — app works without it)
echo "GEMINI_API_KEY=AIzaSy..." > .env

# Start the dev server
jac start --dev main.jac
```

Open `http://localhost:8001` → Sign up → Add a goal → Watch the agents work.

---

## 🔑 Environment Variables

```env
GEMINI_API_KEY=AIzaSy...   # Optional — enables AI mission generation and insights
```

---

## 📁 Project Structure

```
futureos/
├── main.jac                    # Entry point + endpoint registry
├── jac.toml                    # Dependencies (npm + python)
├── services/
│   └── appService.jac          # All backend logic: nodes, agents, endpoints
├── pages/
│   ├── LoginPage.cl.jac        # Auth
│   ├── DashboardPage.cl.jac    # Main dashboard
│   ├── GoalWorkspacePage.cl.jac # Goal + mission management
│   ├── AgentActivityPage.cl.jac # Live agent feed
│   ├── AnalyticsPage.cl.jac    # Performance charts
│   ├── MemoryTimelinePage.cl.jac # Session history
│   ├── OpportunityHubPage.cl.jac # Web-crawled opportunities
│   └── SettingsPage.cl.jac     # User settings
├── components/
│   └── Sidebar.cl.jac          # Navigation
└── styles/
    └── global.css              # Tailwind v4 + FutureOS design tokens
```

---

## 🏅 Built for: Best Autonomous Agent — Jac Hackathon

**Why FutureOS wins the autonomous agent category:**

✅ **Planning** — Planner Agent generates structured roadmaps and mission queues from a single goal statement

✅ **Memory** — Memory Agent auto-indexes every session into a persistent graph; agents reference past behavior

✅ **Tool use** — Research Agent uses DuckDuckGo web search as a tool; Execution Agent uses XP calculation as a tool

✅ **Multi-step reasoning** — Adding a goal triggers: Planner → Mission generation → Execution queue → Memory indexing → Analytics update — a 5-step autonomous chain

✅ **Adaptation** — Coach Agent fires different signals at 75% and 100% progress; Analytics Agent adjusts risk assessment based on completion rate

✅ **Persistence** — All agent state lives in Jac's graph DB; agents remember across sessions

---

*Built with ❤️ using [Jac](https://www.jac-lang.org/) — the graph-native AI language by Jaseci*
