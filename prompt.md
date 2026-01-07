# Dashboard Overhaul Plan

## Goals (User Outcomes)
1. **Context Window Visibility** - See context usage as % with zones: Smart (30-60%), Dumb (>80%)
2. **Per-Session Links** - Shareable URLs to view/track specific sessions
3. **Cost & Model Usage** - Clear breakdown of cost by model
4. **PRs and Commits** - Track development output
5. **User Input Count** - Distinguish human prompts vs autonomous running
6. **Project Filtering** - Toggle between projects in dashboard
7. **Time Spent per Project** - Track duration of work on each project

---

## Gap Analysis: What's Missing

### Currently Available (from Claude Code telemetry)
- `session.id` - unique session identifier
- `claude_code.token.usage` with type (input, output, cacheRead, cacheCreation)
- `claude_code.cost.usage` with model attribute
- `claude_code.commit.count` and `claude_code.pull_request.count`
- `claude_code.user_prompt` events
- `claude_code.api_request` events with input/output token counts

### NOT Currently Available (requires telemetry changes)
- **Project/working directory** - Not emitted by Claude Code
- **Context window maximum** - Model-specific (200k for Sonnet/Opus, 200k for Haiku 3.5)
- **Cumulative context per turn** - Individual token counts exist but not running total

---

## Implementation Plan

### Phase 1: Data Collection Changes

#### 1.1 Add Project Tracking (requires upstream change or workaround)
**Option A: Request upstream change** - Add `working_directory` or `project` attribute to all metrics/events

**Option B: Derive from session** - Use session correlation with local tracking (not recommended - fragile)

**Recommendation**: File issue/PR on Claude Code to add `working_directory` attribute to telemetry. Without this, project filtering is not possible.

#### 1.2 Session Start/End Events
Currently `claude_code.session.count` only fires at start. Need session end or duration for time tracking.
- Calculate duration from first event to last event per session (workaround)
- Or request `claude_code.session.end` event upstream

### Phase 2: Dashboard Restructure

#### 2.1 New Layout Structure
```
Row 0: Variables & Links
├── session_id dropdown (existing)
├── project dropdown (NEW - requires 1.1)
└── time range picker

Row 1: Context Window Health (NEW SECTION)
├── Context Usage Gauge (0-100%)
│   - Green zone: 0-30%
│   - Yellow zone: 30-60% (Smart Zone)
│   - Red zone: 80%+ (Dumb Zone)
├── Context Breakdown Bar Chart
│   - Input tokens
│   - Cache read tokens
│   - Cache creation tokens
└── Context Usage Over Time

Row 2: Session Overview
├── Session Link Panel (NEW)
│   - Clickable session ID -> filtered dashboard URL
├── User Inputs Count (NEW)
├── Autonomous Turns Count (NEW)
└── Session Duration

Row 3: Cost & Model
├── Total Cost (stat)
├── Cost by Model (pie chart)
├── Model Usage Over Time (timeseries)
└── Cost per Session Table

Row 4: Development Output
├── Commits Created (stat)
├── PRs Created (stat)
├── Lines Added/Removed
└── Development Activity Timeline

Row 5: Project Analytics (requires 1.1)
├── Time by Project (bar chart)
├── Cost by Project (pie chart)
├── Sessions per Project
└── Project Activity Heatmap

Row 6: Performance & Tools (keep existing, condensed)
├── Tool Usage Rate
├── Tool Success Rate
├── API Latency
└── Error Rate

Row 7: Logs (keep existing)
```

### Phase 3: Specific Panel Implementations

#### 3.1 Context Window Gauge
```promql
# Calculate context % (approximate - assumes 200k max)
# Sum of input + cacheRead tokens as % of 200,000
100 * (
  sum(claude_code_token_usage_tokens_total{type="input"}) +
  sum(claude_code_token_usage_tokens_total{type="cacheRead"})
) / 200000
```

**Thresholds:**
- Green: 0-30%
- Yellow: 30-60% (Smart Zone label)
- Orange: 60-80%
- Red: 80%+ (Dumb Zone label)

#### 3.2 User Input Counter
```logql
# Count user_prompt events per session
sum(count_over_time({service_name="claude-code", session_id=~"$session_id"}
  |= "claude_code.user_prompt" [$__range]))
```

#### 3.3 Autonomous Turns
```logql
# API requests minus user prompts = autonomous turns
(api_request_count) - (user_prompt_count)
```

#### 3.4 Session Links Panel
- Use Grafana table panel with session_id as link
- Link format: `/d/claude-code-obs?var-session_id={session_id}`
- Show: session_id, start_time, duration, cost, commits

#### 3.5 Session Duration
```promql
# Duration from first to last event
max_over_time(timestamp{session_id="X"}[$__range]) -
min_over_time(timestamp{session_id="X"}[$__range])
```

### Phase 4: Variable Configuration

#### 4.1 Enhance session_id variable
- Make it clickable/linkable
- Add to URL for sharing
- Sort by most recent

#### 4.2 Add project variable (blocked on 1.1)
```
label_values(claude_code_session_count_total, working_directory)
```

### Phase 5: Dashboard Polish

#### 5.1 Add Zone Labels
- Add annotations or text panels explaining Smart/Dumb zones
- Color code consistently across panels

#### 5.2 Session Summary Row
- Single-session view when session_id is selected
- Aggregate view when "All" is selected

---

## Blockers & Dependencies

| Item | Blocker | Mitigation |
|------|---------|------------|
| Project filtering | No `working_directory` in telemetry | Request upstream change or use session labels |
| Exact context window % | Model max varies, not exposed | Hardcode 200k or add model-based calculation |
| Session duration | No end event | Calculate from event timestamps |
| Autonomous vs user turns | Need to correlate events | Use Loki for event correlation |

---

## Open Questions

1. **Context calculation**: Should we track per-turn context or cumulative? (Per-turn is what `/context` shows)
2. **Project definition**: Working directory? Git remote? User-provided label?
3. **Multi-session views**: How to aggregate context % across sessions?
4. **Historical data**: Will changes work with existing data?

---

## Files to Modify

| File | Changes |
|------|---------|
| `claude-code-dashboard.json` | Complete restructure per Phase 2 |
| `collector-config.yaml` | Add any needed transformations |
| (upstream) Claude Code | Add `working_directory` attribute |

---

## Priority Order

1. **P0**: Context Window gauge (core ask, works with current data)
2. **P0**: User Input counter (works with current data)
3. **P0**: Session links (works with current data)
4. **P1**: Cost/Model improvements (enhancement to existing)
5. **P1**: PRs/Commits improvements (enhancement to existing)
6. **P2**: Session duration (calculated metric)
7. **P3**: Project filtering (blocked on upstream)
8. **P3**: Time per project (blocked on upstream)
