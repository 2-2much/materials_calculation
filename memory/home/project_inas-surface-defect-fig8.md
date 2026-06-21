---
name: inas-surface-defect-fig8
description: "Plan to reproduce Fig.8-like plot (VBM & formation energy vs defect concentration) for In_i^{+1} on InAs surface, comparing 3D (bare) vs 2D (CKT) boundary conditions"
metadata: 
  node_type: memory
  type: project
  originSessionId: 38487651-eef0-4408-8101-c448086f52a2
  server: kohn
---

Reproduce Fig.8 from Vijay et al. PRB 112, 045409 (2025) for InAs surface In interstitial defect.

**Why:** Validate Coulomb kernel truncation (2D BC) vs standard 3D BC for charged surface defect formation energy calculations on InAs.

**How to apply:** When working in `~/materials/33-inAs/__Functional_Validation__/11-Surface-defect_TOY-model/00_TOY_DEBUG/`.

## Agreed plan

### Data location
- Base: `~/materials/33-inAs/__Functional_Validation__/11-Surface-defect_TOY-model/00_TOY_DEBUG/`
- Supercell sizes: 2x2x1, 3x2x1, 6x4x1
- Vacuum sizes: new_c_20A, new_c_30A, new_c_40A
- Boundary conditions: bare (3D BC), CKT (2D BC)
- Defect: In_i, charge states q0, q1, q2 (focus on q=+1)
- Reference: pure/q0

### Folder structure caveat
- 3x2x1: has `01-1shot/` and `02-band/` subdirectories inside each q folder
- 2x2x1, 6x4x1: VASP output files directly in q folder (but user plans to add 02-band structure to match 3x2x1 layout)

### Figure layout (4 panels, no bulk defect panel)
- (a) VBM vs 1/sqrt(nx*ny) under 3D BC (bare) — defect (black) + pristine (red), markers by vacuum size
- (b) Formation energy vs 1/sqrt(nx*ny) under 3D BC (bare) — markers by vacuum size
- (d) VBM vs 1/sqrt(nx*ny) under 2D BC (CKT)
- (e) Formation energy vs 1/sqrt(nx*ny) under 2D BC (CKT)

### x-axis definition
Use `1/sqrt(nx*ny)` where nx, ny are the lateral supercell repetitions:
- 2x2x1: 1/sqrt(4) = 0.5
- 3x2x1: 1/sqrt(6) ≈ 0.408
- 6x4x1: 1/sqrt(24) ≈ 0.204

### Formation energy formula (In_i)
```
E_f[In_i^q] = E[In_i, q] - E[pure, 0] - mu_In + q * (epsilon_F + VBM + delta_V)
```
Plot at epsilon_F = 0 (VBM reference).

### Potential alignment approach — [[inas-band-alignment-method]]
User plans to use **band alignment** instead of LOCPOT-based alignment:
1. Compute bulk-projected band structure (bulk-PBAND) for both pure and In_i^{+1}
2. Project onto bulk-like atoms (Selective Dynamics F F F, In/As species)
3. Check alignment consistency at both core-level and band-edge bands
4. If inconsistent, prioritize **band-edge alignment** for delta_V

### Chemical potentials (from existing config)
- mu_As (A7): -4.669549 eV
- mu_In (metal): -2.562344 eV
- mu_InAs (bulk): -7.718334 eV

### Existing code
- `03_dfe_plot/plot_dfe.py` — existing DFE plotting script (uses LOCPOT alignment, formula hardcoded for As_In)
- `03_dfe_plot/dfe_config_3x2x1_bare.json` / `_CKT.json` — config files (already set to In_i)
