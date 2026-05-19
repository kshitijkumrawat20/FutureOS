"""
FutureOS — Adaptive AI Life Operating System
"""

import from services.appService {
    Goal, Mission, MemoryEntry,
    get_goals, add_goal, update_goal_progress, delete_goal,
    get_missions, add_mission, toggle_mission, delete_mission,
    get_memories, add_memory,
    get_stats
}

cl import ".styles.global.css";

to cl:
import from .index { ClientApp }

def:pub app() -> JsxElement {
    return <ClientApp />;
}
