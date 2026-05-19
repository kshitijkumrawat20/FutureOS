import from "@jac/runtime" { useNavigate, jacIsLoggedIn, Navigate }
import from ..components.Sidebar { Sidebar }
sv import from ..services.appService { Goal, OpportunityReport, get_goals, agent_get_opportunities }

def:pub page() -> JsxElement {
    has active_tab: str = "internships";
    has goals: list[Goal] = [];
    has opportunities: OpportunityReport | None = None;
    has loading: bool = True;
    has error: str = "";

    navigate = useNavigate();

    if not jacIsLoggedIn() {
        return <Navigate to="/login" replace={True} />;
    }

    async can with entry {
        if jacIsLoggedIn() {
            try {
                goals = await get_goals();
                if len(goals) > 0 {
                    first_id: str = jid(goals[0]);
                    opportunities = await agent_get_opportunities(first_id);
                }
            } except Exception as ex {
                error = "Failed to load opportunities";
            }
            loading = False;
        }
    }

    async def do_set_internships() -> None {
        goals = await get_goals();
        active_tab = "internships";
    }

    async def do_set_courses() -> None {
        goals = await get_goals();
        active_tab = "courses";
    }

    async def do_set_projects() -> None {
        goals = await get_goals();
        active_tab = "projects";
    }

    def set_internships(e: MouseEvent) -> None {
        do_set_internships();
    }

    def set_courses(e: MouseEvent) -> None {
        do_set_courses();
    }

    def set_projects(e: MouseEvent) -> None {
        do_set_projects();
    }

    return (
        <div className="page">
            <Sidebar />
            <div className="page-content">
                <div className="page-header">
                    <div>
                        <h1 className="text-2xl font-bold text-foreground">Opportunity Hub</h1>
                        <p className="text-muted-foreground text-sm mt-1">AI-curated opportunities matched to your goals</p>
                    </div>
                    <div className="badge-purple">
                        <span>🚀</span>
                        <span>AI Research Agent</span>
                    </div>
                </div>

                {loading and (
                    <div className="flex items-center justify-center py-20">
                        <div className="text-center">
                            <div className="flex gap-2 justify-center mb-3">
                                <span className="typing-dot"></span>
                                <span className="typing-dot"></span>
                                <span className="typing-dot"></span>
                            </div>
                            <p className="text-muted-foreground text-sm">Research Agent scanning opportunities...</p>
                        </div>
                    </div>
                )}

                {not loading and len(goals) == 0 and (
                    <div className="card p-12 text-center">
                        <div className="text-5xl mb-4">🚀</div>
                        <h2 className="text-xl font-semibold text-foreground mb-2">No goals yet</h2>
                        <p className="text-muted-foreground text-sm mb-6">Add a goal first — the Research Agent will find personalized opportunities for you.</p>
                        <button className="btn btn-primary" onClick={set_internships}>Go to Goals →</button>
                    </div>
                )}

                {not loading and len(goals) > 0 and opportunities is None and (
                    <div className="card p-12 text-center">
                        <div className="text-5xl mb-4">🔍</div>
                        <h2 className="text-xl font-semibold text-foreground mb-2">Scanning opportunities...</h2>
                        <p className="text-muted-foreground text-sm">The Research Agent is analyzing your goal and finding the best opportunities.</p>
                    </div>
                )}

                {not loading and opportunities is not None and (
                    <div>
                        <div className="flex gap-2 mb-6">
                            <button className={"btn text-sm " + ("btn-primary" if active_tab == "internships" else "btn-ghost")} onClick={set_internships}>
                                🏢 Internships & Jobs
                            </button>
                            <button className={"btn text-sm " + ("btn-primary" if active_tab == "courses" else "btn-ghost")} onClick={set_courses}>
                                📚 Courses
                            </button>
                            <button className={"btn text-sm " + ("btn-primary" if active_tab == "projects" else "btn-ghost")} onClick={set_projects}>
                                🛠 Projects
                            </button>
                        </div>

                        {active_tab == "internships" and (
                            <div className="flex flex-col gap-4">
                                {[
                                    <div key={str(i)} className="card p-5">
                                        <div className="flex items-start gap-4">
                                            <div className="w-12 h-12 rounded-xl flex items-center justify-center text-lg font-bold" style={{"background": "rgba(59,130,246,0.1)", "border": "1px solid rgba(59,130,246,0.2)"}}>
                                                🏢
                                            </div>
                                            <div className="flex-1">
                                                <div className="text-base font-semibold text-foreground mb-1">{str(opportunities.internships[i])}</div>
                                                <div className="flex gap-2 mt-2">
                                                    <span className="badge-blue text-xs">AI Matched</span>
                                                    <span className="badge-green text-xs">Relevant</span>
                                                </div>
                                            </div>
                                            <button className="btn btn-primary text-xs py-1.5 px-3">Apply →</button>
                                        </div>
                                    </div>
                                    for i in range(len(opportunities.internships))
                                ]}
                            </div>
                        )}

                        {active_tab == "courses" and (
                            <div className="grid grid-cols-2 gap-4">
                                {[
                                    <div key={str(i)} className="card p-5">
                                        <div className="text-2xl mb-3">📚</div>
                                        <div className="text-sm font-semibold text-foreground mb-2">{str(opportunities.courses[i])}</div>
                                        <div className="flex items-center justify-between mt-3">
                                            <span className="badge-purple text-xs">AI Curated</span>
                                            <button className="btn btn-ghost text-xs py-1 px-2">Start →</button>
                                        </div>
                                    </div>
                                    for i in range(len(opportunities.courses))
                                ]}
                            </div>
                        )}

                        {active_tab == "projects" and (
                            <div className="grid grid-cols-2 gap-4">
                                {[
                                    <div key={str(i)} className="card p-5">
                                        <div className="text-2xl mb-3">🛠</div>
                                        <div className="text-sm font-semibold text-foreground mb-2">{str(opportunities.projects[i])}</div>
                                        <div className="flex items-center justify-between mt-3">
                                            <span className="badge-cyan text-xs">Project Idea</span>
                                            <button className="btn btn-ghost text-xs py-1 px-2">Build →</button>
                                        </div>
                                    </div>
                                    for i in range(len(opportunities.projects))
                                ]}
                            </div>
                        )}

                        {opportunities.networking and (
                            <div className="card p-5 mt-6">
                                <h2 className="text-base font-semibold text-foreground mb-4">🤝 Networking Opportunities</h2>
                                <div className="grid grid-cols-2 gap-3">
                                    {[
                                        <div key={str(i)} className="p-3 rounded-xl" style={{"background": "rgba(139,92,246,0.05)", "border": "1px solid rgba(139,92,246,0.1)"}}>
                                            <p className="text-xs text-muted-foreground">{str(opportunities.networking[i])}</p>
                                        </div>
                                        for i in range(len(opportunities.networking))
                                    ]}
                                </div>
                            </div>
                        )}
                    </div>
                )}
            </div>
        </div>
    );
}
