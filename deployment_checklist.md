# Deployment Checklist

A pre-flight verification checklist before publishing updates or deploying skills to new environments.

---

## 1. Skill Frontmatter & Syntax Validation
- [x] All skills have valid YAML frontmatter delimiters (`---`).
- [x] Each skill contains a `name` matching `^[a-z0-9]+(-[a-z0-9]+)*$` (lowercase, alphanumeric, hyphens).
- [x] Each skill contains a descriptive `description` explaining **what** it does and **when** it triggers.
- [x] Directory names match the frontmatter `name` field exactly.

## 2. Privacy & Security Scans
- [x] No absolute personal paths (e.g., `/Users/<username>/...`).
- [x] No private repository URLs or company internal endpoints.
- [x] No API tokens, SSH keys, passwords, or secrets.
- [x] `.gitignore` verified to only whitelist `0-*` skill directories.

## 3. Deployment Steps to New Machines
- [ ] Clone repo to local environment: `git clone https://github.com/kuancheen/agent-skills.git ~/agent-skills`.
- [ ] Ensure destination directory exists: `mkdir -p ~/.gemini/config/skills`.
- [ ] Link skills: `ln -s ~/agent-skills/.gemini/config/skills/0-* ~/.gemini/config/skills/`.
- [ ] Open Antigravity and type `/0` in chat to verify all 5 skills appear in the dropdown.
