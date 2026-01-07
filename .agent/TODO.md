# Dashboard Overhaul TODO

## Priority 0 (P0) - Core Features
- [x] Add Context Window gauge panel (0-100% with Smart/Dumb zone thresholds)
- [x] Add User Input counter panel (count user prompts)
- [x] Add Session links panel (clickable session IDs with filtered URLs)

## Priority 1 (P1) - Enhancements
- [ ] Improve Cost/Model breakdown (pie chart by model)
- [ ] Improve PRs/Commits panels (add stats panels)

## Priority 2 (P2) - Calculated Metrics
- [ ] Add Session duration panel (calculated from event timestamps)

## Priority 3 (P3) - Blocked on Upstream
- [ ] Project filtering (blocked - needs working_directory attribute)
- [ ] Time per project (blocked - needs working_directory attribute)

---

## Current Status
Completed: Session Links panel - added table panel that:
- Lists all sessions with their total cost
- Clickable session IDs that filter the dashboard to that session
- Preserves time range when clicking links
- Shows last activity time for each session
- Sorted by most recent activity by default
