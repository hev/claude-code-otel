# Dashboard Overhaul TODO

## Priority 0 (P0) - Core Features
- [x] Add Context Window gauge panel (0-100% with Smart/Dumb zone thresholds)
- [x] Add User Input counter panel (count user prompts)
- [x] Add Session links panel (clickable session IDs with filtered URLs)

## Priority 1 (P1) - Enhancements
- [x] Improve Cost/Model breakdown (pie chart by model)
- [x] Improve PRs/Commits panels (add stats panels)

## Priority 2 (P2) - Calculated Metrics
- [x] Add Session duration panel (calculated from event timestamps)

## Priority 3 (P3) - Blocked on Upstream
- [ ] Project filtering (blocked - needs working_directory attribute)
- [ ] Time per project (blocked - needs working_directory attribute)

---

## Current Status
Completed: Session Duration panel - added to Session Activity section:
- **Session Duration**: Shows duration calculated from first to last event timestamps
- Uses Loki queries to calculate min/max timestamps from API request events
- Displays duration in human-readable format (seconds/minutes/hours)
- Color thresholds: blue (0), green (5m), yellow (30m), orange (2h)
- Placed alongside User Inputs and API Requests panels
