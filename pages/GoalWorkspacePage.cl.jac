import from "@jac/runtime" { useNavigate, jacIsLoggedIn, Navigate }
import from ..components.Sidebar { Sidebar }

def:pub page() -> JsxElement {
    has selected_goal: int = 0;

    navigate = useNavigate();

    if not jacIsLoggedIn() {
        return <Navigate to="/login" replace={True} />;
    }

    goals = [
        {"title": "Become an AI Engineer", "timeline": "6 months", "progress": 68, "status": "active", "color": "#3b82f6"},
        {"title": "Crack FAANG Internship", "timeline": "4 months", "progress": 42, "status": "active", "color": "#8b5cf6"},
        {"title": "Build AI Startup MVP", "timeline": "3 months", "progress": 25, "status": "planning", "color": "#06b6d4"}
    ];

    milestones = [
        {"title": "Master Python & ML Fundamentals", "week": "Week 1-3", "done": True, "tasks": 12},
        {"title": "Build 3 ML Projects", "week": "Week 4-7", "done": True, "tasks": 8},
        {"title": "Deep Learning & Neural Networks", "week": "Week 8-11", "done": False, "tasks": 15},
        {"title": "LLM Engineering & Prompt Design", "week": "Week 12-15", "done": False, "tasks": 10},
        {"title": "System Design for AI", "week": "Week 16-18", "done": False, "tasks": 9},
        {"title": "Portfolio & Job Applications", "week": "Week 19-24", "done": False, "tasks": 20}
    ];

    strategies = [
        {"agent": "Planner", "text": "Focus on hands-on projects over theory. Build 1 project per milestone."},
        {"agent": "Research", "text": "Target ML Engineer roles at mid-size AI companies first, then FAANG."},
        {"agent": "Coach", "text": "Your learning velocity is highest on weekdays 8-11 PM. Schedule deep work then."},
        {"agent": "Analytics", "text": "At current pace, you'll reach 80% readiness by month 5. Accelerate DSA practice."}
    ];

    return (
        <div className="page">
            <Sidebar />
            <div className="page-content">
                <div className="page-header">
                    <div>
                        <h1 className="text-2xl font-bold text-foreground">Goal Workspace</h1>
                        <p className="text-muted-foreground text-sm mt-1">AI-generated roadmaps and adaptive strategies</p>
                    </div>
                    <button className="btn btn-primary">+ Add Goal</button>
                </div>

                <div className="flex gap-3 mb-6">
                    {[
                        <button
                            key={str(i)}
                            className={"px-4 py-2 rounded-xl text-sm font-medium transition-all " + ("text-white" if selected_goal == i else "text-muted-foreground hover:text-foreground")}
                            style={{"background": (goals[i]["color"] + "22") if selected_goal == i else "rgba(255,255,255,0.03)", "border": "1px solid " + (goals[i]["color"] + "44" if selected_goal == i else "rgba(255,255,255,0.06)")}}
                            onClick={lambda e, idx=i: None}
                        >
                            {goals[i]["title"]}
                        </button>
                        for i in range(len(goals))
                    ]}
                </div>

                <div className="grid grid-cols-3 gap-6">
                    <div className="col-span-2">
                        <div className="card p-6 mb-6">
                            <div className="flex items-center justify-between mb-2">
                                <h2 className="text-lg font-semibold text-foreground">{goals[selected_goal]["title"]}</h2>
                                <span className="badge-blue">{goals[selected_goal]["timeline"]}</span>
                            </div>
                            <div className="flex items-center gap-3 mb-4">
                                <div className="progress-bar flex-1">
                                    <div className="progress-fill" style={{"width": str(goals[selected_goal]["progress"]) + "%"}}></div>
                                </div>
                                <span className="text-sm font-medium text-foreground">{str(goals[selected_goal]["progress"]) + "%"}</span>
                            </div>

                            <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-4">Roadmap Milestones</h3>
                            <div className="relative">
                                <div className="absolute left-4 top-0 bottom-0 w-px" style={{"background": "rgba(59,130,246,0.2)"}}></div>
                                <div className="flex flex-col gap-4">
                                    {[
                                        <div key={str(i)} className="flex items-start gap-4 pl-10 relative">
                                            <div className={"absolute left-2.5 w-3 h-3 rounded-full border-2 " + ("bg-green-400 border-green-400" if milestones[i]["done"] else "bg-background border-border")} style={{"top": "4px"}}></div>
                                            <div className={"flex-1 p-4 rounded-xl " + ("opacity-60" if milestones[i]["done"] else "")} style={{"background": "rgba(59,130,246,0.04)", "border": "1px solid rgba(59,130,246,0.1)"}}>
                                                <div className="flex items-center justify-between">
                                                    <span className={"text-sm font-medium " + ("line-through text-muted-foreground" if milestones[i]["done"] else "text-foreground")}>{milestones[i]["title"]}</span>
                                                    <div className="flex items-center gap-2">
                                                        <span className="text-xs text-muted-foreground">{str(milestones[i]["tasks"]) + " tasks"}</span>
                                                        <span className="badge-blue text-xs">{milestones[i]["week"]}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        for i in range(len(milestones))
                                    ]}
                                </div>
                            </div>
                        </div>
                    </div>

                    <div>
                        <div className="card p-5 mb-4">
                            <h2 className="text-base font-semibold text-foreground mb-4">AI Strategy Panel</h2>
                            <div className="flex flex-col gap-3">
                                {[
                                    <div key={str(i)} className="p-3 rounded-xl" style={{"background": "rgba(139,92,246,0.05)", "border": "1px solid rgba(139,92,246,0.1)"}}>
                                        <div className="text-xs font-medium mb-1" style={{"color": "#a78bfa"}}>{strategies[i]["agent"]} Agent</div>
                                        <p className="text-xs text-muted-foreground leading-relaxed">{strategies[i]["text"]}</p>
                                    </div>
                                    for i in range(len(strategies))
                                ]}
                            </div>
                        </div>

                        <div className="card p-5">
                            <h2 className="text-base font-semibold text-foreground mb-3">Timeline Prediction</h2>
                            <div className="text-center py-4">
                                <div className="text-4xl font-bold text-gradient-blue mb-1">Dec 15</div>
                                <div className="text-xs text-muted-foreground">Predicted completion</div>
                                <div className="mt-3 text-xs text-green-400">✓ On track</div>
                            </div>
                            <div className="divider"></div>
                            <div className="flex justify-between text-xs">
                                <span className="text-muted-foreground">Velocity</span>
                                <span className="text-foreground font-medium">8.4 tasks/week</span>
                            </div>
                            <div className="flex justify-between text-xs mt-2">
                                <span className="text-muted-foreground">Consistency</span>
                                <span className="text-foreground font-medium">76%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
