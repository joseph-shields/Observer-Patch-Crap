import Init

/-!
PhysicalNonDefinability.lean

Abstract Lean 4 kernel for the no-escape theorem suite accompanying:
"The Mr Tickle Screen: a reductio ad absurdum against physical closure from bare observer screens".

The file deliberately uses only elementary logical structure.  It does not
import OPH modules and does not assert that any particular OPH structure
exists.  Instead it proves the universal metatheorems used in the paper:
same source reduct + different physical readout defeats source determination.
-/

universe uSrc uPhys uObs uVal uCost uFeature

namespace PhysicalNonDefinability

/-- Two physical models are observationally equivalent when every admitted
readout returns the same value. -/
def ObsEq {Phys : Type uPhys} {Obs : Type uObs} {Val : Type uVal}
    (readout : Obs → Phys → Val) (p q : Phys) : Prop :=
  ∀ o, readout o p = readout o q

/-- A source reduct determines physical models up to the supplied equivalence. -/
def SourceDetermines {Src : Type uSrc} {Phys : Type uPhys}
    (red : Phys → Src) (eqv : Phys → Phys → Prop) : Prop :=
  ∀ p q, red p = red q → eqv p q

/-- A realization relation has a unique physical fibre up to equivalence. -/
def UniqueFibre {Src : Type uSrc} {Phys : Type uPhys}
    (realizes : Src → Phys → Prop) (eqv : Phys → Phys → Prop) : Prop :=
  ∀ s p q, realizes s p → realizes s q → eqv p q

/-- A physical-valued function factors through the source reduct. -/
def FactorsThrough {Src : Type uSrc} {Phys : Type uPhys} {A : Type _}
    (red : Phys → Src) (f : Phys → A) : Prop :=
  ∃ f0 : Src → A, ∀ p, f p = f0 (red p)

/-- A predicate factors through the source reduct. -/
def PredicateFactorsThrough {Src : Type uSrc} {Phys : Type uPhys}
    (red : Phys → Src) (K : Phys → Prop) : Prop :=
  ∃ K0 : Src → Prop, ∀ p, K p ↔ K0 (red p)

/-- A minimizer of an objective over an admissible physical class. -/
def Minimizer {Phys : Type uPhys} {Cost : Type uCost} [Preorder Cost]
    (admissible : Phys → Prop) (objective : Phys → Cost) (p : Phys) : Prop :=
  admissible p ∧ ∀ q, admissible q → objective p ≤ objective q

/-- T1: source-language predicates cannot distinguish equal reducts. -/
theorem source_predicate_indiscernibility
    {Src : Type uSrc} {Phys : Type uPhys}
    (red : Phys → Src) (P : Src → Prop) {p q : Phys}
    (hred : red p = red q) :
    P (red p) ↔ P (red q) := by
  constructor
  · intro hp
    rw [hred] at hp
    exact hp
  · intro hq
    rw [← hred] at hq
    exact hq

/-- T2: one same-reduct inequivalent pair refutes source determination. -/
theorem witness_refutes_source_determination
    {Src : Type uSrc} {Phys : Type uPhys}
    (red : Phys → Src) (eqv : Phys → Phys → Prop)
    {p q : Phys} (hred : red p = red q) (hneqv : ¬ eqv p q) :
    ¬ SourceDetermines red eqv := by
  intro hdet
  exact hneqv (hdet p q hred)

/-- T3: two inequivalent realizations of one source refute unique recovery. -/
theorem two_realizations_refute_unique_fibre
    {Src : Type uSrc} {Phys : Type uPhys}
    (realizes : Src → Phys → Prop) (eqv : Phys → Phys → Prop)
    {s : Src} {p q : Phys}
    (hp : realizes s p) (hq : realizes s q) (hneqv : ¬ eqv p q) :
    ¬ UniqueFibre realizes eqv := by
  intro huniq
  exact hneqv (huniq s p q hp hq)

/-- T4: an admitted observable difference defeats observational equivalence. -/
theorem observable_witness_refutes_obsEq
    {Phys : Type uPhys} {Obs : Type uObs} {Val : Type uVal}
    (readout : Obs → Phys → Val) {p q : Phys} {o : Obs}
    (hsep : readout o p ≠ readout o q) :
    ¬ ObsEq readout p q := by
  intro h
  exact hsep (h o)

/-- T5: gauge equivalence cannot relate models separated by a gauge-invariant readout. -/
theorem observable_separation_blocks_gauge_escape
    {Phys : Type uPhys} {Obs : Type uObs} {Val : Type uVal}
    (readout : Obs → Phys → Val) (gaugeEq : Phys → Phys → Prop)
    (gauge_preserves : ∀ {p q}, gaugeEq p q → ObsEq readout p q)
    {p q : Phys} (hsep : ¬ ObsEq readout p q) :
    ¬ gaugeEq p q := by
  intro hg
  exact hsep (gauge_preserves hg)

/-- T6: a source-factorized quantity is equal on equal reducts. -/
theorem factorized_quantity_equal_on_same_reduct
    {Src : Type uSrc} {Phys : Type uPhys} {A : Type _}
    (red : Phys → Src) (f : Phys → A)
    (hfactor : FactorsThrough red f)
    {p q : Phys} (hred : red p = red q) :
    f p = f q := by
  cases hfactor with
  | intro f0 hf0 =>
      calc
        f p = f0 (red p) := hf0 p
        _ = f0 (red q) := congrArg f0 hred
        _ = f q := (hf0 q).symm

/-- T7: a source-factorized admissibility predicate is equal on equal reducts. -/
theorem factorized_predicate_equal_on_same_reduct
    {Src : Type uSrc} {Phys : Type uPhys}
    (red : Phys → Src) (K : Phys → Prop)
    (hfactor : PredicateFactorsThrough red K)
    {p q : Phys} (hred : red p = red q) :
    K p ↔ K q := by
  cases hfactor with
  | intro K0 hK0 =>
      constructor
      · intro hp
        have hp0 : K0 (red p) := (hK0 p).mp hp
        have hq0 : K0 (red q) := by
          rw [← hred]
          exact hp0
        exact (hK0 q).mpr hq0
      · intro hq
        have hq0 : K0 (red q) := (hK0 q).mp hq
        have hp0 : K0 (red p) := by
          rw [hred]
          exact hq0
        exact (hK0 p).mpr hp0

/-- T8: an information criterion and feasible set that both factor through
source data cannot select uniquely between distinct same-reduct lifts. -/
theorem source_blind_optimization_cannot_select_unique_lift
    {Src : Type uSrc} {Phys : Type uPhys} {Cost : Type uCost}
    [Preorder Cost]
    (red : Phys → Src) (admissible : Phys → Prop) (objective : Phys → Cost)
    (hK : PredicateFactorsThrough red admissible)
    (hJ : FactorsThrough red objective)
    {p q : Phys} (hred : red p = red q)
    (hp : Minimizer admissible objective p) (hpq : p ≠ q) :
    ¬ (∀ r, Minimizer admissible objective r → r = p) := by
  have hKpq : admissible p ↔ admissible q :=
    factorized_predicate_equal_on_same_reduct red admissible hK hred
  have hJpq : objective p = objective q :=
    factorized_quantity_equal_on_same_reduct red objective hJ hred
  have hq : Minimizer admissible objective q := by
    constructor
    · exact hKpq.mp hp.1
    · intro r hr
      calc
        objective q = objective p := hJpq.symm
        _ ≤ objective r := hp.2 r hr
  intro hunique
  have hqp : q = p := hunique q hq
  exact hpq hqp.symm

/-- T9: any downstream feature differing on one same-reduct pair is not
source-determined. -/
def DeterminesFeature {Src : Type uSrc} {Phys : Type uPhys}
    {Feature : Type uFeature}
    (red : Phys → Src) (feature : Phys → Feature) : Prop :=
  ∀ p q, red p = red q → feature p = feature q

theorem feature_witness_refutes_determination
    {Src : Type uSrc} {Phys : Type uPhys} {Feature : Type uFeature}
    (red : Phys → Src) (feature : Phys → Feature)
    {p q : Phys} (hred : red p = red q)
    (hdiff : feature p ≠ feature q) :
    ¬ DeterminesFeature red feature := by
  intro hdet
  exact hdiff (hdet p q hred)

/-- T10: composing with a downstream readout does not restore determination
when that readout separates a same-reduct pair. -/
theorem downstream_readout_difference_refutes_determination
    {Src : Type uSrc} {Phys : Type uPhys}
    {Feature : Type uFeature} {Val : Type uVal}
    (red : Phys → Src) (feature : Phys → Feature) (readout : Feature → Val)
    {p q : Phys} (hred : red p = red q)
    (hdiff : readout (feature p) ≠ readout (feature q)) :
    ¬ DeterminesFeature red (fun x => readout (feature x)) := by
  exact feature_witness_refutes_determination red
    (fun x => readout (feature x)) hred hdiff

/-- Master kernel: same source reduct plus one admitted physical difference
refutes the claim that source structure determines physical reality. -/
theorem no_escape_kernel
    {Src : Type uSrc} {Phys : Type uPhys} {Obs : Type uObs} {Val : Type uVal}
    (red : Phys → Src) (readout : Obs → Phys → Val)
    {p q : Phys} {o : Obs}
    (hred : red p = red q) (hsep : readout o p ≠ readout o q) :
    ¬ SourceDetermines red (ObsEq readout) := by
  apply witness_refutes_source_determination red (ObsEq readout) hred
  exact observable_witness_refutes_obsEq readout hsep

end PhysicalNonDefinability

namespace PhysicalNonDefinability

/-! ## Theorem-volume irrelevance on a nontrivial realization fibre -/

universe uLabel

/-- A finite family of Boolean-valued source-language judgements factors
through the source reduct when every judgement depends only on source data. -/
def TheoremFamilyFactorsThrough {Src : Type uSrc} {Phys : Type uPhys}
    (red : Phys → Src) {n : Nat} (judge : Fin n → Phys → Bool) : Prop :=
  ∃ judge0 : Fin n → Src → Bool,
    ∀ i p, judge i p = judge0 i (red p)

/-- The joint truth-value fingerprint of a finite theorem/judgement family. -/
def TheoremFingerprint {Phys : Type uPhys} {n : Nat}
    (judge : Fin n → Phys → Bool) (p : Phys) : Fin n → Bool :=
  fun i => judge i p

/-- A theorem family distinguishes two physical lifts when at least one
source-language judgement has a different truth value on the two lifts. -/
def FamilyDistinguishes {Phys : Type uPhys} {n : Nat}
    (judge : Fin n → Phys → Bool) (p q : Phys) : Prop :=
  ∃ i, judge i p ≠ judge i q

/-- T11: every finite source-language theorem fingerprint is identical on
physical lifts with the same source reduct. The result is independent of n. -/
theorem theorem_fingerprint_equal_on_same_reduct
    {Src : Type uSrc} {Phys : Type uPhys} {n : Nat}
    (red : Phys → Src) (judge : Fin n → Phys → Bool)
    (hfactor : TheoremFamilyFactorsThrough red judge)
    {p q : Phys} (hred : red p = red q) :
    TheoremFingerprint judge p = TheoremFingerprint judge q := by
  cases hfactor with
  | intro judge0 hjudge =>
      funext i
      calc
        judge i p = judge0 i (red p) := hjudge i p
        _ = judge0 i (red q) := congrArg (judge0 i) hred
        _ = judge i q := (hjudge i q).symm

/-- T12: no finite number of source-language theorems can distinguish two
same-reduct physical lifts. -/
theorem source_theorem_family_zero_discrimination
    {Src : Type uSrc} {Phys : Type uPhys} {n : Nat}
    (red : Phys → Src) (judge : Fin n → Phys → Bool)
    (hfactor : TheoremFamilyFactorsThrough red judge)
    {p q : Phys} (hred : red p = red q) :
    ¬ FamilyDistinguishes judge p q := by
  intro hdist
  cases hdist with
  | intro i hi =>
      have hfp : TheoremFingerprint judge p = TheoremFingerprint judge q :=
        theorem_fingerprint_equal_on_same_reduct red judge hfactor hred
      exact hi (congrFun hfp i)

/-- T13: post-processing the complete source-theorem fingerprint cannot
restore information that is absent from the fingerprint itself. -/
theorem any_classifier_on_source_fingerprint_is_blind
    {Src : Type uSrc} {Phys : Type uPhys} {Label : Type uLabel} {n : Nat}
    (red : Phys → Src) (judge : Fin n → Phys → Bool)
    (hfactor : TheoremFamilyFactorsThrough red judge)
    (classify : (Fin n → Bool) → Label)
    {p q : Phys} (hred : red p = red q) :
    classify (TheoremFingerprint judge p) =
      classify (TheoremFingerprint judge q) := by
  exact congrArg classify
    (theorem_fingerprint_equal_on_same_reduct red judge hfactor hred)

/-- T14: theorem volume cannot repair physical non-definability. Even after
adjoining an arbitrary finite source-language theorem family, a physical
readout that separates two same-reduct lifts still refutes source determination. -/
theorem theorem_volume_cannot_repair_physical_nondefinability
    {Src : Type uSrc} {Phys : Type uPhys} {Obs : Type uObs} {Val : Type uVal}
    {n : Nat}
    (red : Phys → Src) (readout : Obs → Phys → Val)
    (judge : Fin n → Phys → Bool)
    (hfactor : TheoremFamilyFactorsThrough red judge)
    {p q : Phys} {o : Obs}
    (hred : red p = red q) (hsep : readout o p ≠ readout o q) :
    (¬ FamilyDistinguishes judge p q) ∧
      (¬ SourceDetermines red (ObsEq readout)) := by
  constructor
  · exact source_theorem_family_zero_discrimination red judge hfactor hred
  · exact no_escape_kernel red readout hred hsep

/-- Numerical corollary at the user's requested scale: 5,000 source-language
judgements still have zero discrimination on a same-reduct witness pair. -/
theorem five_thousand_source_theorems_zero_discrimination
    {Src : Type uSrc} {Phys : Type uPhys}
    (red : Phys → Src) (judge : Fin 5000 → Phys → Bool)
    (hfactor : TheoremFamilyFactorsThrough red judge)
    {p q : Phys} (hred : red p = red q) :
    ¬ FamilyDistinguishes judge p q := by
  exact source_theorem_family_zero_discrimination red judge hfactor hred

/-- Public OPH theorem-floor instantiation from 25 August 2026: even 8,400
source-language judgements cannot distinguish a same-reduct witness pair. -/
theorem eight_thousand_four_hundred_source_theorems_zero_discrimination
    {Src : Type uSrc} {Phys : Type uPhys}
    (red : Phys → Src) (judge : Fin 8400 → Phys → Bool)
    (hfactor : TheoremFamilyFactorsThrough red judge)
    {p q : Phys} (hred : red p = red q) :
    ¬ FamilyDistinguishes judge p q := by
  exact source_theorem_family_zero_discrimination red judge hfactor hred

/-- The result is count-independent; 8,449 is included as a convenience for
checkouts reporting that declaration count. -/
theorem eight_thousand_four_hundred_forty_nine_source_theorems_zero_discrimination
    {Src : Type uSrc} {Phys : Type uPhys}
    (red : Phys → Src) (judge : Fin 8449 → Phys → Bool)
    (hfactor : TheoremFamilyFactorsThrough red judge)
    {p q : Phys} (hred : red p = red q) :
    ¬ FamilyDistinguishes judge p q := by
  exact source_theorem_family_zero_discrimination red judge hfactor hred

/-- T15: if one Boolean judgement actually separates two same-reduct lifts,
that judgement cannot factor solely through the source reduct. This is the
formal source/extra-structure dichotomy for any allegedly load-bearing proof. -/
theorem separating_judgement_is_not_source_factorized
    {Src : Type uSrc} {Phys : Type uPhys}
    (red : Phys → Src) (judge : Phys → Bool)
    {p q : Phys} (hred : red p = red q)
    (hsep : judge p ≠ judge q) :
    ¬ FactorsThrough red judge := by
  intro hfactor
  exact hsep (factorized_quantity_equal_on_same_reduct red judge hfactor hred)

end PhysicalNonDefinability

namespace PhysicalNonDefinability

/-! ## No Semantic Alchemy and no bulk from a bare boundary -/

universe uScreen uBoundary uBulk uWorld uIndex

/-- A source predicate would "force external realization" only if every
source model satisfying it had a realization for every possible external
realization relation.  This deliberately separates source syntax/semantics
from an external physical-instantiation relation. -/
def ForcesExternalRealization {Src : Type uSrc} {World : Type uWorld}
    (T : Src → Prop) : Prop :=
  ∀ s, T s → ∀ realizes : Src → World → Prop, ∃ w, realizes s w

/-- T16 (No Semantic Alchemy): a satisfiable source theory cannot, solely by
its source-internal content, force an unconstrained external realization
relation to be inhabited.  Choosing the empty relation is the countermodel. -/
theorem no_semantic_alchemy
    {Src : Type uSrc} {World : Type uWorld}
    (T : Src → Prop) (hSat : ∃ s, T s) :
    ¬ ForcesExternalRealization (World := World) T := by
  intro hforce
  obtain ⟨s, hs⟩ := hSat
  obtain ⟨w, hw⟩ := hforce s hs (fun _ _ => False)
  exact hw

/-- A family of source-only constraints. -/
def SourceConstraintFamily {I : Type uIndex} {Src : Type uSrc}
    (A : I → Src → Prop) (s : Src) : Prop :=
  ∀ i, A i s

/-- T17 (No source-only enrichment): arbitrarily many additional constraints
that remain predicates of the source object do not create an external physical
realization.  If the enriched source theory is satisfiable, the empty external
realization relation remains an admissible expansion. -/
theorem no_source_only_enrichment_spawns_physics
    {I : Type uIndex} {Src : Type uSrc} {World : Type uWorld}
    (A : I → Src → Prop)
    (hSat : ∃ s, SourceConstraintFamily A s) :
    ¬ ForcesExternalRealization (World := World) (SourceConstraintFamily A) := by
  exact no_semantic_alchemy (World := World) (SourceConstraintFamily A) hSat

/-- T18 (public-world factorization obstruction): if a purported public-world
quotient identifies two physical states that an admitted physical observable
separates, that observable cannot factor through the public quotient. -/
theorem physical_distinction_blocks_public_factorization
    {Phys : Type uPhys} {Public : Type uScreen} {Out : Type uVal}
    (publicView : Phys → Public) (observable : Phys → Out)
    {p q : Phys}
    (hpublic : publicView p = publicView q)
    (hphysical : observable p ≠ observable q) :
    ¬ FactorsThrough publicView observable := by
  intro hfactor
  exact hphysical
    (factorized_quantity_equal_on_same_reduct
      publicView observable hfactor hpublic)

/-- A bare boundary/screen is sufficient for a boundary theory only if one
selector reconstructs every boundary theory from its bare screen. -/
def BareScreenSelectsBoundary
    {Screen : Type uScreen} {Boundary : Type uBoundary}
    (screenOf : Boundary → Screen) : Prop :=
  ∃ select : Screen → Boundary, ∀ b, select (screenOf b) = b

/-- T19 (No boundary theory from bare screen): if two distinct boundary
quantum theories have the same bare screen, no screen-only selector can recover
the boundary theory. -/
theorem same_screen_distinct_boundary_theories_refute_screen_selector
    {Screen : Type uScreen} {Boundary : Type uBoundary}
    (screenOf : Boundary → Screen)
    {b₁ b₂ : Boundary}
    (hscreen : screenOf b₁ = screenOf b₂)
    (hdistinct : b₁ ≠ b₂) :
    ¬ BareScreenSelectsBoundary screenOf := by
  intro hsel
  obtain ⟨select, hselect⟩ := hsel
  apply hdistinct
  calc
    b₁ = select (screenOf b₁) := (hselect b₁).symm
    _ = select (screenOf b₂) := congrArg select hscreen
    _ = b₂ := hselect b₂

/-- A bulk assignment factors through the bare screen when the reconstructed
bulk depends only on bare screen data and on no further boundary-theory data. -/
def BulkFactorsThroughBareScreen
    {Screen : Type uScreen} {Boundary : Type uBoundary} {Bulk : Type uBulk}
    (screenOf : Boundary → Screen) (bulkOf : Boundary → Bulk) : Prop :=
  FactorsThrough screenOf bulkOf

/-- T20 (No Bulk From Bare Boundary): two boundary theories with one bare
screen but different bulk reconstruction outputs rule out any reconstruction
map that factors through the bare screen alone. -/
theorem same_screen_different_bulk_refutes_bare_screen_holography
    {Screen : Type uScreen} {Boundary : Type uBoundary} {Bulk : Type uBulk}
    (screenOf : Boundary → Screen) (bulkOf : Boundary → Bulk)
    {b₁ b₂ : Boundary}
    (hscreen : screenOf b₁ = screenOf b₂)
    (hbulk : bulkOf b₁ ≠ bulkOf b₂) :
    ¬ BulkFactorsThroughBareScreen screenOf bulkOf := by
  exact physical_distinction_blocks_public_factorization
    screenOf bulkOf hscreen hbulk

/-- A minimal bare screen signature used only to make the reductio concrete.
The theorem is not about the artistic presentation; it records only the
12/30/20 incidence counts of the bare carrier. -/
structure BareTwelvePortScreen where
  ports : Nat
  edges : Nat
  faces : Nat
  deriving DecidableEq

/-- The named "Mr Tickle Screen" bare carrier used in the reductio. -/
def mrTickleBareScreen : BareTwelvePortScreen :=
  { ports := 12, edges := 30, faces := 20 }

/-- Two different boundary dynamics placed on the same bare twelve-port
carrier.  The constructors stand for different physical boundary theories,
not different drawings. -/
inductive MrTickleBoundaryTheory where
  | silent
  | interacting
  deriving DecidableEq

/-- Forget all dynamics and remember only the same 12/30/20 bare screen. -/
def mrTickleScreenOf (_ : MrTickleBoundaryTheory) : BareTwelvePortScreen :=
  mrTickleBareScreen

/-- A toy physical discriminator: the two boundary theories differ. -/
def mrTickleBoundaryReadout : MrTickleBoundaryTheory → Bool
  | .silent => false
  | .interacting => true

/-- T21 (Mr Tickle Screen reductio): the bare twelve-port screen cannot
recover even this minimal distinction between two boundary theories living on
exactly the same carrier.  Therefore incidence alone is not a boundary-QFT
selector. -/
theorem mr_tickle_screen_reductio :
    ¬ FactorsThrough mrTickleScreenOf mrTickleBoundaryReadout := by
  apply physical_distinction_blocks_public_factorization
    mrTickleScreenOf mrTickleBoundaryReadout
    (p := MrTickleBoundaryTheory.silent)
    (q := MrTickleBoundaryTheory.interacting)
  · rfl
  · decide

/-- Current-public-floor convenience corollary: a family of 8,800
source-factorized judgements still has zero discrimination on a same-reduct
physical pair.  The general theorem remains count-independent. -/
theorem eight_thousand_eight_hundred_source_theorems_zero_discrimination
    {Src : Type uSrc} {Phys : Type uPhys}
    (red : Phys → Src) (judge : Fin 8800 → Phys → Bool)
    (hfactor : TheoremFamilyFactorsThrough red judge)
    {p q : Phys} (hred : red p = red q) :
    ¬ FamilyDistinguishes judge p q := by
  exact source_theorem_family_zero_discrimination red judge hfactor hred

end PhysicalNonDefinability
