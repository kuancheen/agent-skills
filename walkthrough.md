# Walkthrough: Antigravity Skills Architecture

Overview of repository architecture, active file structures, verified skills, and operational lessons.

---

## 1. System Architecture & Objectives

The goal of `agent-skills` is to provide a portable, version-controlled library of Antigravity custom skills. It specifically establishes a **token-saving state management pattern**:

```text
                  +-----------------------------------+
                  |        new_conversation.md        |
                  |     (Rules of the Conversation)   |
                  +-----------------+-----------------+
                                    |
          +-------------------------+-------------------------+
          |                                                   |
          v                                                   v
+-----------------------+                           +--------------------+
|  implementation_plan  |                           |   walkthrough.md   |
|   (Checklist Memory)  |                           |  (Living Overview) |
+-----------------------+                           +--------------------+
```

Rather than storing state in chat history (which burns tokens and causes context loss), the state is offloaded into repository markdown artifacts that are read at the start of each session and committed on every task completion.

---

## 2. Directory Structure

```text
agent-skills/
├── .gemini/
│   └── config/
│       └── skills/
│           ├── 0-create-token-saving-mds/
│           │   └── SKILL.md       # Workflow to scan repo and initialize MD memory artifacts
│           ├── 0-make-subrepo/
│           │   └── SKILL.md       # Safe Git submodule registration with approval gates
│           ├── 0-resume-session/
│           │   └── SKILL.md       # Recovery workflow after token/context limits
│           ├── 0-start-new-conversation/
│           │   └── SKILL.md       # Bootstrap fresh session from MD artifacts
│           └── 0-update-all-mds/
│               └── SKILL.md       # Atomic state handover and git commit
├── .gitignore                     # Enforces only 0-* skills are tracked
├── deployment_checklist.md        # Step-by-step verification before deployment
├── implementation_plan.md         # Active technical checklist
├── new_conversation.md            # Session instructions and editing rules
├── README.md                      # Public documentation & installation guide
└── walkthrough.md                 # System overview and lessons learned
```

---

## 3. Verified Features

1. **`0-` Prefix Sorting**: Verified that Antigravity matches regex `^[a-z0-9]+(-[a-z0-9]+)*$`. The `0-` prefix complies with the spec and ensures custom skills cluster at the top of the autocomplete list when typing `/0`.
2. **Strict Approval Gate on `0-make-subrepo`**: The skill requires explicit confirmation of subrepo parameters (URL, name, target path) before any `git submodule add` command is executed.
3. **Clean Security Scan**: Verified that none of the skills contain absolute local file paths, private keys, tokens, or proprietary URLs.

---

## 4. Things Learned & Operational Rules

1. **Naming Restrictions**:
   - Symbols like `!` or bare leading hyphens (`-name`) are invalid and break YAML frontmatter parsers or CLI flag handling.
   - Digits (`0-9`) are valid start characters and provide an effective grouping prefix.
2. **File Editing Golden Rule**:
   - Never use blind overwriting on markdown memory artifacts (`implementation_plan.md`, `walkthrough.md`, `new_conversation.md`).
   - Always view/read the file first, then perform selective diff replacements.
