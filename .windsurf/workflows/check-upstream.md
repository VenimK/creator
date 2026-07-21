---
description: Check upstream bryangerlach/rdgen repo for latest commits and compare with fork
---

# Check Upstream Repo for Updates

This workflow checks the upstream RustDesk client generator repo for new commits and compares them with the current fork to identify safe updates.

## Steps

1. Fetch the upstream repo's commit history:
   - URL: https://github.com/bryangerlach/rdgen/commits/master/
   - Use `read_url_content` to fetch the commits page
   - Use `view_content_chunk` to read each section of commits

2. Fetch latest from git remote:
   ```bash
   git fetch upstream
   ```

3. Compare divergence:
   ```bash
   # Count commits behind/ahead
   git rev-list --count HEAD..upstream/master
   git rev-list --count upstream/master..HEAD

   # Find divergence point
   git merge-base HEAD upstream/master

   # Files changed in both forks (conflict risk)
   comm -12 \
     <(git diff --name-only <merge-base> HEAD | sort) \
     <(git diff --name-only <merge-base> upstream/master | sort)
   ```

4. Review key upstream diffs for:
   - `rdgenerator/views.py` — core logic changes
   - `rdgenerator/forms.py` — new form fields/versions
   - `rdgen/settings.py` — new settings
   - `.github/workflows/generator-*.yml` — workflow changes
   - New files added by upstream

5. Categorize changes:
   - **Safe to apply**: New files, new form fields, new settings, non-conflicting additions
   - **Conflict risk**: Files both forks modified (workflows, views.py)
   - **Breaking changes**: Removed features, changed function signatures

6. Apply safe updates selectively using `edit`/`multi_edit` tools rather than git merge

## Key Upstream Features to Watch For
- New RustDesk versions (1.4.x)
- Windows x86 (32-bit) support
- Custom Android App ID
- Company name field
- Privacy screen support
- Printer/camera/terminal permissions
- Icon validation (square PNG)
- Docker support
- Gunicorn for production
- GitHub run ID tracking
- Failure/maintenance templates
- allowCustom.py script for custom.txt injection
- Cycle monitor removal (now in official RustDesk)
- Security fixes (CSRF, ALLOWED_HOSTS, etc.)
