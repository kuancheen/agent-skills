---
name: 0-resume-session
description: Resumes work seamlessly after hitting a context limit or session boundary. Trigger when the user states the token limit was hit or runs /0-resume-session.
---

# Resume Session After Token Limit

## Purpose
Allows an agent to pick up work immediately without loss of progress after a session is interrupted or hits a token limit.

## Procedure

### Step 1: Locate Current State Artifacts
Immediately read the project's living memory:
1. `implementation_plan.md` — locate the currently active / in-progress checklist items.
2. `walkthrough.md` — review the system architecture and already-verified features.

### Step 2: Inspect Disk & Git State
Do not rely on chat history. Run diagnostics on the file system:
1. `git status` — see what files were modified, staged, or untracked prior to the token limit.
2. `git diff` — inspect incomplete code edits or syntax breaks left behind.
3. `git log -1` — check the most recent commit to verify the last saved milestone.

### Step 3: Identify Interruption Point
Compare `implementation_plan.md` with the git status and source files:
- Did the previous session stop mid-edit?
- Did a build/test fail right before interruption?
- Is there a half-completed checklist item?

### Step 4: Formulate and Execute Recovery
1. Present a concise status to the user:
   - "Detected interrupted work on: `<task_name>`"
   - "Current git state: `<modified files>`"
   - "Next step to resume: `<immediate action>`"
2. Fix any half-written files or syntax errors.
3. Continue executing the pending task block according to the `new_conversation.md` workflow.
