---
name: 0-update-all-mds
description: Synchronizes implementation_plan.md, walkthrough.md, README.md, new_conversation.md, and deployment_checklist.md (if present) with completed work, lessons learned, and next plans, bootstrapping any missing artifacts if absent, then commits to Git. Trigger when user asks to update all mds, sync artifacts, or runs /0-update-all-mds.
---

# Update All Markdown Artifacts and Commit

## Purpose
Performs an atomic state handover at the conclusion of a work block. Ensures all core living memory documents exist, updates them with what was done, what was learned, and what is planned next, and executes a clean conventional Git commit.

## Strict File Editing Rules
- **View every file before editing.**
- **Never overwrite files wholesale.** Use targeted edits (`edit_file` / `replace_file_content`) to preserve all existing architectural notes, benchmark tables, and history.

## Procedure

### Step 1: Missing Artifact Auto-Bootstrap (Fallback Check)
Before updating, verify that the core living memory files exist in the project root:
1. **`README.md`**:
   - If missing: Create it with the project title, overview, quickstart, and the **AI Agent State Management Table**.
   - If present: Inspect content. If the **AI Agent State Management Table** is missing, insert it cleanly below the header.
2. **`new_conversation.md`**:
   - If missing: Create it from the standard operating rules template.
3. **`implementation_plan.md`**:
   - If missing: Create it with current and pending task checklists.
4. **`walkthrough.md`**:
   - If missing: Create it with the system architecture and completed feature descriptions.
5. **`deployment_checklist.md`**:
   - If missing AND the current task or repository involves hosting/deployment (servers, Docker, PM2, Cloudflare, `.env`), propose or create it.

*(If multiple core artifacts were missing, this auto-bootstraps the project into the living memory workflow as per `0-create-token-saving-mds` without requiring a separate command).*

### Step 2: Inspect Working Changes
- Run `git status` and `git diff` to review all modified, created, or deleted files in the current work session.

### Step 3: Update `implementation_plan.md`
- Mark finished items as completed (`- [x]`) or remove them if designated as a pure pending list.
- Add new subtasks or future considerations that emerged during implementation.

### Step 4: Update `walkthrough.md`
- Add new features to the verified features section with descriptions, paths, and usage examples.
- Update directory structure and architecture diagrams if files were added or modified.
- Append new discoveries, troubleshooting steps, and lessons learned under "Things Learned".

### Step 5: Update `deployment_checklist.md` (If Applicable)
- If `deployment_checklist.md` exists:
  - Update any modified deployment steps, new destination paths, altered environment variables, or new verification curl/log commands.

### Step 6: Update `README.md`
- If user-facing interfaces, installation steps, API contracts, or core dependencies changed, update `README.md`.
- Ensure the **AI Agent State Management Table** remains present and accurately links to all existing root markdown files.

### Step 7: Update `new_conversation.md` (If Needed)
- If any operational rule, agent workflow, tool guideline, or project-specific constraint was modified or learned, update `new_conversation.md`.

### Step 8: Git Stage and Commit
1. Check `git status` to ensure all relevant files (code, tests, artifacts) are identified.
2. Stage the modified files and documentation:
   ```bash
   git add README.md implementation_plan.md walkthrough.md new_conversation.md <modified_source_files>
   # If deployment_checklist.md exists or was created:
   git add deployment_checklist.md
   ```
3. Commit using a conventional commit message:
   ```bash
   git commit -m "<type>: <concise description of work completed and artifact sync>"
   ```
4. Confirm commit status to the user.
