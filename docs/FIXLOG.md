# Fix log

## Settings snapshots captured a menu bar icon

Symptom: Settings PNGs measured 32 × 32 instead of showing the Settings form.
Cause: the snapshot helper selected any visible non-main window. MenuBarExtra
adds a small window that also matched that predicate.
Fix: select the observed SwiftUI Settings window identifier and allow activation
to settle before capturing. Missing Settings windows are explicitly reported.
Rule: capture an identified app surface, never the first unrelated visible window.

## Search could leave a hidden window selected

Symptom: filtering the overview could leave an arrangement action aimed at a
window outside the results.
Cause: selection was independent of the search query.
Fix: move selection to the first matching window when the query changes.
Rule: the overview's selected window must be visible in its search results.
