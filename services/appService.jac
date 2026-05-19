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

# ==== GOALS ====

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

# ==== MISSIONS ====

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

# ==== MEMORY ====

def:priv get_memories() -> list[MemoryEntry] {
    return [root -->][?:MemoryEntry];
}

def:priv add_memory(summary: str, tags: str, focus_score: int, duration: str) -> MemoryEntry {
    e = (root ++> MemoryEntry(summary=summary, tags=tags, focus_score=focus_score, duration=duration, created_at="now"))[0];
    return e;
}

# ==== STATS ====

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
