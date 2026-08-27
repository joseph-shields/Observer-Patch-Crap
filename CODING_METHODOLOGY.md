# Coding methodology

1. Freeze a dated prior role graph before comparing later OPH snapshots.
2. Code functions, not words: e.g. `dynamics before action`, `realization gate`, `record closure`.
3. Preserve known contrary evidence as controls.
4. Use 0-1 visibility values to express absent, partial or explicit role presence.
5. Publish every role weight, probative factor, snapshot value and evidence group.
6. Compute role and directed-edge coverage mechanically.
7. State that the output is an auditor-coded alignment index, not a plagiarism probability.
8. Permit public corrections at the cell level.

`data/coding_evidence.csv` links each snapshot to its principal immutable public evidence group. `data/commit_evidence.csv` and `evidence/public_commits/` provide the commit-level trail.
