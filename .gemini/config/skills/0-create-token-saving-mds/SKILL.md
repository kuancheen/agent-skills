---
name: 0-create-token-saving-mds
description: Initializes the token-saving living memory workflow for a project. Scans the workspace/history and creates README.md, new_conversation.md, implementation_plan.md, walkthrough.md, and optionally deployment_checklist.md. Trigger when user asks to adopt the token-saving strategy or runs /0-create-token-saving-mds.
---

# Initialize Token-Saving Markdown Artifacts

## Purpose
Establishes a token-saving state-management architecture using `README.md`, `implementation_plan.md`, `walkthrough.md`, and (when applicable) `deployment_checklist.md` as the repository's living memory, governed by `new_conversation.md`. Keeps conversations short, clean, and context-efficient.

## Strict Safety & Editing Rules
- **NEVER blindly overwrite existing files.**
- If `README.md`, `implementation_plan.md`, `walkthrough.md`, `new_conversation.md`, or `deployment_checklist.md` already exist, inspect them first. Merge new findings into them instead of replacing them wholesale.
- Do not make assumptions about workspace state without viewing existing files first.

## Procedure

### Step 1: Scan Workspace and History
1. Inspect the workspace root, directory tree, existing documentation (`README.md`, config files), and recent conversation history.
2. Identify:
   - Project purpose, core tech stack, and primary features.
   - Fully completed and verified features.
   - Pending features, architectural decisions, and remaining tasks.
   - Development environment, setup steps, scripts, and GitHub repositories in play.
   - **Deployment & Hosting Requirements**: Check if the project interacts with remote servers, Cloudflare, VMs, Docker, PM2, Apps Script, cloud functions, or untracked environment secrets (`.env`).
   - Key lessons learned and common mistakes encountered.

### Step 2: Create or Perfect `README.md` in Root (Mandatory Default)
- **If `README.md` does not exist:**
  Create `README.md` containing:
  1. Project Title & Overview.
  2. **AI Agent State Management Table** (linking to all core artifacts):
     ```markdown
     ## 🧠 AI Agent State Management

     This repository uses an AI-first living memory workflow. Every agent session bootstraps from these documents — no context is stored in chat history.

     | File | Role |
     |---|---|
     | [`new_conversation.md`](./new_conversation.md) | Agent *operating rules* — what to DO automatically every task block |
     | [`walkthrough.md`](./walkthrough.md) | Architecture memory — how the system works, active files, completed features |
     | [`implementation_plan.md`](./implementation_plan.md) | What's next / what's done — strict checklist of pending and completed tasks |
     | [`deployment_checklist.md`](./deployment_checklist.md) | *(If present)* Full reference — new machine setup, secrets, and deployment protocol |

     > **For AI Agents:** Read these documents at the start of every session. Do not ask the user for context already documented there.
     ```
  3. Environment, Prerequisites, and Quickstart/Setup commands.
- **If `README.md` already exists:**
  Inspect its content. If the **AI Agent State Management Table** is missing, inject it directly under the introduction/header while preserving all existing project documentation.

### Step 3: Create `implementation_plan.md` in Root
Create (or update if present) `implementation_plan.md` in the project root containing:
- Crisp checkboxes (`- [ ]`) grouped by milestone, priority, or module.
- Immediate next actions.
- Pending architectural decisions.

### Step 4: Create `walkthrough.md` in Root
Create (or update if present) `walkthrough.md` in the project root containing:
- System overview and architectural design.
- Active directory and file structure breakdown.
- Completed, tested, and verified features.
- Host environment, setup commands, scripts, and GitHub submodule/repo links.
- Key lessons learned and operational notes.
- Production deployment references (linking to `deployment_checklist.md` if applicable).

### Step 5: Propose or Create `deployment_checklist.md` (Feasibility Check)
- **If the project involves hosting, deployment, or remote servers:**
  Create `deployment_checklist.md` in the root directory covering:
  1. **Machine & Environment Profiles**: Local dev machine paths vs remote server endpoints / SSH keys.
  2. **Untracked Secrets & Configs**: Steps for fresh machines to acquire `.env`, service accounts, or local DBs safely.
  3. **Deployment Protocol**: Exact, copy-pasteable commands (`scp` to explicit file paths, `rsync`, container/PM2 restarts with explicit binary paths).
  4. **Post-Deployment Smoke Tests**: Curl commands, endpoint checks, log inspection, or verification steps.
- **If the project is purely a local utility or library without deployment:**
  Skip creating `deployment_checklist.md` (or add a placeholder only if requested by the user).

### Step 6: Create or Perfect `new_conversation.md` in Root
Create `new_conversation.md` in the project root containing the operational guidelines for future sessions:

```markdown
# Core Objective
You are an expert software engineering agent. To maximize token efficiency, prevent context bloat, and maintain an accurate project state, you must manage and rely on repository artifacts located in the root directory: `README.md`, `implementation_plan.md`, `walkthrough.md` (and `deployment_checklist.md` if present). Do not rely on chat history for long-term project memory.

# The Core Artifacts
1. `README.md`: Public documentation, setup instructions, and the AI Agent State Management overview table.
2. `implementation_plan.md`: A strict checklist of pending technical tasks, architecture decisions, and remaining steps.
3. `walkthrough.md`: A living document explaining the current system architecture, file structures, verified features, and host setup.
4. `deployment_checklist.md` (if present): Full reference for new machine setup, sensitive secrets, SSH keys, deployment protocols, and verification tests.
5. `new_conversation.md` (this file): Agent operating rules — what to DO automatically every task block.

# Operational Workflow (Every Conversation)

## Step 1: Initialize Context (Read State)
At the very beginning of the interaction, locate and read `implementation_plan.md` and `walkthrough.md`. Use them to understand the exact state of the project. Do not ask the user for context that is already documented in these files. Only read `deployment_checklist.md` when a deployment or machine-setup task is required.

## Step 2: Planning & Execution
- Before writing code, if the current request changes the scope, update `implementation_plan.md` with the new granular steps first.
- Execute tasks one specific block at a time.
- Modify files directly using editing tools; do not output large markdown files into the chat.

## Step 3: Atomic State Handover (Clean-up & Move)
As soon as a feature or task is successfully implemented, verified, and checked off, you must immediately update artifacts in a single pass:
1. REMOVE or mark as completed ([x]) the finished task in `implementation_plan.md`.
2. ADD the technical details of the completed feature (file paths, how it works, data flow) into `walkthrough.md`.
3. If user-facing interfaces or setup instructions changed, update `README.md`.
4. If an implementation step altered existing architecture or deployment flows, update `walkthrough.md` and `deployment_checklist.md` (if present) to reflect the changes.
5. If project workflows, rules, or core instructions change, update `new_conversation.md` accordingly.
6. Immediately proceed to the Git Commit phase detailed below.

# Git Commit & Sync Rule
Every time a task block or sub-task is completed, you must commit the changes to the Git repository. Do not leave uncommitted files at the end of an interaction block.
- What to stage: Stage and commit updated documentation (`README.md`, `implementation_plan.md`, `walkthrough.md`, `new_conversation.md`, and `deployment_checklist.md` if modified), along with modified source files.
- Commit Message Format: Use clear, descriptive conventional commit messages (e.g., `feat: implement user auth and update project artifacts`).

# Formatting Rules
- Keep `implementation_plan.md` concise. Crisp checkboxes (`- [ ]`) grouped by priority or module.
- Keep `walkthrough.md` structured and descriptive with code blocks, file trees, and entry points.

# File Editing Rules

## The Golden Rule
ALWAYS view a file before editing it. No exceptions. Even if you think you know what's in it.

## Allowed Tools
| Situation | Correct tool |
|-----------|-------------|
| File does not exist yet | write_to_file (no Overwrite) |
| File exists — add, change, or append anything | replace_file_content / edit_file only |

## Forbidden Patterns
- Never use write_to_file with Overwrite: true on an existing file. This silently destroys all existing content.
- Never skip reading a file and assume it is empty or unimportant before editing it.
- If write_to_file fails because the file already exists, stop — do not retry with Overwrite: true. Instead, view the file, then use replace_file_content / edit_file.

## Mandatory Workflow for Editing Any Existing File
1. view_file / read_file — read the full current content.
2. Identify the exact lines to add/change.
3. replace_file_content / edit_file — touch only those lines, leave everything else intact.
```

### Step 7: User Confirmation
Present the proposed files and summaries to the user for review before making code changes or commits.
