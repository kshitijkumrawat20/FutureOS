import from "@jac/runtime" { useNavigate, jacIsLoggedIn, Navigate }
import from ..components.Sidebar { Sidebar }

def:pub page() -> JsxElement {
    navigate = useNavigate();

    if not jacIsLoggedIn() {
        return <Navigate to="/login" replace={True} />;
    }

    sessions = [
        {"date": "Today, 8:45 PM", "duration": "2h 15m", "tasks": 4, "focus": 92, "tags": ["DSA", "Python"], "summary": "Completed 2 LeetCode mediums. Strong performance on graph problems. Struggled with DP."},
        {"date": "Yesterday, 9:00 PM", "duration": "1h 45m", "tasks": 3, "focus": 78, "tags": ["ML", "Reading"], "summary": "Read System Design Primer chapters 4-6. Reviewed neural network fundamentals."},
        {"date": "Nov 18, 8:30 PM", "duration": "3h 00m", "tasks": 6, "focus": 88, "tags": ["Project", "FastAPI"], "summary": "Built REST API with FastAPI. Implemented auth endpoints. Deployed to Render."},
        {"date": "Nov 17, 7:00 PM", "duration": "1h 30m", "tasks": 2, "focus": 65, "tags": ["Career"], "summary": "Updated resume. Applied to 3 ML internship positions at Google and Meta."},
        {"date": "Nov 16, 9:15 PM", "duration": "2h 30m", "tasks": 5, "focus": 95, "tags": ["DSA", "Trees"], "summary": "Mastered binary tree traversals. Solved 5 tree problems. Best session this week."}
    ];

    memories = [
        {"type": "strength", "icon": "💪", "text": "Strong in backend engineering and API design", "color": "#10b981"},
        {"type": "weakness", "icon": "⚠️", "text": "Dynamic programming needs more practice", "color": "#f59e0b"},
        {"type": "pattern", "icon": "🌙", "text": "Peak performance: weekdays 8-11 PM", "color": "#3b82f6"},
        {"type": "achievement", "icon": "🏆", "text": "Completed 14-day streak — personal record", "color": "#8b5cf6"},
        {"type": "weakness", "icon": "📉", "text": "DSA consistency dropped 32% this week", "color": "#ef4444"},
        {"type": "pattern", "icon": "🔄", "text": "Learns faster with project-based approach", "color": "#06b6d4"}
    ];

    return (
        <div className="page">
            <Sidebar />
            <div className="page-content">
                <div className="page-header">
                    <div>
                        <h1 className="text-2xl font-bold text-foreground">Memory Timeline</h1>
                        <p className="text-muted-foreground text-sm mt-1">AI-indexed learning history and behavioral patterns</p>
                    </div>
                    <div className="badge-cyan">
                        <span>🧠</span>
                        <span>Memory Active</span>
                    </div>
                </div>

                <div className="grid grid-cols-3 gap-6">
                    <div className="col-span-2">
                        <h2 className="text-base font-semibold text-foreground mb-4">Session History</h2>
                        <div className="relative">
                            <div className="absolute left-4 top-0 bottom-0 w-px" style={{"background": "rgba(59,130,246,0.2)"}}></div>
                            <div className="flex flex-col gap-4">
                                {[
                                    <div key={str(i)} className="flex items-start gap-4 pl-10 relative">
                                        <div className="absolute left-2.5 w-3 h-3 rounded-full border-2 border-primary" style={{"top": "16px", "background": "#3b82f6"}}></div>
                                        <div className="flex-1 card p-4">
                                            <div className="flex items-start justify-between mb-2">
                                                <div>
                                                    <div className="text-sm font-medium text-foreground">{sessions[i]["date"]}</div>
                                                    <div className="text-xs text-muted-foreground">{sessions[i]["duration"]} · {str(sessions[i]["tasks"])} tasks</div>
                                                </div>
                                                <div className="text-right">
                                                    <div className="text-sm font-bold" style={{"color": "#3b82f6"}}>{str(sessions[i]["focus"]) + "%"}</div>
                                                    <div className="text-xs text-muted-foreground">focus</div>
                                                </div>
                                            </div>
                                            <p className="text-xs text-muted-foreground mb-2 leading-relaxed">{sessions[i]["summary"]}</p>
                                            <div className="flex gap-1">
                                                {[
                                                    <span key={str(j)} className="badge-blue text-xs">{tag}</span>
                                                    for (j, tag) in enumerate(list(sessions[i]["tags"]))
                                                ]}
                                            </div>
                                        </div>
                                    </div>
                                    for i in range(len(sessions))
                                ]}
                            </div>
                        </div>
                    </div>

                    <div>
                        <h2 className="text-base font-semibold text-foreground mb-4">AI Memory Bank</h2>
                        <div className="flex flex-col gap-3">
                            {[
                                <div key={str(i)} className="card p-4">
                                    <div className="flex items-start gap-3">
                                        <span style={{"fontSize": "18px"}}>{memories[i]["icon"]}</span>
                                        <div>
                                            <div className="text-xs font-medium mb-1" style={{"color": memories[i]["color"]}}>{memories[i]["type"].upper()}</div>
                                            <p className="text-xs text-muted-foreground leading-relaxed">{memories[i]["text"]}</p>
                                        </div>
                                    </div>
                                </div>
                                for i in range(len(memories))
                            ]}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
