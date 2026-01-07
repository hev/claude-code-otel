# Dashboard Overhaul TODO

## Priority 0 (P0) - Core Features
- [x] Add Context Window gauge panel (0-100% with Smart/Dumb zone thresholds)
- [x] Add User Input counter panel (count user prompts)
- [x] Add Session links panel (clickable session IDs with filtered URLs)

## Priority 1 (P1) - Enhancements
- [x] Improve Cost/Model breakdown (pie chart by model)
- [ ] Improve PRs/Commits panels (add stats panels)

## Priority 2 (P2) - Calculated Metrics
- [ ] Add Session duration panel (calculated from event timestamps)

## Priority 3 (P3) - Blocked on Upstream
- [ ] Project filtering (blocked - needs working_directory attribute)
- [ ] Time per project (blocked - needs working_directory attribute)

---

## Current Status
Completed: Cost by Model pie chart - added donut chart panel that:
- Shows total cost breakdown by model
- Uses distinct colors for Opus (red), Sonnet (purple), and Haiku (blue)
- Displays both value and percentage in legend
- Placed in Cost & Usage Analysis section alongside the existing time series
