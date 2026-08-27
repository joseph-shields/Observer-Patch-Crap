# No Semantic Alchemy

Let `T : Src -> Prop` be satisfiable and let `realizes : Src -> World -> Prop` be an external relation meaning that a source model is physically instantiated. If `T` does not constrain `realizes`, choose a source model satisfying `T` and expand it with `realizes := fun _ _ => False`. All source theorems remain true while no world realizes the source model.

The same construction survives any family of source-only enrichments. Adding an internal predicate named `Physical` merely adds another symbol inside the formal model; it does not populate the external realization relation.

The only possible repair is independently grounded physical structure. Once supplied, that structure is load-bearing and cannot be credited to the original source-only theory.
