---
name: 0-start-new-conversation
description: Bootstraps a fresh conversation session using new_conversation.md, implementation_plan.md, and walkthrough.md. Trigger when starting a new conversation or when the user runs /0-start-new-conversation.
---

# Start New Conversation

## Purpose
Enables immediate resumption of project development in a fresh conversation window without context bloat, without relying on conversational history, and without asking redundant questions already documented in the repository.

## Procedure

### Step 1: Read Project Artifacts
At the start of the session, immediately read:
1. `new_conversation.md` (root directory) — load operational rules and guidelines.
2. `implementation_plan.md` (root directory) — inspect pending checklist items and immediate next tasks.
3. `walkthrough.md` (root directory) — inspect current architecture, active files, verified components, and setup.

### Step 2: Assess Current State
- Identify the highest-priority unchecked task (`- [ ]`) in `implementation_plan.md`.
- Cross-reference with the codebase to verify recent Git commits or uncommitted working files.

### Step 3: Brief Status Acknowledgment
Provide a concise 3-part summary to the user:
1. **Current State**: Where the project stands according to `walkthrough.md`.
2. **Next Immediate Task**: The next specific item from `implementation_plan.md`.
3. **Action Ready**: Ask the user if they want to proceed with that task or pivot to a different priority.

Do NOT re-explain the entire repository architecture or re-paste the documentation unless requested.
