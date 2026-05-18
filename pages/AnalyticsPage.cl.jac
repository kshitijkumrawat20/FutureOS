import from "@jac/runtime" { useNavigate, jacIsLoggedIn, Navigate }
import from ..components.Sidebar { Sidebar }

def:pub page() -> JsxElement {
    has active_period: str = "week";

    navigate = useNavigate();

    if not jacIsLoggedIn() {
        return <Navigate to="/login" replace={True} />;
    }

    def set_week(e: MouseEvent) -> None {
        active_period = "week";
    }

    def set_month(e: MouseEvent) -> None {
        active_period = "month";
    }

    def set_quarter(e: MouseEvent) -> None {
        active_period = "quarter";
    }

    weekly_bars = [60, 80, 45, 90, 70, 85, 55];
    days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    heatmap_data = [
        [3, 5, 2, 7, 4, 6, 1],
        [6, 8, 5, 9, 7, 4, 3],
        [2, 4, 8, 5, 6, 7, 2],
        [7, 3, 6, 4, 8, 5, 9]
    ];

    metrics = [
        {"label": "Tasks Completed", "value": "127", "change": "+12%", "positive": True},
        {"label": "Avg Daily Focus", "value": "4.2h", "change": "+8%", "positive": True},
        {"label": "Streak Days", "value": "14", "change": "+3", "positive": True},
        {"label": "Goal Velocity", "value": "8.4/wk", "change": "-2%", "positive": False}
    ];

    predictions = [
        {"label": "Goal Completion", "value": "Dec 15", "confidence": 87},
        {"label": "Milestone 3 ETA", "value": "Nov 28", "confidence": 92},
        {"label": "Burnout Risk", "value": "Low", "confidence": 78}
    ];

    return (
        <div className="page">
            <Sidebar />
            <div className="page-content">
                <div className="page-header">
                    <div>
                        <h1 className="text-2xl font-bold text-foreground">Analytics</h1>
                        <p className="text-muted-foreground text-sm mt-1">Performance insights and AI predictions</p>
                    </div>
                    <div className="flex gap-2">
                        <button className={"btn text-xs " + ("btn-primary" if active_period == "week" else "btn-ghost")} onClick={set_week}>Week</button>
                        <button className={"btn text-xs " + ("btn-primary" if active_period == "month" else "btn-ghost")} onClick={set_month}>Month</button>
                        <button className={"btn text-xs " + ("btn-primary" if active_period == "quarter" else "btn-ghost")} onClick={set_quarter}>Quarter</button>
                    </div>
                </div>

                <div className="grid grid-cols-4 gap-4 mb-6">
                    {[
                        <div key={str(i)} className="stat-card">
                            <div className="text-xs text-muted-foreground uppercase tracking-wider mb-2">{metrics[i]["label"]}</div>
                            <div className="text-3xl font-bold text-gradient-blue">{metrics[i]["value"]}</div>
                            <div className={"text-xs mt-1 " + ("text-green-400" if metrics[i]["positive"] else "text-red-400")}>{metrics[i]["change"]}</div>
                        </div>
                        for i in range(len(metrics))
                    ]}
                </div>

                <div className="grid grid-cols-3 gap-6 mb-6">
                    <div className="col-span-2 card p-5">
                        <h2 className="text-base font-semibold text-foreground mb-4">Daily Productivity</h2>
                        <div className="flex items-end gap-2 h-32">
                            {[
                                <div key={str(i)} className="flex-1 flex flex-col items-center gap-1">
                                    <div className="w-full rounded-t transition-all" style={{"height": str(weekly_bars[i]) + "%", "background": "linear-gradient(to top, #3b82f6, #8b5cf6)", "minHeight": "4px"}}></div>
                                    <span className="text-xs text-muted-foreground">{days[i]}</span>
                                </div>
                                for i in range(7)
                            ]}
                        </div>
                    </div>

                    <div className="card p-5">
                        <h2 className="text-base font-semibold text-foreground mb-4">AI Predictions</h2>
                        <div className="flex flex-col gap-4">
                            {[
                                <div key={str(i)}>
                                    <div className="flex justify-between text-xs mb-1">
                                        <span className="text-muted-foreground">{predictions[i]["label"]}</span>
                                        <span className="text-foreground font-medium">{predictions[i]["value"]}</span>
                                    </div>
                                    <div className="progress-bar">
                                        <div className="progress-fill" style={{"width": str(predictions[i]["confidence"]) + "%"}}></div>
                                    </div>
                                    <div className="text-xs text-muted-foreground mt-0.5">{str(predictions[i]["confidence"]) + "% confidence"}</div>
                                </div>
                                for i in range(len(predictions))
                            ]}
                        </div>
                    </div>
                </div>

                <div className="card p-5">
                    <h2 className="text-base font-semibold text-foreground mb-4">Activity Heatmap</h2>
                    <div className="flex gap-1">
                        {[
                            <div key={str(col)} className="flex flex-col gap-1">
                                {[
                                    <div
                                        key={str(row)}
                                        className="w-8 h-8 rounded"
                                        style={{"background": "rgba(59,130,246," + str(heatmap_data[row][col] * 0.1) + ")", "border": "1px solid rgba(59,130,246,0.1)"}}
                                        title={str(heatmap_data[row][col]) + " tasks"}
                                    ></div>
                                    for row in range(4)
                                ]}
                            </div>
                            for col in range(7)
                        ]}
                    </div>
                    <div className="flex items-center gap-2 mt-3">
                        <span className="text-xs text-muted-foreground">Less</span>
                        {[
                            <div key={str(i)} className="w-4 h-4 rounded" style={{"background": "rgba(59,130,246," + str((i + 1) * 0.2) + ")"}}></div>
                            for i in range(5)
                        ]}
                        <span className="text-xs text-muted-foreground">More</span>
                    </div>
                </div>
            </div>
        </div>
    );
}
