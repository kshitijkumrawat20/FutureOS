#!/usr/bin/env python3
"""Verify that Nebius Token Factory can serve the configured Nemotron model.

Uses only the Python standard library. Never prints the API key.
"""
from __future__ import annotations

import json
import os
import sys
import time
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

DEFAULT_MODEL = "nvidia/Nemotron-3_5-Lightning"
DEFAULT_ENDPOINT = "https://api.tokenfactory.nebius.com/v1/chat/completions"


def main() -> int:
    api_key = os.getenv("NEBIUS_API_KEY", "").strip()
    if not api_key:
        print("Missing NEBIUS_API_KEY. Set it in your shell before running this test.", file=sys.stderr)
        return 2

    model = os.getenv("NEBIUS_MODEL", DEFAULT_MODEL).strip() or DEFAULT_MODEL
    endpoint = (
        os.getenv("NEBIUS_TOKEN_FACTORY_CHAT_COMPLETIONS_URL", DEFAULT_ENDPOINT).strip()
        or DEFAULT_ENDPOINT
    )

    payload = {
        "model": model,
        "messages": [
            {
                "role": "user",
                "content": (
                    "Return exactly this JSON object and no other text: "
                    '{"status":"ok","provider":"Nebius Token Factory","model":"Nemotron"}'
                ),
            }
        ],
        "temperature": 0.1,
        "max_tokens": 120,
    }
    request = Request(
        endpoint,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
        method="POST",
    )

    started = time.perf_counter()
    try:
        with urlopen(request, timeout=90) as response:
            body = json.loads(response.read().decode("utf-8"))
            status_code = response.status
    except HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")[:1500]
        print(f"Token Factory returned HTTP {exc.code}: {detail}", file=sys.stderr)
        return 1
    except (URLError, TimeoutError, OSError, json.JSONDecodeError) as exc:
        print(f"Token Factory request failed: {exc}", file=sys.stderr)
        return 1

    elapsed_ms = (time.perf_counter() - started) * 1000
    choices = body.get("choices") or []
    message = (choices[0].get("message") or {}) if choices else {}
    content = message.get("content", "")
    usage = body.get("usage") or {}

    print(f"HTTP status : {status_code}")
    print(f"Model       : {body.get('model', model)}")
    print(f"Latency     : {elapsed_ms:.0f} ms")
    if usage:
        print(f"Token usage : {json.dumps(usage, sort_keys=True)}")
    print("Response:")
    print(content if isinstance(content, str) else json.dumps(content, ensure_ascii=False))

    if not content:
        print("The API returned no message content.", file=sys.stderr)
        return 1
    print("\nNebius Token Factory connectivity check passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
