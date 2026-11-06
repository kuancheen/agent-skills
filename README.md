# Agent Skills (`agent-skills`)

A centralized, public collection of custom skills, runbooks, and state-management workflows for **Google Antigravity** agents.

These skills are prefixed with `0-` so they automatically sort to the top when invoking slash commands in the Antigravity chat prompt (typing `/0` shows all skills).

---

## Included Skills

| Skill | Slash Command | Description |
| :--- | :--- | :--- |
| **`0-create-token-saving-mds`** | `/0-create-token-saving-mds` | Scans conversation/codebase and initializes the token-saving memory strategy: creates `new_conversation.md`, `implementation_plan.md`, and `walkthrough.md`. |
| **`0-start-new-conversation`** | `/0-start-new-conversation` | Bootstraps a fresh conversation session using `new_conversation.md`, `implementation_plan.md`, and `walkthrough.md` to restore context instantly. |
| **`0-update-all-mds`** | `/0-update-all-mds` | Performs atomic state handover: updates `implementation_plan.md`, `walkthrough.md`, `README.md`, and `new_conversation.md` (done, learned, next) and commits to Git. |
| **`0-make-subrepo`** | `/0-make-subrepo` | Integrates a repository or project as a formal private Git submodule under a main repository with parameter validation and explicit confirmation gates. |
| **`0-resume-session`** | `/0-resume-session` | Inspects incomplete files, git diff, and task checklists to immediately resume work interrupted by token or context limits. |

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
