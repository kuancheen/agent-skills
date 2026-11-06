---
name: 0-resume-session
description: Resumes work seamlessly after hitting a context limit or session boundary, gracefully handling projects where living memory MDs are still incomplete or under development. Trigger when the user states the token limit was hit or runs /0-resume-session.
---

# Resume Session After Token Limit

## Purpose
Allows an agent to pick up work immediately without loss of progress after a session is interrupted or hits a token limit, even if the project is still in early development and does not yet have all markdown artifacts.

## Procedure

### Step 1: Detect Available State Artifacts (Graceful Fallback)
Inspect the workspace root for living memory artifacts. **Do not fail if any are missing**:
- `implementation_plan.md`: Read if present to identify the active task checklist.
- `walkthrough.md`: Read if present to review system architecture and completed features.
- `README.md`: Read if present to understand overall project context.
- `deployment_checklist.md`: Read if present to review deployment steps or credentials.
- `new_conversation.md`: Read if present for operational rules.

*Note which files exist and which are still pending creation.*

### Step 2: Inspect Disk & Git Forensics (Ground Truth)
Whether MD files exist or not, examine the filesystem to reconstruct the exact state of progress:
1. `git status` — see what files were modified, staged, or untracked prior to the token limit.
2. `git diff` — inspect incomplete code edits, syntax breaks, or half-written functions left behind.
3. `git log -n 3` — check the most recent commit messages to understand the last completed milestone.
4. Recent test/build output (if available) — check if the last run produced errors.

### Step 3: Identify Interruption Point
Combine the forensic findings:
- **Mid-Code Interruption**: Did the agent stop in the middle of writing a specific file or function?
- **Mid-Bootstrap Interruption**: Was the agent in the middle of generating the living memory MD files themselves?
- **Test / Build Failure**: Did an error occur right before the context boundary?
- **Deployment Interruption**: Was the agent in the middle of an SCP, rsync, container restart, or remote build? Check remote status against `deployment_checklist.md` (if present).

### Step 4: Formulate and Execute Recovery
1. Present a concise status to the user:
   - "Detected interrupted work on: `<task_name or file>`"
   - "Artifacts present: `<list existing MDs, noting if project is still bootstrapping>`"
   - "Current git state: `<summary of modified/untracked files>`"
   - "Next step to resume: `<immediate action>`"
2. Fix any half-written files, dangling brackets, or syntax errors left by the cutoff.
3. Continue executing the task. If living memory MDs are missing, propose bootstrapping them once the immediate broken state is stabilized.
