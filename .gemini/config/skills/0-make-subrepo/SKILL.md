---
name: 0-make-subrepo
description: Integrates a repository or project as a formal private Git submodule under a main repository. Verifies subrepo parameters, presents an execution plan, and awaits user confirmation before executing. Trigger when the user requests submodule setup or runs /0-make-subrepo.
---

# Make Git Subrepo (Submodule Integration)

## Purpose
Executes formal Git submodule integration for private repositories, ensuring clean submodule registration (`.gitmodules`), commit tracking, two-way living memory decoupling and bootstrapping, and parent pointer bumps.

## Strict Safety Guardrails
1. **Parameter Requirement**: The user MUST specify:
   - The main repo path or context
   - The submodule name / target directory (`[subrepo_name]`)
   - The private subrepo repository URL (if cloning remote)
   If any parameter is missing, ASK before proceeding.
2. **Approval Gate**: Before running ANY `git submodule` or repo creation command, present the full step-by-step execution plan (submodule path, URL, branch, files to be created) and **WAIT for explicit user confirmation**.
3. **Mandatory Private Visibility**: All created or integrated subrepos MUST be set to **Private** by default (e.g. `gh repo create <name> --private` or GitHub API `"private": true`). Never create or expose a public repository unless the user explicitly and verbatim requests public.
4. **No Loose Directories**: Must use formal `git submodule add`, not loose copied folders or gitignored directories.

## Procedure

### Step 1: Pre-flight Verification & Parameter Check
1. Confirm that `[subrepo_name]` and repository URLs are provided. If missing, prompt the user.
2. Verify the parent repository is a valid Git workspace (`git status`).
3. Ensure the target subrepo on GitHub is confirmed private before adding.

### Step 2: Present Execution Plan & Await Approval
Present the complete plan to the user in chat:
- Main repository path
- Submodule name and target path (`<destination_path>`)
- Remote URL (highlighting **Private** visibility)
- Target commit / tracking branch
- Living memory bootstrapping plan for the child subrepo (`README.md`, `new_conversation.md`, `implementation_plan.md`, `walkthrough.md`, and `deployment_checklist.md`, `USER.md`, `ADMIN.md` if applicable)
- Parent decoupling plan (condensing parent MDs into pointer references)

**STOP and wait for user approval.** Do not execute Step 3 until the user confirms.

### Step 3: Execute Submodule Registration (After Approval)
1. Add the submodule at the specified destination path:
   ```bash
   git submodule add <subrepo_url> <destination_path>
   ```
2. Verify `.gitmodules` and initialize:
   ```bash
   git submodule update --init --recursive
   ```

### Step 4: Bootstrap Full Living Memory Inside Child Subrepo
Inside the child submodule root directory (`<destination_path>/`), bootstrap complete token-saving living memory (matching `/0-create-token-saving-mds`):
1. **`README.md`**:
   - Project overview, purpose, and tech stack.
   - Mention parent repository linkage (e.g. *"Maintained as a submodule under `<parent_repo_name>`"*).
   - Standard **AI Agent State Management Table**:
     ```markdown
     ## 🧠 AI Agent State Management

     This repository uses an AI-first living memory workflow. Every agent session bootstraps from these documents — no context is stored in chat history.

     | File | Role |
     |---|---|
     | [`new_conversation.md`](./new_conversation.md) | Agent *operating rules* — what to DO automatically every task block |
     | [`walkthrough.md`](./walkthrough.md) | Architecture memory — how the system works, active files, completed features |
     | [`implementation_plan.md`](./implementation_plan.md) | What's next / what's done — strict checklist of pending and completed tasks |
     | [`deployment_checklist.md`](./deployment_checklist.md) | *(If present)* Full reference — new machine setup, secrets, and deployment protocol |
     | [`USER.md`](./USER.md) | *(If present)* User-friendly non-technical guide for end-users / team members |
     | [`ADMIN.md`](./ADMIN.md) | *(If present)* Elevated operations guide for administrators & managers |

     > **For AI Agents:** Read these documents at the start of every session. Do not ask the user for context already documented there.
     ```
   - Cloning with submodules instruction (`git clone --recurse-submodules <parent_repo>`).
   - Upstream sync instructions (`git submodule update --remote <destination_path>`).
2. **`new_conversation.md`**: Create standard operating rules and agent workflow table.
3. **`implementation_plan.md`**: Create initial checklist of completed features and active tasks.
4. **`walkthrough.md`**: Document architecture, directory tree, entry points, and verified features.
5. **`deployment_checklist.md`** *(if applicable)*: If the subrepo involves standalone hosting, servers, containers, or secrets (`.env`), document deployment instructions.
6. **`USER.md` & `ADMIN.md`** *(if applicable)*:
   - If the subrepo has non-technical end-users or ministry workflows, create `USER.md`.
   - If the subrepo has admin permissions, roles, or quota management, create `ADMIN.md`.
   - *(Skip if not applicable to the subrepo).*

### Step 5: Decouple & Slim Parent Living Memory
In the parent repository (and grandparent/ancestors if applicable):
1. **Condense Submodule Details**: Replace verbose subrepo implementation details in the parent's `walkthrough.md`, `implementation_plan.md`, and `deployment_checklist.md` with concise pointer blocks linking to the child's living memory documents.
2. **Update Parent `README.md`**: Add or update a dedicated `## Submodules` section linking to `<destination_path>/README.md`.
3. **Update Parent `implementation_plan.md`**: Add a `Submodule Registry` table:
   ```markdown
   | Submodule | Path | Remote URL | Role & Living Memory |
   |---|---|---|---|
   | `<subrepo_name>` | `<destination_path>` | `<subrepo_url>` | [README](./<path>/README.md) • [Walkthrough](./<path>/walkthrough.md) |
   ```

### Step 6: Commit Child & Bump Parent Pointers
1. **Commit and Push Child Submodule**:
   ```bash
   cd <destination_path>
   git add README.md new_conversation.md implementation_plan.md walkthrough.md deployment_checklist.md
   git commit -m "docs: bootstrap token-saving living memory MDs for <subrepo_name>"
   git push origin main
   ```
2. **Commit and Push Parent Repository**:
   Stage `.gitmodules`, the updated submodule git pointer, and decoupled documentation:
   ```bash
   cd <parent_repo_path>
   git add .gitmodules <destination_path> implementation_plan.md walkthrough.md README.md deployment_checklist.md
   git commit -m "feat: register <subrepo_name> as private git submodule and decouple living memory"
   git push origin main
   ```
3. **Ancestor Propagation (if applicable)**:
   If the parent is itself a submodule under another ancestor repo (e.g. `subrepo` ➡️ `parent` ➡️ `grandparent`), navigate up to the grandparent, stage the updated parent pointer, and commit:
   ```bash
   git add <parent_path>
   git commit -m "chore: bump <parent_name> submodule pointer for <subrepo_name> integration"
   git push origin main
   ```
