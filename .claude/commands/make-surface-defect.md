# Surface Defect POSCAR Generator

Cl-passivated InAs (110) 표면 slab에서 point defect 구조를 생성한다.

## 사용법

사용자가 `/make-surface-defect` 호출 시, 함께 제공하는 인자를 파싱하여 실행한다.
사용자가 제공하는 정보:
- **Defect 이름**: e.g. `In_i_Td_As`, `V_In`, `As_In`
- **조작 내용**: 어떤 원자를 치환/제거하거나, 어떤 원자들로 이루어진 site에 원자를 추가
- **Reference**: 어떤 POSCAR을 기준으로 할지 (e.g. "Cl 패시베이션된 pure slab")

### 인자 예시

```
Reference: Cl 패시베이션된 pure slab
이름: In_i_Td_As
설명: As16, As28, As34, As36으로 이루어진 tetrahedral site에 In 원자 넣는다.
```

```
Reference: pure slab
이름: V_In
설명: In028 원자를 제거하고 Cl로 채운다.
```

```
Reference: pure slab
이름: As_In
설명: In028을 As로 치환한다.
```

## 워크플로우

### 1. 인자 파싱
사용자가 제공한 텍스트에서 추출:
- `defect_name`: defect 이름
- `action`: substitute / vacancy / interstitial (설명에서 판단)
- `target_atoms`: 대상 원자 라벨들 (e.g. In028, As016)
- `new_species`: 추가/치환할 원소 (e.g. In_d, As, Cl)
- `reference_poscar`: reference POSCAR 경로 결정

### 2. Reference POSCAR 로드
- "pure slab" / "Cl 패시베이션된 pure slab" → `inputs/pure/POSCAR`
- 사용자가 다른 경로를 지정하면 해당 경로 사용
- POSCAR을 읽어 species, atom counts, 원자 좌표 파악

### 3. Interstitial 위치 계산 (interstitial인 경우)
사용자가 지정한 원자들(e.g. As16, As28, As34, As36)의 **centroid**를 계산하여 interstitial 위치로 사용:
- 지정된 원자 라벨들을 POSCAR에서 찾아 fractional coordinates 추출
- centroid = 평균 좌표
- nearest neighbor distance 확인 (≥ 2.0 Å)
- 계산된 위치와 이웃 원자를 사용자에게 보여주고 확인

### 4. POSCAR 생성
`scripts/generate_surface_defect.py` 사용:

```bash
# Antisite (예: In028 → As 치환)
python3 scripts/generate_surface_defect.py \
  --pure inputs/pure/POSCAR \
  --action substitute \
  --target In028 \
  --new-species As \
  --output inputs/defects/As_In/POSCAR

# Vacancy + Cl (예: In028 제거 후 Cl 채움)
python3 scripts/generate_surface_defect.py \
  --pure inputs/pure/POSCAR \
  --action vacancy \
  --target In028 \
  --new-species Cl \
  --output inputs/defects/V_In/POSCAR

# Interstitial (예: Td site에 In 추가)
python3 scripts/generate_surface_defect.py \
  --pure inputs/pure/POSCAR \
  --action interstitial \
  --interstitial-species In_d \
  --interstitial-pos 0.4167 0.5000 0.6300 \
  --output inputs/defects/In_i_Td_As/POSCAR
```

스크립트가 없으면 직접 POSCAR 편집:
1. reference POSCAR 복사
2. 원자 추가/제거/치환
3. Species counts 업데이트
4. Species별 원자 그룹화 및 재정렬
5. 라벨 재번호매기기

### 5. 검증
- 총 원자 수 확인
- Species counts 정합성
- Selective Dynamics 플래그 보존
- Interstitial의 경우 nearest neighbor distance 확인 (≥ 2.0 Å)
- 결과를 사용자에게 보고

### 6. defects.yaml 업데이트
`config/defects.yaml`에 새 defect 항목 추가:
- poscar 경로
- type (antisite/vacancy/interstitial)
- charge_states (기본 [0])
- delta_atoms (reference 대비 원자 수 변화)
- defect_atom_index (1-based)
- defect_center_frac (vacancy의 경우)
- reference_neighbors: 사용자가 지정한 원자들의 1-based index (defect POSCAR 기준)

## 주의사항
- Species 순서는 반드시 POTCAR 순서를 따른다 (In_d, As, H1.25, H.75, Cl)
- Bottom layer 원자 (F F F)는 절대 수정하지 않는다
- 사용자가 제공한 원자 라벨/번호를 우선으로 하고, 자동 탐색은 하지 않는다
- Interstitial 위치는 사용자가 지정한 원자들의 centroid로 결정한다
