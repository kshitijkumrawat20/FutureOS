import from byllm.lib { Model }

glob llm: Model = Model(model_name="gemini/gemini-2.0-flash", api_key="AIzaSyBPNYCYAfipbjapX_v90cJbq39KCmfWT_4");

# ==== DATA NODES ====

node Goal {
    has title: str;
    has description: str = "";
    has timeline: str = "3 months";
    has progress: int = 0;
    has status: str = "active";
    has created_at: str = "";
}

node Mission {
    has title: str;
    has difficulty: str = "Medium";
    has xp: int = 100;
    has done: bool = False;
    has tag: str = "General";
    has goal_id: str = "";
}

node MemoryEntry {
    has summary: str;
    has tags: str = "";
    has focus_score: int = 80;
    has duration: str = "1h";
    has created_at: str = "";
}

node AIInsightEntry {
    has text: str;
    has icon: str = "💡";
    has insight_type: str = "info";
    has goal_id: str = "";
}

# ==== AI AGENT OBJECTS ====

obj MissionPlan {
    has missions: list[str];
    has tags: list[str];
    has difficulties: list[str];
    has xp_values: list[int];
}

sem MissionPlan.missions = "List of 5 to 7 specific, actionable daily mission titles for the goal. Each should be a concrete task the user can complete in 1-3 hours.";
sem MissionPlan.tags = "Category tag for each mission matching its index. Use: DSA, ML, Python, Project, Career, Reading, System Design, Math, Research, Practice.";
sem MissionPlan.difficulties = "Difficulty level for each mission matching its index. Use exactly: Easy, Medium, or Hard.";
sem MissionPlan.xp_values = "XP reward for each mission matching its index. Easy=50-80, Medium=100-150, Hard=200-300.";

obj InsightReport {
    has insights: list[str];
    has coach_message: str;
    has predicted_completion: str;
    has risk_level: str;
}

sem InsightReport.insights = "List of 4 specific AI insights about the user's progress. Each insight should be 1 sentence, specific and actionable. Include strengths, weaknesses, patterns, and predictions.";
sem InsightReport.coach_message = "A motivating, personalized coach message in 1-2 sentences based on the user's current progress.";
sem InsightReport.predicted_completion = "Predicted completion date or timeframe based on current progress rate. Be specific.";
sem InsightReport.risk_level = "Risk assessment: Low, Medium, or High based on current trajectory.";

obj StrategyReport {
    has milestones: list[str];
    has weekly_focus: str;
    has key_resources: list[str];
    has agent_insights: list[str];
}

sem StrategyReport.milestones = "List of 4-6 major milestones to achieve the goal in order. Each milestone should be a clear achievement.";
sem StrategyReport.weekly_focus = "What the user should focus on THIS week to make the most progress. 1-2 sentences.";
sem StrategyReport.key_resources = "List of 4-5 specific learning resources, courses, or tools for this goal. Include names and brief descriptions.";
sem StrategyReport.agent_insights = "List of 4 insights from different AI agents (Planner, Research, Coach, Analytics). Each prefixed with agent name.";

obj OpportunityReport {
    has internships: list[str];
    has courses: list[str];
    has projects: list[str];
    has networking: list[str];
}

sem OpportunityReport.internships = "List of 4-5 specific internship or job opportunities relevant to the goal. Include company names and roles.";
sem OpportunityReport.courses = "List of 4-5 specific online courses or certifications. Include platform and course name.";
sem OpportunityReport.projects = "List of 4-5 project ideas that would build skills for this goal. Be specific.";
sem OpportunityReport.networking = "List of 3-4 networking opportunities: communities, events, or people to connect with.";

# ==== AI AGENT FUNCTIONS ====

async def ai_plan_missions(goal_title: str, goal_description: str, timeline: str) -> MissionPlan by llm(temperature=0.7, max_tokens=1200);
sem ai_plan_missions = "You are the Planner Agent in FutureOS. Generate a structured mission plan for a user's long-term goal. Create specific, actionable daily missions that progressively build toward the goal.";
sem ai_plan_missions.goal_title = "The user's long-term goal title";
sem ai_plan_missions.goal_description = "Additional description of the goal and what success looks like";
sem ai_plan_missions.timeline = "The timeline to achieve the goal (e.g. 6 months)";

async def ai_generate_insights(goal_title: str, timeline: str, progress: int, done_missions: int, total_missions: int, days_active: int) -> InsightReport by llm(temperature=0.5, max_tokens=800);
sem ai_generate_insights = "You are the Analytics and Coach Agent in FutureOS. Analyze the user's progress data and generate personalized insights, predictions, and coaching advice.";
sem ai_generate_insights.goal_title = "The user's goal title";
sem ai_generate_insights.timeline = "The target timeline for the goal";
sem ai_generate_insights.progress = "Current progress percentage (0-100)";
sem ai_generate_insights.done_missions = "Number of missions completed";
sem ai_generate_insights.total_missions = "Total number of missions";
sem ai_generate_insights.days_active = "Number of days the user has been working on this goal";

async def ai_build_strategy(goal_title: str, goal_description: str, timeline: str) -> StrategyReport by llm(temperature=0.6, max_tokens=1000);
sem ai_build_strategy = "You are the Planner and Research Agent in FutureOS. Build a comprehensive strategy for achieving the user's goal including milestones, resources, and multi-agent insights.";
sem ai_build_strategy.goal_title = "The user's long-term goal";
sem ai_build_strategy.goal_description = "Description of the goal";
sem ai_build_strategy.timeline = "Target timeline";

async def ai_find_opportunities(goal_title: str, timeline: str) -> OpportunityReport by llm(temperature=0.7, max_tokens=1000);
sem ai_find_opportunities = "You are the Research Agent in FutureOS. Find and curate specific opportunities, resources, and connections relevant to the user's goal.";
sem ai_find_opportunities.goal_title = "The user's goal";
sem ai_find_opportunities.timeline = "Timeline for the goal";

# ==== PRIVATE ENDPOINTS (per-user) ====

# Goals
def:priv get_goals() -> list[Goal] {
    return [root -->][?:Goal];
}

def:priv add_goal(title: str, description: str, timeline: str) -> Goal {
    g = (root ++> Goal(title=title, description=description, timeline=timeline, status="active", progress=0, created_at="now"))[0];
    return g;
}

def:priv update_goal_progress(goal_id: str, progress: int) -> Goal | None {
    for g in [root -->][?:Goal] {
        if jid(g) == goal_id {
            g.progress = progress;
            return g;
        }
    }
    return None;
}

def:priv delete_goal(goal_id: str) -> bool {
    for g in [root -->][?:Goal] {
        if jid(g) == goal_id {
            del g;
            return True;
        }
    }
    return False;
}

# Missions
def:priv get_missions() -> list[Mission] {
    return [root -->][?:Mission];
}

def:priv add_mission(title: str, difficulty: str, xp: int, tag: str, goal_id: str) -> Mission {
    m = (root ++> Mission(title=title, difficulty=difficulty, xp=xp, tag=tag, goal_id=goal_id, done=False))[0];
    return m;
}

def:priv toggle_mission(mission_id: str) -> Mission | None {
    for m in [root -->][?:Mission] {
        if jid(m) == mission_id {
            m.done = not m.done;
            return m;
        }
    }
    return None;
}

def:priv delete_mission(mission_id: str) -> bool {
    for m in [root -->][?:Mission] {
        if jid(m) == mission_id {
            del m;
            return True;
        }
    }
    return False;
}

# Memory
def:priv get_memories() -> list[MemoryEntry] {
    return [root -->][?:MemoryEntry];
}

def:priv add_memory(summary: str, tags: str, focus_score: int, duration: str) -> MemoryEntry {
    e = (root ++> MemoryEntry(summary=summary, tags=tags, focus_score=focus_score, duration=duration, created_at="now"))[0];
    return e;
}

# AI Insights storage
def:priv get_insights() -> list[AIInsightEntry] {
    return [root -->][?:AIInsightEntry];
}

# Stats
def:priv get_stats() -> dict {
    goals = [root -->][?:Goal];
    missions = [root -->][?:Mission];
    done_missions = [root -->][?:Mission][?done == True];
    total_xp = 0;
    for m in done_missions {
        total_xp = total_xp + m.xp;
    }
    avg_progress = 0;
    if len(goals) > 0 {
        total_prog = 0;
        for g in goals {
            total_prog = total_prog + g.progress;
        }
        avg_progress = total_prog // len(goals);
    }
    return {
        "total_goals": len(goals),
        "total_missions": len(missions),
        "done_missions": len(done_missions),
        "total_xp": total_xp,
        "avg_progress": avg_progress
    };
}

# ==== AI AGENT ENDPOINTS ====

async def:priv agent_generate_missions(goal_id: str, goal_title: str, goal_description: str, timeline: str) -> list[Mission] {
    plan = await ai_plan_missions(goal_title, goal_description, timeline);
    created: list[Mission] = [];
    missions_list = plan.missions;
    tags_list = plan.tags;
    diffs_list = plan.difficulties;
    xp_list = plan.xp_values;
    for i in range(len(missions_list)) {
        tag_val: str = "General";
        diff_val: str = "Medium";
        xp_val: int = 100;
        if i < len(tags_list) {
            tag_val = str(tags_list[i]);
        }
        if i < len(diffs_list) {
            diff_val = str(diffs_list[i]);
        }
        if i < len(xp_list) {
            xp_val = int(xp_list[i]);
        }
        m = (root ++> Mission(title=str(missions_list[i]), difficulty=diff_val, xp=xp_val, tag=tag_val, goal_id=goal_id, done=False))[0];
        created = created + [m];
    }
    return created;
}

async def:priv agent_get_insights(goal_id: str) -> InsightReport {
    goals = [root -->][?:Goal];
    missions = [root -->][?:Mission];
    done_missions = [root -->][?:Mission][?done == True];
    goal_title: str = "your goal";
    timeline: str = "3 months";
    progress: int = 0;
    for g in goals {
        if jid(g) == goal_id {
            goal_title = g.title;
            timeline = g.timeline;
            progress = g.progress;
        }
    }
    insight_result: InsightReport = await ai_generate_insights(goal_title, timeline, progress, len(done_missions), len(missions), 7);
    return insight_result;
}

async def:priv agent_get_strategy(goal_id: str) -> StrategyReport {
    goal_title: str = "your goal";
    goal_description: str = "";
    timeline: str = "3 months";
    for g in [root -->][?:Goal] {
        if jid(g) == goal_id {
            goal_title = g.title;
            goal_description = g.description;
            timeline = g.timeline;
        }
    }
    strategy_result: StrategyReport = await ai_build_strategy(goal_title, goal_description, timeline);
    return strategy_result;
}

async def:priv agent_get_opportunities(goal_id: str) -> OpportunityReport {
    goal_title: str = "your goal";
    timeline: str = "3 months";
    for g in [root -->][?:Goal] {
        if jid(g) == goal_id {
            goal_title = g.title;
            timeline = g.timeline;
        }
    }
    opp_result: OpportunityReport = await ai_find_opportunities(goal_title, timeline);
    return opp_result;
}
