---
name: 0-update-all-mds
description: Synchronizes implementation_plan.md, walkthrough.md, README.md, and new_conversation.md with completed work, lessons learned, and next plans, then commits to Git. Trigger when user asks to update all mds, sync artifacts, or runs /0-update-all-mds.
---

# Update All Markdown Artifacts and Commit

## Purpose
Performs an atomic state handover at the conclusion of a work block. Updates the living memory documents with:
1. What was done
2. What was learned
3. What is planned next
Followed by a clean conventional Git commit.

## Strict File Editing Rules
- **View every file before editing.**
- **Never overwrite files wholesale.** Use targeted edits (`edit_file` / `replace_file_content`) to preserve all existing architectural notes, benchmark tables, and history.

## Procedure

### Step 1: Inspect Changes
- Run `git status` and `git diff` to review all modified, created, or deleted files in the current work session.

### Step 2: Update `implementation_plan.md`
- Mark finished items as completed (`- [x]`) or remove them if designated as a pure pending list.
- Add new subtasks or future considerations that emerged during implementation.

### Step 3: Update `walkthrough.md`
- Add new features to the verified features section with descriptions, paths, and usage examples.
- Update directory structure and architecture diagrams if files were added or modified.
- Append new discoveries, troubleshooting steps, and lessons learned under "Things Learned".

### Step 4: Update `README.md` (if applicable)
- If user-facing interfaces, installation steps, or API contracts changed, update the project `README.md`.

### Step 5: Update `new_conversation.md` (if needed)
- If any operational rule, agent workflow, tool guideline, or project-specific constraint was modified or learned, update `new_conversation.md`.

### Step 6: Git Stage and Commit
1. Check `git status` to ensure all relevant files (code, tests, artifacts) are identified.
2. Stage the modified files and documentation:
   ```bash
   git add implementation_plan.md walkthrough.md new_conversation.md README.md <modified_source_files>
   ```
3. Commit using a conventional commit message:
   ```bash
   git commit -m "<type>: <concise description of work completed and artifact sync>"
   ```
4. Confirm commit status to the user.
