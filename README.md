# Agent Skills (`agent-skills`)

A centralized, public collection of custom skills, runbooks, and state-management workflows for **Google Antigravity** agents.

These skills are prefixed with `0-` so they automatically sort to the top when invoking slash commands in the Antigravity chat prompt (typing `/0` shows all skills).

---

## Included Skills

| Skill | Slash Command | Description |
| :--- | :--- | :--- |
| **`0-create-token-saving-mds`** | `/0-create-token-saving-mds` | Scans conversation/codebase and initializes the token-saving memory strategy: creates `README.md`, `new_conversation.md`, `implementation_plan.md`, `walkthrough.md`, and optionally `deployment_checklist.md`. |
| **`0-start-new-conversation`** | `/0-start-new-conversation` | Bootstraps a fresh conversation session using `README.md`, `new_conversation.md`, `implementation_plan.md`, and `walkthrough.md` to restore context instantly. |
| **`0-update-all-mds`** | `/0-update-all-mds` | Performs atomic state handover: syncs living memory artifacts (with auto-bootstrap fallback) and commits to Git. |
| **`0-make-subrepo`** | `/0-make-subrepo` | Integrates a repository or project as a formal private Git submodule under a main repository with parameter validation and explicit confirmation gates. |
| **`0-resume-session`** | `/0-resume-session` | Inspects incomplete files, git diff, task checklists, and deployment state to immediately resume work interrupted by token or context limits. |

---

## 🧠 AI Agent State Management

This repository uses an AI-first living memory workflow. Every agent session bootstraps from these documents — no context is stored in chat history.

| File | Role |
|---|---|
| [`new_conversation.md`](./new_conversation.md) | Agent *operating rules* — what to DO automatically every task block |
| [`walkthrough.md`](./walkthrough.md) | Architecture memory — how the system works, active files, completed features |
| [`implementation_plan.md`](./implementation_plan.md) | What's next / what's done — strict checklist of pending and completed tasks |
| [`deployment_checklist.md`](./deployment_checklist.md) | *(If present)* Full reference — new machine setup, secrets, and deployment protocol |

> **For AI Agents:** Read these documents at the start of every session. Do not ask the user for context already documented there.

---

## Directory Structure

```text
agent-skills/
├── .gemini/
│   └── config/
│       └── skills/
│           ├── 0-create-token-saving-mds/SKILL.md
│           ├── 0-make-subrepo/SKILL.md
│           ├── 0-resume-session/SKILL.md
│           ├── 0-start-new-conversation/SKILL.md
│           └── 0-update-all-mds/SKILL.md
├── .gitignore
├── deployment_checklist.md
├── implementation_plan.md
├── new_conversation.md
├── README.md
└── walkthrough.md
```

---

## Installation & Setup

### 1. Global Installation (Recommended)
To make these skills globally available across all your Antigravity workspaces:

```bash
# Clone the repository
git clone https://github.com/kuancheen/agent-skills.git ~/agent-skills

# Symlink all 0- skills to your global Antigravity config
mkdir -p ~/.gemini/config/skills
ln -s ~/agent-skills/.gemini/config/skills/0-* ~/.gemini/config/skills/
```

### 2. Project-Specific Installation
To use these skills only in a specific project:

```bash
cd /path/to/your/project
mkdir -p .agents/skills
cp -r /path/to/agent-skills/.gemini/config/skills/0-* .agents/skills/
```

---

## Usage
Inside Antigravity, simply type:
```text
/0
```
The autocomplete menu will display the `0-` skills at the top. Select any skill to run its procedure.
