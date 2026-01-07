# Dashboard Overhaul TODO

## Priority 0 (P0) - Core Features
- [x] Add Context Window gauge panel (0-100% with Smart/Dumb zone thresholds)
- [x] Add User Input counter panel (count user prompts)
- [x] Add Session links panel (clickable session IDs with filtered URLs)

## Priority 1 (P1) - Enhancements
- [x] Improve Cost/Model breakdown (pie chart by model)
- [x] Improve PRs/Commits panels (add stats panels)

## Priority 2 (P2) - Calculated Metrics
- [ ] Add Session duration panel (calculated from event timestamps)

## Priority 3 (P3) - Blocked on Upstream
- [ ] Project filtering (blocked - needs working_directory attribute)
- [ ] Time per project (blocked - needs working_directory attribute)

---

## Current Status
Completed: PRs/Commits stat panels - added four new stat panels to User Activity & Productivity section:
- **Commits Created**: Shows total commits with color thresholds (blue->green->yellow->orange)
- **PRs Created**: Shows total pull requests with color thresholds
- **Lines Added**: Shows lines of code added (green color scheme)
- **Lines Removed**: Shows lines of code removed (red color scheme)

All panels use instant queries for total counts with appropriate color thresholds based on volume.
