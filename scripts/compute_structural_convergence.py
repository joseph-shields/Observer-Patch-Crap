#!/usr/bin/env python3
"""Recompute the frozen structural-convergence ledger.

The score is an auditor-coded alignment index, not a plagiarism probability or
causal estimator. By default this command verifies arithmetic and monotonicity
without modifying tracked artifacts. Pass ``--write-figures`` to regenerate
the published chart with deterministic metadata.
"""
from __future__ import annotations

import argparse
import json
import os
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROLES = {r["id"]: r for r in json.loads((ROOT / "data/role_definitions.json").read_text())}
SNAPSHOTS = json.loads((ROOT / "data/snapshots.json").read_text())
EDGES = json.loads((ROOT / "data/role_edges.json").read_text())


def score(snapshot: dict, threshold: float = 0.0) -> float:
    numerator = 0.0
    denominator = 0.0
    for role_id, metadata in ROLES.items():
        if metadata["probative_factor"] < threshold:
            continue
        weight = metadata["weight"] * metadata["probative_factor"]
        denominator += weight
        numerator += weight * snapshot["presence"].get(role_id, 0.0)
    if denominator <= 0:
        raise ValueError("role-score denominator is not positive")
    return numerator / denominator


def edge_score(snapshot: dict, threshold: float = 0.7) -> float:
    numerator = 0.0
    denominator = 0.0
    for edge in EDGES:
        source, target = edge["source"], edge["target"]
        probative = min(ROLES[source]["probative_factor"], ROLES[target]["probative_factor"])
        if probative < threshold:
            continue
        weight = edge["weight"] * probative
        denominator += weight
        numerator += weight * min(
            snapshot["presence"].get(source, 0.0),
            snapshot["presence"].get(target, 0.0),
        )
    if denominator <= 0:
        raise ValueError("edge-score denominator is not positive")
    return numerator / denominator


def recompute() -> list[dict]:
    rows = []
    for snapshot in SNAPSHOTS:
        rows.append(
            {
                "snapshot_id": snapshot["id"],
                "date": snapshot["date"],
                "label": snapshot["label"],
                "commit": snapshot["commit"],
                "all_role_alignment": round(score(snapshot), 6),
                "probative_role_alignment": round(score(snapshot, 0.7), 6),
                "controls_excluded_alignment": round(score(snapshot, 0.5), 6),
                "probative_edge_alignment": round(edge_score(snapshot), 6),
            }
        )
    return rows


def verify_monotonicity() -> None:
    for role_id in ROLES:
        values = [snapshot["presence"].get(role_id, 0.0) for snapshot in SNAPSHOTS]
        if any(values[index] > values[index + 1] for index in range(len(values) - 1)):
            raise SystemExit(f"non-monotone role coding: {role_id}: {values}")


def write_figures(rows: list[dict]) -> None:
    # SOURCE_DATE_EPOCH plus a fixed SVG salt make the output stable enough for
    # manifest-based repository verification.
    os.environ.setdefault("SOURCE_DATE_EPOCH", "1787702400")  # 2026-08-26 UTC
    import matplotlib

    matplotlib.use("Agg")
    matplotlib.rcParams["svg.hashsalt"] = "oph-structural-audit-v1"
    import matplotlib.pyplot as plt

    x_values = list(range(len(rows)))
    figure = plt.figure(figsize=(8.5, 4.6))
    axes = figure.add_subplot(1, 1, 1)
    axes.plot(
        x_values,
        [row["probative_role_alignment"] for row in rows],
        marker="o",
        label="Probative role alignment",
    )
    axes.plot(
        x_values,
        [row["probative_edge_alignment"] for row in rows],
        marker="s",
        label="Probative edge alignment",
    )
    axes.set_xticks(x_values, [row["snapshot_id"] for row in rows])
    axes.set_ylim(0, 1.05)
    axes.set_xlabel("Version-locked snapshot")
    axes.set_ylabel("Auditor-coded alignment")
    axes.legend()
    figure.tight_layout()

    figures = ROOT / "figures"
    figures.mkdir(exist_ok=True)
    fixed_date = "2026-08-26T00:00:00Z"
    figure.savefig(
        figures / "structural_alignment.svg",
        metadata={"Date": fixed_date, "Creator": "compute_structural_convergence.py"},
    )
    figure.savefig(
        figures / "structural_alignment.pdf",
        metadata={
            "Title": "OPH structural-alignment audit",
            "Author": "Anonymous technical audit",
            "Creator": "compute_structural_convergence.py",
            "Producer": "Matplotlib",
            "CreationDate": datetime(2026, 8, 26, tzinfo=timezone.utc),
            "ModDate": datetime(2026, 8, 26, tzinfo=timezone.utc),
        },
    )
    plt.close(figure)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--write-figures",
        action="store_true",
        help="regenerate the deterministic SVG/PDF structural-alignment chart",
    )
    arguments = parser.parse_args()

    rows = recompute()
    expected = json.loads((ROOT / "data/alignment_scores.json").read_text())
    if rows != expected:
        raise SystemExit("score drift: recomputed output differs from data/alignment_scores.json")

    verify_monotonicity()
    print("OK: structural alignment scores reproduce exactly")
    print("OK: every coded role is non-decreasing across the frozen snapshots")
    print("Therefore every positive weighted role score is non-decreasing; weights affect magnitude, not direction.")
    for row in rows:
        print(
            row["snapshot_id"],
            row["date"],
            row["probative_role_alignment"],
            row["probative_edge_alignment"],
        )

    if arguments.write_figures:
        write_figures(rows)
        print("OK: deterministic structural-alignment figures regenerated")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
