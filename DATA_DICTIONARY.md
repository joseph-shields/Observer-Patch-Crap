# Data dictionary

- `role_definitions.*`: functional roles, weights, probative factors and reasons.
- `role_edges.json`: directed dependency edges in the prior role graph.
- `snapshots.json`: version-locked OPH snapshots and auditor-coded role presence.
- `snapshot_role_presence.csv`: flat copy of the coding matrix.
- `commit_evidence.*`: immutable public commit events and role mappings.
- `prior_sources.*`: anonymized prior artifact hashes and functional roles.
- `coding_evidence.csv`: snapshot-to-evidence-group mapping.
- `alignment_scores.*`: mechanically reproduced weighted scores.
- `sensitivity_counts.*`: unweighted threshold counts for high-probative roles/edges.

All JSON is UTF-8, stable-key human-readable data. SHA-256 custody is recorded in `MANIFEST.sha256` after the final build.
