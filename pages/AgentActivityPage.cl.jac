import from "@jac/runtime" { useNavigate, jacIsLoggedIn, Navigate }
import from ..components.Sidebar { Sidebar }

def:pub page() -> JsxElement {
    has selected_agent: int = 0;

    navigate = useNavigate();

    if not jacIsLoggedIn() {
        return <Navigate to="/login" replace={True} />;
    }

    agents = [
        {"name": "Planner Agent", "short": "PL", "status": "active", "color": "#3b82f6", "tasks_done": 47, "uptime": "99.2%", "desc": "Breaks goals into milestones, creates execution roadmaps, adjusts timelines dynamically based on user performance."},
        {"name": "Research Agent", "short": "RE", "status": "active", "color": "#8b5cf6", "tasks_done": 134, "uptime": "97.8%", "desc": "Scans the web for internships, courses, articles, and opportunities. Curates personalized recommendations."},
        {"name": "Memory Agent", "short": "ME", "status": "idle", "color": "#06b6d4", "tasks_done": 89, "uptime": "100%", "desc": "Stores user behavior, remembers weak areas, tracks habits and consistency across all sessions."},
        {"name": "Coach Agent", "short": "CO", "status": "active", "color": "#10b981", "tasks_done": 62, "uptime": "98.5%", "desc": "Motivates users, gives productivity advice, detects burnout signals, adapts workload intelligently."},
        {"name": "Execution Agent", "short": "EX", "status": "active", "color": "#f59e0b", "tasks_done": 203, "uptime": "99.9%", "desc": "Generates daily missions, creates action plans, prioritizes tasks based on goal urgency and user energy."},
        {"name": "Analytics Agent", "short": "AN", "status": "idle", "color": "#ec4899", "tasks_done": 78, "uptime": "96.4%", "desc": "Tracks progress, predicts goal completion, generates insights, visualizes performance trends."}
    ];

    activity_log = [
        {"agent": "Planner", "color": "#3b82f6", "action": "Updated Q4 roadmap — added 3 new milestones", "time": "2m ago"},
        {"agent": "Research", "color": "#8b5cf6", "action": "Found 12 new ML internship opportunities", "time": "5m ago"},
        {"agent": "Execution", "color": "#f59e0b", "action": "Generated tomorrow's 5 daily missions", "time": "8m ago"},
        {"agent": "Coach", "color": "#10b981", "action": "Detected reduced focus — recommending break", "time": "12m ago"},
        {"agent": "Memory", "color": "#06b6d4", "action": "Indexed today's session — 3 new patterns found", "time": "18m ago"},
        {"agent": "Analytics", "color": "#ec4899", "action": "Weekly report generated — 76% consistency", "time": "1h ago"},
        {"agent": "Planner", "color": "#3b82f6", "action": "Timeline adjusted — 2 days ahead of schedule", "time": "2h ago"},
        {"agent": "Research", "color": "#8b5cf6", "action": "Curated 5 learning resources for Deep Learning", "time": "3h ago"}
    ];

    return (
        <div className="page">
            <Sidebar />
            <div className="page-content">
                <div className="page-header">
                    <div>
                        <h1 className="text-2xl font-bold text-foreground">Agent Orchestration</h1>
                        <p className="text-muted-foreground text-sm mt-1">Live multi-agent AI collaboration and reasoning</p>
                    </div>
                    <div className="badge-green">
                        <span className="w-1.5 h-1.5 rounded-full bg-green-400 animate-pulse inline-block"></span>
                        <span>System Online</span>
                    </div>
                </div>

                <div className="grid grid-cols-3 gap-6 mb-6">
                    {[
                        <div
                            key={str(i)}
                            className="card p-5 cursor-pointer"
                            style={{"borderColor": (agents[i]["color"] + "44") if selected_agent == i else ""}}
                        >
                            <div className="flex items-start justify-between mb-3">
                                <div className="w-10 h-10 rounded-xl flex items-center justify-center text-sm font-bold" style={{"background": str(agents[i]["color"]) + "22", "border": "1px solid " + str(agents[i]["color"]) + "44", "color": agents[i]["color"]}}>
                                    {agents[i]["short"]}
                                </div>
                                <span className={"text-xs px-2 py-0.5 rounded-full " + ("text-green-400" if agents[i]["status"] == "active" else "text-muted-foreground")} style={{"background": "rgba(16,185,129,0.1)" if agents[i]["status"] == "active" else "rgba(107,114,128,0.1)"}}>
                                    {agents[i]["status"]}
                                </span>
                            </div>
                            <div className="text-sm font-semibold text-foreground mb-1">{agents[i]["name"]}</div>
                            <div className="text-xs text-muted-foreground mb-3 leading-relaxed">{agents[i]["desc"][:80] + "..."}</div>
                            <div className="flex justify-between text-xs">
                                <span className="text-muted-foreground">Tasks: <span className="text-foreground font-medium">{str(agents[i]["tasks_done"])}</span></span>
                                <span className="text-muted-foreground">Uptime: <span className="text-green-400 font-medium">{agents[i]["uptime"]}</span></span>
                            </div>
                        </div>
                        for i in range(len(agents))
                    ]}
                </div>

                <div className="grid grid-cols-2 gap-6">
                    <div className="card p-5">
                        <h2 className="text-base font-semibold text-foreground mb-4">Live Activity Feed</h2>
                        <div className="flex flex-col gap-3">
                            {[
                                <div key={str(i)} className="flex items-start gap-3">
                                    <div className="w-6 h-6 rounded-md flex items-center justify-center text-xs font-bold flex-shrink-0" style={{"background": activity_log[i]["color"] + "22", "color": activity_log[i]["color"]}}>
                                        {activity_log[i]["agent"][:2]}
                                    </div>
                                    <div className="flex-1 min-w-0">
                                        <p className="text-xs text-foreground">{activity_log[i]["action"]}</p>
                                        <span className="text-xs text-muted-foreground">{activity_log[i]["time"]}</span>
                                    </div>
                                </div>
                                for i in range(len(activity_log))
                            ]}
                        </div>
                    </div>

                    <div className="card p-5">
                        <h2 className="text-base font-semibold text-foreground mb-4">Agent Network</h2>
                        <div className="relative h-64 flex items-center justify-center">
                            <div className="absolute inset-0 flex items-center justify-center">
                                <div className="w-16 h-16 rounded-full flex items-center justify-center text-xs font-bold animate-pulse-glow" style={{"background": "linear-gradient(135deg, rgba(59,130,246,0.3), rgba(139,92,246,0.3))", "border": "2px solid rgba(59,130,246,0.5)", "color": "#60a5fa"}}>
                                    CORE
                                </div>
                            </div>
                            {[
                                <div
                                    key={str(i)}
                                    className="absolute w-12 h-12 rounded-full flex items-center justify-center text-xs font-bold"
                                    style={{"background": str(agents[i]["color"]) + "22", "border": "1px solid " + str(agents[i]["color"]) + "66", "color": agents[i]["color"], "top": str([10, 10, 40, 70, 70, 40][i]) + "%", "left": str([40, 65, 80, 65, 40, 15][i]) + "%", "transform": "translate(-50%, -50%)"}}
                                >
                                    {agents[i]["short"]}
                                </div>
                                for i in range(len(agents))
                            ]}
                        </div>
                        <div className="text-center text-xs text-muted-foreground mt-2">
                            6 agents collaborating in real-time
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
