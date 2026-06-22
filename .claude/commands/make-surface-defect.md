# Surface Defect POSCAR Generator

Cl-passivated InAs (110) 표면 slab에서 point defect 구조를 생성한다.

## 사용법

사용자가 `/make-surface-defect` 호출 시 아래 워크플로우를 대화형으로 진행한다.

## 워크플로우

### 1. 프로젝트 확인
- 현재 디렉토리에서 `inputs/pure/POSCAR` 존재 확인
- 없으면 사용자에게 pure POSCAR 경로 요청

### 2. 표면 구조 분석
`inputs/pure/POSCAR`을 읽고:
- Species, atom counts 파악
- Selective Dynamics 기반으로 표면 원자 (T T T) 식별
- 표면 layer 구분: top surface (z 최대), sub-surface (z 차순위)
- Cl passivation bonding 파악 (각 Cl이 어떤 In/As에 bonded인지)
- 분석 결과를 사용자에게 간략히 보여주기

### 3. Defect 종류 선택
사용자에게 defect 종류 질문:
- **Antisite**: 표면 원자의 species 치환 (예: In→As, As→In)
- **Vacancy + Cl**: 표면 원자 제거 후 Cl로 채움
- **Interstitial**: subsurface에 원자 추가

### 4. 대상 원자 / 위치 결정

**Antisite/Vacancy**: 
- 표면 원자 목록을 보여주고 대상 원자 선택 요청
- 기본값: 셀 중심에 가장 가까운 원자 제안

**Interstitial**:
- `scripts/generate_surface_defect.py`가 있으면 활용
- 없으면: subsurface 영역 (top 2 bilayer 사이)에서 grid search로 최적 void 위치 계산
  - x,y,z grid (step ~0.02 fractional), PBC 적용
  - 모든 원자까지의 최소 거리가 가장 큰 위치 = interstitial site
  - d_min ≥ 2.0 Å 이상이어야 함
- 후보 위치와 nearest neighbors를 사용자에게 보여주고 확인

### 5. POSCAR 생성

`scripts/generate_surface_defect.py` 사용:
```bash
# Antisite (예: As→In)
python3 scripts/generate_surface_defect.py \
  --pure inputs/pure/POSCAR \
  --action substitute \
  --target As028 \
  --new-species In_d \
  --output inputs/defects/In_As/POSCAR

# Vacancy + Cl
python3 scripts/generate_surface_defect.py \
  --pure inputs/pure/POSCAR \
  --action vacancy \
  --target In028 \
  --new-species Cl \
  --output inputs/defects/V_In/POSCAR

# Interstitial
python3 scripts/generate_surface_defect.py \
  --pure inputs/pure/POSCAR \
  --action interstitial \
  --interstitial-species In_d \
  --interstitial-pos 0.4167 0.5000 0.6300 \
  --output inputs/defects/In_i/POSCAR
```

스크립트가 없으면 직접 POSCAR 편집:
1. pure POSCAR 복사
2. 원자 추가/제거/치환
3. Species counts 업데이트
4. Species별 원자 그룹화 및 재정렬
5. 라벨 재번호매기기

### 6. 검증
- 총 원자 수 확인 (antisite/vacancy: pure와 동일, interstitial: +1)
- Species counts 정합성
- Selective Dynamics 플래그 보존
- Interstitial의 경우 nearest neighbor distance 확인 (≥ 2.0 Å)

### 7. defects.yaml 업데이트
`config/defects.yaml`에 새 defect 항목 추가:
- poscar 경로
- type (antisite/vacancy/interstitial)
- charge_states (기본 [0])
- delta_atoms (pure 대비 원자 수 변화)
- defect_atom_index (1-based, antisite/interstitial)
- defect_center_frac (vacancy의 경우)
- reference_neighbors (defect 위치 근처 4개 원자의 1-based index)

## 주의사항
- Species 순서는 반드시 POTCAR 순서를 따른다 (In_d, As, H1.25, H.75, Cl)
- 표면 원자만 대상으로 한다 (T T T 플래그, z가 큰 쪽)
- Bottom layer 원자 (F F F)는 절대 수정하지 않는다
- Interstitial은 표면 위(adatom)가 아닌 subsurface에 배치하여 detach 방지
