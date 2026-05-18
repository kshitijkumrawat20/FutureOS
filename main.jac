"""
FutureOS — Adaptive AI Life Operating System
"""

import from services.appService { get_dashboard_data, get_goals, get_missions, get_agents, get_insights }

cl import ".styles.global.css";

to cl:
import from .index { ClientApp }

def:pub app() -> JsxElement {
    return <ClientApp />;
}
