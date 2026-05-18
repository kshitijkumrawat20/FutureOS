import from "@jac/runtime" { useNavigate, jacIsLoggedIn, Navigate }
import from ..components.Sidebar { Sidebar }

def:pub page() -> JsxElement {
    has active_tab: str = "overview";

    navigate = useNavigate();

    if not jacIsLoggedIn() {
        return <Navigate to="/login" replace={True} />;
    }

    def go_goals(e: MouseEvent) -> None {
        navigate("/goals");
    }

    def go_agents(e: MouseEvent) -> None {
        navigate("/agents");
    }

    missions = [
        {"title": "Complete 2 LeetCode medium problems", "difficulty": "Medium", "xp": 150, "done": False, "tag": "DSA"},
        {"title": "Read 30 min: System Design Primer", "difficulty": "Easy", "xp": 80, "done": True, "tag": "Learning"},
        {"title": "Build REST API with FastAPI", "difficulty": "Hard", "xp": 250, "done": False, "tag": "Project"},
        {"title": "Review ML fundamentals notes", "difficulty": "Easy", "xp": 60, "done": False, "tag": "ML"},
        {"title": "Apply to 3 internship positions", "difficulty": "Medium", "xp": 120, "done": False, "tag": "Career"}
    ];

    insights = [
        {"icon": "💪", "text": "You are strongest in backend engineering.", "type": "positive"},
        {"icon": "⚠️", "text": "Your DSA consistency dropped 32% this week.", "type": "warning"},
        {"icon": "🌙", "text": "You learn 40% faster during night sessions.", "type": "info"},
        {"icon": "🎯", "text": "On track to reach milestone 2 by Dec 15.", "type": "positive"}
    ];

    agents = [
        {"name": "Planner", "status": "active", "task": "Updating Q4 roadmap", "color": "#3b82f6"},
        {"name": "Research", "status": "active", "task": "Scanning 47 opportunities", "color": "#8b5cf6"},
        {"name": "Memory", "status": "idle", "task": "Indexed 3 new sessions", "color": "#06b6d4"},
        {"name": "Coach", "status": "active", "task": "Analyzing burnout signals", "color": "#10b981"},
        {"name": "Execution", "status": "active", "task": "Generating tomorrow's missions", "color": "#f59e0b"},
        {"name": "Analytics", "status": "idle", "task": "Computed weekly report", "color": "#ec4899"}
    ];

    return (
        <div className="page">
            <Sidebar />
            <div className="page-content">
                <div className="page-header">
                    <div>
                        <h1 className="text-2xl font-bold text-foreground">Good evening, User 👋</h1>
                        <p className="text-muted-foreground text-sm mt-1">Your AI agents are working. 3 missions pending today.</p>
                    </div>
                    <div className="flex items-center gap-3">
                        <div className="badge-green">
                            <span className="w-1.5 h-1.5 rounded-full bg-green-400 animate-pulse inline-block"></span>
                            <span>4 Agents Active</span>
                        </div>
                        <button className="btn btn-primary" onClick={go_goals}>
                            + New Goal
                        </button>
                    </div>
                </div>

                <div className="grid grid-cols-4 gap-4 mb-8">
                    <div className="stat-card">
                        <div className="text-xs text-muted-foreground uppercase tracking-wider mb-2">Active Goals</div>
                        <div className="text-3xl font-bold text-gradient-blue">3</div>
                        <div className="text-xs text-green-400 mt-1">↑ 1 this month</div>
                    </div>
                    <div className="stat-card">
                        <div className="text-xs text-muted-foreground uppercase tracking-wider mb-2">Day Streak</div>
                        <div className="text-3xl font-bold" style={{"color": "#f59e0b"}}>14 🔥</div>
                        <div className="text-xs text-muted-foreground mt-1">Personal best: 21</div>
                    </div>
                    <div className="stat-card">
                        <div className="text-xs text-muted-foreground uppercase tracking-wider mb-2">Missions Done</div>
                        <div className="text-3xl font-bold text-gradient-blue">127</div>
                        <div className="text-xs text-green-400 mt-1">↑ 12% vs last week</div>
                    </div>
                    <div className="stat-card">
                        <div className="text-xs text-muted-foreground uppercase tracking-wider mb-2">Goal Progress</div>
                        <div className="text-3xl font-bold" style={{"color": "#8b5cf6"}}>68%</div>
                        <div className="progress-bar mt-2">
                            <div className="progress-fill" style={{"width": "68%"}}></div>
                        </div>
                    </div>
                </div>

                <div className="grid grid-cols-3 gap-6">
                    <div className="col-span-2">
                        <div className="card p-5 mb-6">
                            <div className="flex items-center justify-between mb-4">
                                <h2 className="text-base font-semibold text-foreground">Today's Missions</h2>
                                <span className="badge-blue">5 tasks</span>
                            </div>
                            <div className="flex flex-col gap-2">
                                {[
                                    <div key={str(i)} className="mission-card">
                                        <div className={"w-5 h-5 rounded-full border-2 flex-shrink-0 mt-0.5 flex items-center justify-center " + ("border-green-400 bg-green-400" if missions[i]["done"] else "border-border")}>
                                            {missions[i]["done"] and <span style={{"fontSize": "10px", "color": "white"}}>✓</span>}
                                        </div>
                                        <div className="flex-1 min-w-0">
                                            <div className={"text-sm font-medium " + ("line-through text-muted-foreground" if missions[i]["done"] else "text-foreground")}>{missions[i]["title"]}</div>
                                            <div className="flex items-center gap-2 mt-1">
                                                <span className="badge-blue text-xs">{missions[i]["tag"]}</span>
                                                <span className="text-xs text-muted-foreground">{missions[i]["difficulty"]}</span>
                                            </div>
                                        </div>
                                        <div className="text-xs font-medium" style={{"color": "#f59e0b"}}>+{str(missions[i]["xp"])} XP</div>
                                    </div>
                                    for i in range(len(missions))
                                ]}
                            </div>
                        </div>

                        <div className="card p-5">
                            <div className="flex items-center justify-between mb-4">
                                <h2 className="text-base font-semibold text-foreground">AI Insights</h2>
                                <span className="badge-purple">Live</span>
                            </div>
                            <div className="flex flex-col gap-3">
                                {[
                                    <div key={str(i)} className="flex items-start gap-3 p-3 rounded-xl" style={{"background": "rgba(59,130,246,0.04)", "border": "1px solid rgba(59,130,246,0.08)"}}>
                                        <span style={{"fontSize": "18px"}}>{insights[i]["icon"]}</span>
                                        <p className="text-sm text-foreground">{insights[i]["text"]}</p>
                                    </div>
                                    for i in range(len(insights))
                                ]}
                            </div>
                        </div>
                    </div>

                    <div>
                        <div className="card p-5">
                            <div className="flex items-center justify-between mb-4">
                                <h2 className="text-base font-semibold text-foreground">Agent Activity</h2>
                                <div className="flex gap-1">
                                    <span className="typing-dot"></span>
                                    <span className="typing-dot"></span>
                                    <span className="typing-dot"></span>
                                </div>
                            </div>
                            <div className="flex flex-col gap-3">
                                {[
                                    <div key={str(i)} className="flex items-start gap-3">
                                        <div className="w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0 text-xs font-bold" style={{"background": agents[i]["color"] + "22", "border": "1px solid " + agents[i]["color"] + "44", "color": agents[i]["color"]}}>
                                            {agents[i]["name"][:2]}
                                        </div>
                                        <div className="flex-1 min-w-0">
                                            <div className="flex items-center gap-2">
                                                <span className="text-xs font-medium text-foreground">{agents[i]["name"]}</span>
                                                <span className={"text-xs " + ("text-green-400" if agents[i]["status"] == "active" else "text-muted-foreground")}>{agents[i]["status"]}</span>
                                            </div>
                                            <div className="text-xs text-muted-foreground truncate">{agents[i]["task"]}</div>
                                        </div>
                                    </div>
                                    for i in range(len(agents))
                                ]}
                            </div>
                            <button className="btn btn-ghost w-full mt-4 text-xs" onClick={go_agents}>
                                View full orchestration →
                            </button>
                        </div>

                        <div className="card p-5 mt-4">
                            <h2 className="text-base font-semibold text-foreground mb-3">Weekly Progress</h2>
                            <div className="flex items-end gap-1.5 h-20">
                                {[
                                    <div key={str(i)} className="flex-1 rounded-t" style={{"height": str([60, 80, 45, 90, 70, 85, 55][i]) + "%", "background": "linear-gradient(to top, #3b82f6, #8b5cf6)", "opacity": "0.8" if i < 6 else "1"}}>
                                    </div>
                                    for i in range(7)
                                ]}
                            </div>
                            <div className="flex justify-between mt-2">
                                {[
                                    <span key={str(i)} className="text-xs text-muted-foreground">{["M","T","W","T","F","S","S"][i]}</span>
                                    for i in range(7)
                                ]}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
