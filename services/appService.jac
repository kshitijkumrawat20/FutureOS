def:pub greet(name: str) -> dict {
    return {"message": "Hello, " + name + "! FutureOS is ready."};
}

def:pub get_dashboard_data() -> dict {
    return {
        "streak": 14,
        "missions_done": 127,
        "goal_progress": 68,
        "active_goals": 3,
        "agents_active": 4
    };
}

def:pub get_goals() -> list {
    return [
        {"id": "1", "title": "Become an AI Engineer", "timeline": "6 months", "progress": 68, "status": "active"},
        {"id": "2", "title": "Crack FAANG Internship", "timeline": "4 months", "progress": 42, "status": "active"},
        {"id": "3", "title": "Build AI Startup MVP", "timeline": "3 months", "progress": 25, "status": "planning"}
    ];
}

def:pub get_missions() -> list {
    return [
        {"id": "1", "title": "Complete 2 LeetCode medium problems", "difficulty": "Medium", "xp": 150, "done": False, "tag": "DSA"},
        {"id": "2", "title": "Read 30 min: System Design Primer", "difficulty": "Easy", "xp": 80, "done": True, "tag": "Learning"},
        {"id": "3", "title": "Build REST API with FastAPI", "difficulty": "Hard", "xp": 250, "done": False, "tag": "Project"},
        {"id": "4", "title": "Review ML fundamentals notes", "difficulty": "Easy", "xp": 60, "done": False, "tag": "ML"},
        {"id": "5", "title": "Apply to 3 internship positions", "difficulty": "Medium", "xp": 120, "done": False, "tag": "Career"}
    ];
}

def:pub get_agents() -> list {
    return [
        {"name": "Planner", "status": "active", "task": "Updating Q4 roadmap"},
        {"name": "Research", "status": "active", "task": "Scanning 47 opportunities"},
        {"name": "Memory", "status": "idle", "task": "Indexed 3 new sessions"},
        {"name": "Coach", "status": "active", "task": "Analyzing burnout signals"},
        {"name": "Execution", "status": "active", "task": "Generating tomorrow's missions"},
        {"name": "Analytics", "status": "idle", "task": "Computed weekly report"}
    ];
}

def:pub get_insights() -> list {
    return [
        {"icon": "💪", "text": "You are strongest in backend engineering.", "type": "positive"},
        {"icon": "⚠️", "text": "Your DSA consistency dropped 32% this week.", "type": "warning"},
        {"icon": "🌙", "text": "You learn 40% faster during night sessions.", "type": "info"},
        {"icon": "🎯", "text": "On track to reach milestone 2 by Dec 15.", "type": "positive"}
    ];
}
