---
name: 0-make-subrepo
description: Integrates a repository or project as a formal private Git submodule under a main repository. Verifies subrepo parameters, presents an execution plan, and awaits user confirmation before executing. Trigger when the user requests submodule setup or runs /0-make-subrepo.
---

# Make Git Subrepo (Submodule Integration)

## Purpose
Executes formal Git submodule integration for private repositories, ensuring clean submodule registration (`.gitmodules`), commit tracking, documentation, and living memory updates.

## Strict Safety Guardrails
1. **Parameter Requirement**: The user MUST specify both:
   - The main repo path or context
   - The submodule name / target directory (`[subrepo_name]`)
   - The private subrepo repository URL (if cloning remote)
   If any parameter is missing, ASK before proceeding.
2. **Approval Gate**: Before running ANY `git submodule` command, present the full step-by-step execution plan (submodule path, URL, branch, files to be created) and **WAIT for explicit user confirmation**.
3. **No Loose Directories**: Must use formal `git submodule add`, not loose copied folders or gitignored directories.

## Procedure

### Step 1: Pre-flight Verification & Parameter Check
1. Confirm that `[subrepo_name]` and repository URLs are provided. If missing, prompt the user.
2. Verify the parent repository is a valid Git workspace (`git status`).

### Step 2: Present Execution Plan & Await Approval
Present the complete plan to the user in chat:
- Main repository path
- Submodule name and target path (`<destination_path>`)
- Remote URL
- Target commit / tracking branch
- Planned documentation files (`<destination_path>/README.md`)
- Living memory updates (`implementation_plan.md`, `walkthrough.md`, and `deployment_checklist.md` if subrepo affects deployment)

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

### Step 4: Create Submodule `README.md`
Inside the submodule root directory (e.g., `<destination_path>/README.md`), create or update documentation detailing:
- Purpose of the subrepo.
- How to clone parent with submodules: `git clone --recurse-submodules <parent_repo>`.
- How to pull upstream submodule changes: `git submodule update --remote <destination_path>`.
- Local development workflow and branch checkout guidelines.

### Step 5: Update Living Memory Artifacts
- **`implementation_plan.md`**: Check off the submodule integration milestone.
- **`walkthrough.md`**: Document the submodule architecture, folder structure, repository URL, and clone instructions.
- **`deployment_checklist.md` (if present)**: If the submodule alters deployment paths (e.g. nested assets, build artifacts), document them in the deployment checklist.
- **`new_conversation.md`**: Add any submodule maintenance rules if agents need to operate inside the submodule.

### Step 6: Commit Submodule Registration
Stage and commit `.gitmodules`, the registered submodule directory reference, and the updated documentation:
```bash
git add .gitmodules <destination_path> implementation_plan.md walkthrough.md README.md
git commit -m "feat: register <subrepo_name> as private git submodule and update artifacts"
```
