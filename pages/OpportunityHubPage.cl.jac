import from "@jac/runtime" { useNavigate, jacIsLoggedIn, Navigate }
import from ..components.Sidebar { Sidebar }

def:pub page() -> JsxElement {
    has active_tab: str = "internships";

    navigate = useNavigate();

    if not jacIsLoggedIn() {
        return <Navigate to="/login" replace={True} />;
    }

    def set_internships(e: MouseEvent) -> None {
        active_tab = "internships";
    }

    def set_resources(e: MouseEvent) -> None {
        active_tab = "resources";
    }

    def set_projects(e: MouseEvent) -> None {
        active_tab = "projects";
    }

    internships = [
        {"company": "Google", "role": "ML Engineer Intern", "location": "Mountain View, CA", "match": 94, "deadline": "Dec 1", "tags": ["ML", "Python", "TensorFlow"]},
        {"company": "Meta", "role": "AI Research Intern", "location": "Menlo Park, CA", "match": 88, "deadline": "Dec 15", "tags": ["PyTorch", "NLP", "Research"]},
        {"company": "OpenAI", "role": "Software Engineer Intern", "location": "San Francisco, CA", "match": 82, "deadline": "Jan 5", "tags": ["Python", "LLMs", "APIs"]},
        {"company": "Anthropic", "role": "ML Safety Intern", "location": "Remote", "match": 79, "deadline": "Jan 20", "tags": ["Safety", "ML", "Research"]},
        {"company": "Hugging Face", "role": "ML Engineer Intern", "location": "Remote", "match": 91, "deadline": "Dec 10", "tags": ["Transformers", "NLP", "Open Source"]}
    ];

    resources = [
        {"title": "Fast.ai Deep Learning Course", "type": "Course", "rating": 4.9, "time": "40h", "tag": "ML"},
        {"title": "System Design Interview", "type": "Book", "rating": 4.8, "time": "20h", "tag": "System Design"},
        {"title": "LeetCode Top 150", "type": "Practice", "rating": 4.7, "time": "60h", "tag": "DSA"},
        {"title": "Andrej Karpathy's Neural Nets", "type": "Video", "rating": 5.0, "time": "15h", "tag": "Deep Learning"},
        {"title": "Designing ML Systems", "type": "Book", "rating": 4.6, "time": "25h", "tag": "MLOps"}
    ];

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
                        <span>47 new matches</span>
                    </div>
                </div>

                <div className="flex gap-2 mb-6">
                    <button className={"btn text-sm " + ("btn-primary" if active_tab == "internships" else "btn-ghost")} onClick={set_internships}>
                        🏢 Internships
                    </button>
                    <button className={"btn text-sm " + ("btn-primary" if active_tab == "resources" else "btn-ghost")} onClick={set_resources}>
                        📚 Resources
                    </button>
                    <button className={"btn text-sm " + ("btn-primary" if active_tab == "projects" else "btn-ghost")} onClick={set_projects}>
                        🛠 Projects
                    </button>
                </div>

                {active_tab == "internships" and (
                    <div className="flex flex-col gap-4">
                        {[
                            <div key={str(i)} className="card p-5 hover:border-primary transition-colors">
                                <div className="flex items-start justify-between">
                                    <div className="flex items-start gap-4">
                                        <div className="w-12 h-12 rounded-xl flex items-center justify-center text-lg font-bold" style={{"background": "rgba(59,130,246,0.1)", "border": "1px solid rgba(59,130,246,0.2)"}}>
                                            {str(internships[i]["company"])[0]}
                                        </div>
                                        <div>
                                            <div className="text-base font-semibold text-foreground">{internships[i]["role"]}</div>
                                            <div className="text-sm text-muted-foreground">{internships[i]["company"]} · {internships[i]["location"]}</div>
                                            <div className="flex gap-1 mt-2">
                                                {[
                                                    <span key={str(j)} className="badge-blue text-xs">{tag}</span>
                                                    for (j, tag) in enumerate(list(internships[i]["tags"]))
                                                ]}
                                            </div>
                                        </div>
                                    </div>
                                    <div className="text-right flex-shrink-0">
                                        <div className="text-2xl font-bold text-gradient-blue">{str(internships[i]["match"]) + "%"}</div>
                                        <div className="text-xs text-muted-foreground">match</div>
                                        <div className="text-xs text-yellow-400 mt-1">Due {internships[i]["deadline"]}</div>
                                        <button className="btn btn-primary text-xs mt-2 py-1.5 px-3">Apply Now</button>
                                    </div>
                                </div>
                            </div>
                            for i in range(len(internships))
                        ]}
                    </div>
                )}

                {active_tab == "resources" and (
                    <div className="grid grid-cols-2 gap-4">
                        {[
                            <div key={str(i)} className="card p-5">
                                <div className="flex items-start justify-between mb-3">
                                    <span className="badge-purple">{resources[i]["type"]}</span>
                                    <span className="badge-blue">{resources[i]["tag"]}</span>
                                </div>
                                <h3 className="text-sm font-semibold text-foreground mb-2">{resources[i]["title"]}</h3>
                                <div className="flex items-center justify-between text-xs text-muted-foreground">
                                    <span>⭐ {str(resources[i]["rating"])}</span>
                                    <span>⏱ {resources[i]["time"]}</span>
                                    <button className="btn btn-ghost text-xs py-1 px-2">Start →</button>
                                </div>
                            </div>
                            for i in range(len(resources))
                        ]}
                    </div>
                )}

                {active_tab == "projects" and (
                    <div className="card p-8 text-center">
                        <div className="text-4xl mb-4">🛠</div>
                        <h3 className="text-lg font-semibold text-foreground mb-2">Project Ideas Coming Soon</h3>
                        <p className="text-muted-foreground text-sm">AI is generating personalized project ideas based on your goals and skill gaps.</p>
                    </div>
                )}
            </div>
        </div>
    );
}
