---
name: inas-band-alignment-method
description: Use bulk-projected band structure (bulk-PBAND) for potential alignment in charged defect formation energy instead of LOCPOT-based method
metadata: 
  node_type: memory
  type: project
  originSessionId: 38487651-eef0-4408-8101-c448086f52a2
  server: kohn
---

User prefers band alignment over LOCPOT-based potential alignment for delta_V correction in charged defect calculations.

**Why:** LOCPOT reference can be sensitive to z-position selection and vacuum size in charged slabs. Bulk-projected bands provide a more robust reference that captures the full electronic structure.

**How to apply:** When computing delta_V for formation energy of charged surface defects on InAs.

## Method
1. Run band calculation (02-band) for both pure/q0 and In_i/q1
2. Extract bulk-PBAND: project band structure onto bulk-like atoms (fixed In/As layers, Selective Dynamics F F F)
3. Compare pure vs defect bulk-PBAND at:
   - Core-level bands (deep states)
   - Band-edge bands (VBM/CBM vicinity)
4. If both regions align consistently → use that shift as delta_V
5. If inconsistent → prioritize **band-edge** alignment for delta_V

## Data needed
- PROCAR from 02-band calculations (contains projection weights per atom)
- POSCAR to identify which atoms are bulk-like (F F F flags)
- EIGENVAL/KPOINTS for band energies and k-path

Related: [[inas-surface-defect-fig8]]
