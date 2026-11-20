#!/usr/bin/env bash
#
# install.sh - Installs or uninstalls Antigravity 0-* agent skills.
# Supports symlinking (default), copying (--copy), dry run (--dry-run), and uninstallation (--uninstall).
#

set -euo pipefail

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Determine repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_SKILLS_DIR="${SCRIPT_DIR}/.gemini/config/skills"
TARGET_DIR="${GEMINI_CONFIG_DIR:-$HOME/.gemini/config}/skills"

# Options
MODE="symlink"     # symlink, copy, or uninstall
DRY_RUN=false
FORCE=false

print_usage() {
  cat <<EOF
Usage: ./install.sh [OPTIONS]

Options:
  -s, --symlink      Install skills as symbolic links (default). Updates in repo reflect immediately.
  -c, --copy         Install skills by copying files instead of symlinking.
  -u, --uninstall    Remove installed 0-* skill symlinks or directories from target.
  -d, --dry-run      Preview actions without modifying the filesystem.
  -f, --force        Overwrite existing targets without creating timestamped backups.
  -t, --target DIR   Custom skills target directory (default: ~/.gemini/config/skills).
  -h, --help         Show this help message.

Examples:
  ./install.sh                # Symlink 0-* skills to ~/.gemini/config/skills
  ./install.sh --dry-run      # Preview installation
  ./install.sh --uninstall    # Remove 0-* skills from ~/.gemini/config/skills
EOF
}

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--symlink)
      MODE="symlink"
      shift
      ;;
    -c|--copy)
      MODE="copy"
      shift
      ;;
    -u|--uninstall)
      MODE="uninstall"
      shift
      ;;
    -d|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -f|--force)
      FORCE=true
      shift
      ;;
    -t|--target)
      TARGET_DIR="$2"
      shift 2
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      echo -e "${RED}Error: Unknown argument '$1'${NC}" >&2
      print_usage
      exit 1
      ;;
  esac
done

if [[ ! -d "$REPO_SKILLS_DIR" ]]; then
  echo -e "${RED}Error: Skills source directory not found at: ${REPO_SKILLS_DIR}${NC}" >&2
  exit 1
fi

echo -e "${BLUE}=== Antigravity Skills Manager ===${NC}"
echo -e "Source: ${REPO_SKILLS_DIR}"
echo -e "Target: ${TARGET_DIR}"
echo -e "Mode:   ${MODE}"
if [[ "$DRY_RUN" == true ]]; then
  echo -e "${YELLOW}[DRY RUN MODE - No changes will be written]${NC}"
fi
echo ""

# Handle Uninstall
if [[ "$MODE" == "uninstall" ]]; then
  echo -e "${YELLOW}Uninstalling 0-* skills from ${TARGET_DIR}...${NC}"
  for skill_path in "${REPO_SKILLS_DIR}"/0-*; do
    if [[ ! -d "$skill_path" ]]; then
      continue
    fi
    skill_name="$(basename "$skill_path")"
    dest="${TARGET_DIR}/${skill_name}"

    if [[ -L "$dest" ]]; then
      echo -e "  Removing symlink: ${dest}"
      if [[ "$DRY_RUN" == false ]]; then
        rm "$dest"
      fi
    elif [[ -d "$dest" ]]; then
      echo -e "  Removing directory: ${dest}"
      if [[ "$DRY_RUN" == false ]]; then
        rm -rf "$dest"
      fi
    else
      echo -e "  Not installed: ${dest}"
    fi
  done
  echo -e "${GREEN}Uninstall complete!${NC}"
  exit 0
fi

# Ensure target directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
  echo -e "Creating target directory: ${TARGET_DIR}"
  if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$TARGET_DIR"
  fi
fi

# Install skills
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
installed_count=0

for skill_path in "${REPO_SKILLS_DIR}"/0-*; do
  if [[ ! -d "$skill_path" ]]; then
    continue
  fi

  skill_name="$(basename "$skill_path")"
  dest="${TARGET_DIR}/${skill_name}"

  echo -e "Processing ${BLUE}${skill_name}${NC}:"

  # Check if destination exists
  if [[ -L "$dest" ]]; then
    current_target="$(readlink "$dest" || true)"
    if [[ "$current_target" == "$skill_path" && "$MODE" == "symlink" ]]; then
      echo -e "  ${GREEN}Already correctly symlinked.${NC}"
      ((installed_count++))
      continue
    else
      echo -e "  Replacing existing symlink (was pointing to: ${current_target})"
      if [[ "$DRY_RUN" == false ]]; then
        rm "$dest"
      fi
    fi
  elif [[ -d "$dest" ]]; then
    if [[ "$FORCE" == false ]]; then
      backup_dest="${dest}.bak.${TIMESTAMP}"
      echo -e "  ${YELLOW}Existing real directory detected! Backing up to:${NC} ${backup_dest}"
      if [[ "$DRY_RUN" == false ]]; then
        mv "$dest" "$backup_dest"
      fi
    else
      echo -e "  ${YELLOW}Overwriting existing directory (--force)...${NC}"
      if [[ "$DRY_RUN" == false ]]; then
        rm -rf "$dest"
      fi
    fi
  fi

  # Perform installation action
  if [[ "$MODE" == "symlink" ]]; then
    echo -e "  Linking: ${dest} -> ${skill_path}"
    if [[ "$DRY_RUN" == false ]]; then
      ln -sfn "$skill_path" "$dest"
    fi
  elif [[ "$MODE" == "copy" ]]; then
    echo -e "  Copying: ${skill_path} -> ${dest}"
    if [[ "$DRY_RUN" == false ]]; then
      cp -r "$skill_path" "$dest"
    fi
  fi

  ((installed_count++))
done

echo ""
echo -e "${GREEN}Successfully processed ${installed_count} skills!${NC}"
