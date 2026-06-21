---
name: project-ckt-inplane-correction
description: FWP in-plane image-charge correction was tested for CKT (coulomb_trunc) As_In slab results and found unnecessary/inapplicable
metadata: 
  node_type: memory
  type: project
  originSessionId: efba5fd5-ccfb-407c-9da5-9aed92ace44e
---

For As_In (q0/q+1/q+2), `02_vacuum_scan/coulomb_trunc/new_c_40A`, the FWP finite-size
correction tool (`~/bin/finite-size-corrections-defect-levels.py`) was used to check
whether an additional in-plane (x-y) image-charge correction is needed on top of CKT
(z-direction) + the existing LOCPOT-based ΔV(q) potential alignment in
`03_dfe_plot/plot_dfe.py`.

**Conclusion (2026-06-12)**: keep using the existing CKT + ΔV(q) result as-is
(`dfe_coulomb_trunc_{in,as}_rich_new_c_40A.png`, "1a" variant). No FWP correction applied.

**Why**:
- With `alignment=no` (madelung-only term, qC=qR=q reduces to
  `Ecor(q) = (Eiso-Eper)*q^2/eps_0`), the in-plane correction is tiny and
  essentially negligible: Ecor(q=1)=-0.00996 eV, Ecor(q=2)=-0.0399 eV
  (eps_0=15.15, eps_inf=12.3, sigma=1.4 Bohr; converged from E_cutoff=22-400 Ry).
  Adding this to the DFE makes no visible difference (panel 2a == panel 1a).
- With `alignment=yes` (FWP's own LOCPOT-based potential alignment, using
  `LOCPOT.cube` files generated via `vaspkit -task 429` then `LOCPOT`), the
  result is non-physical regardless of direction: direction=x gives
  Ecor(q=1)=+11.84 eV, Ecor(q=2)=+47.46 eV; direction=y gives
  Ecor(q=1)=+9.26 eV, Ecor(q=2)=+37.08 eV. These are ~100x larger than typical
  FNV alignment terms and scale ~q^2 (i.e. ΔV scales linearly with q), which
  points to the jellium-background-induced shift of the absolute potential
  reference between charge-state LOCPOTs, not a local in-plane alignment effect.
- Direction=z + alignment=yes is conceptually inconsistent anyway since CKT
  already handles z-periodicity; doing so gave ΔV≈-11.85/-23.75 eV with an
  "inverted" V_DFT(z) profile (steep in vacuum, flat in slab) — also dominated
  by the same jellium-background reference shift, not real screening physics.
- Overall takeaway: this 3D-isotropic-Ewald FWP/FNV model (validated on compact
  cubic bulk cells like the MgO example, where Ecor=+0.27 eV for q=+1) does not
  transfer cleanly to a highly anisotropic CKT slab+vacuum cell
  (8.75 x 12.38 x 40 A) in any direction.

**How to apply**: Don't re-introduce FWP/FNV in-plane corrections for this CKT slab
geometry unless the cell becomes much more isotropic (e.g. after the planned 3x2x1
in-plane supercell scan) or a dedicated 2D-Ewald (Komsa-Pasquarello-type) scheme is
implemented.

**Next step (planned by user)**: run a 3x2x1 in-plane supercell of the same CKT
new_c_40A As_In system and re-check whether (Eiso-Eper) (and any in-plane
image-charge effect) shrinks/converges as the in-plane cell size increases —
this would validate today's "negligible" conclusion at the current cell size.

Working files: `03_dfe_plot/inplane_correction/` (input-AsIn_CKT_40A.dat,
apply_inplane_correction.py, compare_alignment_variants.py,
compare_alignment_variants_{in,as}_rich_new_c_40A.png, cube_files/LOCPOT_q{0,1,2}.cube).
