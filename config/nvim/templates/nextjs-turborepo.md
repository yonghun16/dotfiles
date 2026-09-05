# CLAUDE.md
> 📌 이 파일은 **Next.js + Turborepo 모노레포 + FSD(Feature-Sliced Design)**
> 보일러플레이트입니다. `[[ ]]`로 표시된 부분만 프로젝트에 맞게 채우고, 그 외
> 규칙(AI/Human 작업 경계, FSD 아키텍처 원칙, 문서 관리 규칙, 코딩 규칙 등)은
> 프로젝트가 바뀌어도 그대로 유지하세요. 이 파일 자체를 프로젝트마다 새로
> 설계하지 않는 것이 목적입니다.
>
> 한 번 정하고 넘어갈 수 있는 값·선택지는 아래 **"프로젝트 설정"** 섹션에
> 모아뒀으니 새 프로젝트를 시작할 때는 거기만 훑으면 됩니다. `통신 규칙`
> 같은 경우 "어떤 방식을 쓸지" 선택은 여기서 하지만, 그 방식에 맞는 예시
> 코드까지 여기서 다 쓰지는 않습니다 — 실제 구현 예시는 본문 분량이 크고
> 방식마다 완전히 달라서, 선택한 방식에 맞게 `통신 규칙` 섹션 자체를 아래
> 안내에 따라 다시 써야 합니다. `[[feature-name]]`, `[[entity-name]]`,
> `[[web]]`처럼 폴더 트리 안에 있는 표기는 프로젝트 설정이 아니라
> "app/슬라이스를 새로 만들 때마다 실제 이름으로 바꿔 쓰는 명명 규칙
> 예시"라서 원래 위치에 그대로 있습니다.

# 프로젝트 설정 (새 프로젝트 시작 시 여기만 채우면 됩니다)
## 프로젝트 개요
[[이 프로젝트가 무엇인지 2~3문장으로 설명. 예: "OO 사용자를 위한 XX 서비스입니다.
YY 방식으로 동작하며 ZZ와 연동합니다."]]

## 기술 스택
[[Next.js/TypeScript/Turborepo/pnpm/Tailwind/FSD 외에 사용하는 상태 관리
라이브러리, 데이터 fetching 라이브러리, ORM 등 프로젝트별 항목을 추가]]

## 통신 방식
[[Route Handler / Server Action / REST API / GraphQL / Socket.io 등
프로젝트에 맞는 방식을 선택. 선택한 방식에 맞게 아래 "통신 규칙" 섹션의
예시를 다시 작성해야 합니다 — 지금은 Next.js Route Handler + REST API
예시가 채워져 있습니다]]

## 문서 폴더 추가
[[`기획/`, `개발/`, `private/` 외에 프로젝트 성격에 따라 필요한 주제별
문서 폴더를 추가 (예: `운영/`, `회의록/`) — "프로젝트 문서 관리" 섹션에서
사용]]

## 개발 환경 (에디터/툴)
[[사용하는 에디터/툴 이름, 예: Neovim, VSCode 등 — "개발 환경" 섹션에서
사용]]

코드는 유지보수하기 쉽고 이해하기 쉬운 구조를 유지하는 것을 목표로 합니다.
이 프로젝트는 **FSD(Feature-Sliced Design)** 구조를 사용하며, 파일 상단의
`@owner` 태그로 사람과 AI의 작업 범위를 구분합니다.

# 기술 스택
- Next.js (App Router)
- TypeScript
- Turborepo
- pnpm workspaces
- Tailwind CSS
- FSD (Feature-Sliced Design)
- (위 "프로젝트 설정 > 기술 스택"에서 추가한 항목)

# 기본 개발 원칙
## 코드를 수정하기 전에
항상 다음을 지킵니다.
1. **아래 "AI/Human 작업 경계 규칙"부터 확인합니다.** 이 규칙이 다른 모든
   규칙보다 우선합니다.
2. 기존 코드를 먼저 확인합니다.
3. 현재 프로젝트 구조와 코딩 스타일을 유지합니다.
4. 필요하지 않은 리팩토링은 하지 않습니다.
5. 큰 구조 변경이 필요한 경우 먼저 이유를 설명합니다.
6. 복잡한 해결책보다 단순하고 명확한 해결책을 우선합니다.

# AI/Human 작업 경계 규칙
AI(Claude)는 **폴더 위치가 아니라 파일 상단의 `@owner` 태그**로 작업 가능
여부를 판단합니다. `model/`이든 `ui/`든 세그먼트와 무관하게, 태그 하나로
전부 결정됩니다. **파일마다 "이건 누가 해야 하나"를 새로 판단하지 마세요.**
아래 규칙대로 태그를 확인하고 따르면 됩니다.

## 태그 상태
| 태그 | 의미 | AI 작업 가능 여부 |
|---|---|---|
| `// @owner: ai` | AI가 만들었거나 아직 작업 중인 파일 | ✅ 자유롭게 작업 |
| `// @owner: human` | Human이 소유권을 넘겨받은 파일 | ❌ 금지 — 읽기만, 수정/생성 금지 |
| (태그 없음) | 이 규칙 도입 이전의 기존 코드 등, 미지정 상태 | ❌ 기본값은 Human으로 간주 — 먼저 확인 |

## 기본 원칙
1. **새로 만드는 모든 파일**(세그먼트 무관 — `ui/`, `model/`, `api/`,
   `lib/` 전부 동일)에는 AI가 파일 최상단에 `// @owner: ai`를 답니다.
   ~~~javascript
   // @owner: ai
   ~~~
2. `@owner: ai` 태그가 붙어 있는 동안에는 AI가 해당 파일을 계속
   수정/보완할 수 있습니다.
3. Human이 파일을 검토했거나 직접 손을 대기 시작하면, 태그를
   `// @owner: human`으로 바꿉니다. **태그가 바뀐 순간부터 AI는 그 파일을
   다시 수정하지 않고 읽기만 합니다.**
4. Human이 다시 AI에게 맡기고 싶으면 태그를 `// @owner: ai`로 되돌립니다.
   그때부터 다시 AI가 자유롭게 작업할 수 있습니다.
5. 태그가 아예 없는 파일(이 규칙을 도입하기 전에 작성된 기존 코드 등)은
   **기본값을 Human으로 간주**합니다. 안전을 위해 AI는 먼저 건드리지 않고,
   작업이 필요하면 태그를 붙여도 되는지 먼저 확인합니다.

## 파일 단위이지 세그먼트 단위가 아닙니다
같은 `model/` 폴더 안에서도 파일별로 태그가 다를 수 있습니다. `@owner: ai`가
붙은 model 파일은 AI가 자유롭게 작업하고, `@owner: human`이 붙은 ui 파일은
AI가 건드리지 않습니다. 폴더 이름으로 담당을 추측하지 말고 **항상 파일
상단의 태그를 확인**하세요.

## 검토를 요청해야 하는 경우 (권장)
`@owner: ai`로 작업 중이더라도, 아래에 해당하면 코드를 계속 넓혀가기보다
먼저 Human에게 검토를 요청하고 태그를 `@owner: human`으로 넘길지 물어보는
것을 권장합니다 (강제 규칙은 아니며, 놓치기 쉬운 위험 신호에 가깝습니다).
1. 틀리면 신뢰도/안전/데이터 무결성에 영향이 가는가?
2. 임계값·정책·규칙 같은 도메인 지식이 필요한가?
3. 잘못됐을 때 되돌리기 어렵거나 비용이 큰가?

반대로 아래에 해당하면 검토 없이 `@owner: ai`로 계속 작업해도 괜찮은
신호입니다.
4. 명세만 있으면 패턴대로 반복 구현 가능한가?
5. 테스트로 결과를 촘촘히 검증할 수 있는가?

## `@owner: human` 파일에 변경이 필요할 때
`@owner: human`이 붙은 파일(주로 이미 검토가 끝난 `model/` 등)을 참조해야
하는 기능을 만들 때는:
1. 그 파일의 기존 함수/타입을 **그대로 호출**해서 쓰세요 (수정 금지).
2. 새 함수나 수정이 필요하다고 판단되면, **코드를 직접 만들지 말고**
   무엇이 왜 필요한지 먼저 설명하세요. Human이 판단 후 작성하거나, 태그를
   다시 `@owner: ai`로 풀어줍니다.

## 요약
- **태그가 전부입니다**: `@owner: ai` = AI 자유 작업, `@owner: human` = AI
  금지(읽기만), 태그 없음 = 기본값 Human으로 간주
- 새로 만드는 파일은 세그먼트와 무관하게 전부 `@owner: ai`로 시작
- Human이 넘겨받으면 태그를 `@owner: human`으로 바꿔서 잠그고, 다시
  맡기려면 `@owner: ai`로 되돌림
- 도메인 판단이 필요한 코드는 계속 작업하기보다 먼저 검토를 요청하는 것을
  권장
- 애매하면 판단하지 말고 먼저 물어볼 것

# FSD 아키텍처 원칙 (모노레포 + Turborepo)
이 프로젝트는 **Turborepo 기반 모노레포**이며, `apps/`(실행 가능한 Next.js
앱)와 `packages/`(2개 이상 app이 공유하는 코드)로 나뉩니다. 각 Next.js 앱의
`src/` 내부는 **FSD(Feature-Sliced Design)** 레이어로 구성합니다. 프로젝트
규모나 도메인과 무관하게 이 두 층위(모노레포 최상위 + FSD 레이어)는 항상
동일한 모양을 유지한다는 전제로 작업합니다. 이렇게 하는 이유는, 코드는 AI가
작성하고 사람은 리뷰만 하는 워크플로우에서 **사람이 항상 예측 가능한 위치에서
코드를 찾을 수 있어야 하기 때문**입니다.

이 레이어 구조는 **코드를 어디에 둘지**에 대한 기준이고, **누가 그 코드를
수정할 수 있는지**는 위 "AI/Human 작업 경계 규칙"의 `@owner` 태그가 별도로
결정합니다. 두 규칙은 서로 독립적입니다.

## 레이어 구성 (위에서 아래로)
~~~
app     (Next.js App Router — 라우팅/전역 설정)
  ↓
views   (라우트별 화면 조합 — FSD 표준 명칭은 "pages"이나, 아래 이유로 이 프로젝트는 "views"를 사용)
  ↓
widgets (여러 feature/entity를 조합한 큰 UI 블록)
  ↓
features(사용자 인터랙션 단위 기능)
  ↓
entities(비즈니스 엔티티)
  ↓
shared  (도메인 지식 없는 재사용 인프라: UI 키트, lib, api 클라이언트, config)
~~~
- **FSD 표준 레이어명은 원래 `pages`이지만, 이 프로젝트에서는 `views`를
  사용합니다.** Next.js는 프로젝트 루트(또는 `src/`) 바로 아래에 `pages/`라는
  이름의 폴더가 있으면, App Router만 쓰기로 했는지와 무관하게 이를 **레거시
  Pages Router 진입점으로 자동 인식**합니다. 이로 인해 FSD 레이어용 `pages/`
  폴더와 `app/`의 실제 라우트가 같은 경로를 두고 충돌하는 문제가 실제
  빌드에서 확인되었습니다. FSD 커뮤니티에서도 Next.js와 함께 쓸 때는 이
  충돌을 피하기 위해 `views`라는 대체 명칭을 관례적으로 사용하며, 이
  보일러플레이트도 그 관례를 따릅니다.
- 이와는 별개로 `page.tsx`는 Next.js App Router 자체의 예약 파일명(라우트
  진입점)이며, FSD 레이어명과 무관하게 그대로 사용합니다. `app/`은 라우팅과
  전역 Provider 조립만 담당하고, 각 라우트의 `page.tsx`는 해당 라우트에
  대응하는 `views/` 레이어의 슬라이스를 불러와 조립만 합니다.
- **상위 레이어는 하위 레이어만 참조합니다** (FSD 표준 규칙). 이 규칙을 어기는
  import는 만들지 마세요.
  - 예: `features/`는 `entities/`, `shared/`를 참조할 수 있지만 `widgets/`,
    `views/`를 참조할 수 없습니다.
- 같은 레이어의 다른 슬라이스는 직접 내부 파일을 import하지 않고, 슬라이스의
  공개 API(`index.ts`)를 통해서만 참조합니다.

## 슬라이스 내부 세그먼트
`entities/`, `features/`, `widgets/`, `views/`의 각 슬라이스(예:
`entities/user/`, `features/auth/`)는 다음 세그먼트로 구성합니다. 담당은
세그먼트가 아니라 각 파일의 `@owner` 태그가 정합니다.
- `ui/` — 컴포넌트
- `model/` — 상태, 타입, 도메인 로직
- `api/` — 서버 통신 (스키마는 model 참조)
- `lib/` — 해당 슬라이스 전용 헬퍼

## 코드 배치 판단 기준
새 파일을 어디에 둘지 판단하는 기준은 다음 순서로 확인합니다.

> 1. **2개 이상의 app이 같이 쓰는가?**
>    → 예 → `packages/`의 알맞은 공용 패키지(`ui`, `types`, `config` 등)
> 2. **도메인 지식이 없는 순수 재사용 코드인가?** (UI 키트, 공용 유틸,
>    공용 API 클라이언트 초기화 등)
>    → 예 → `shared/`
> 3. **특정 비즈니스 엔티티(사용자, 상품, 주문 등)에 대한 데이터/표현인가?**
>    → 예 → `entities/<entity-name>/`
> 4. **사용자의 인터랙션(액션) 단위 기능인가?** (로그인, 좋아요, 장바구니
>    담기 등)
>    → 예 → `features/<feature-name>/`
> 5. **여러 feature/entity를 조합한 화면 블록인가?** (헤더, 상품 카드 목록
>    등)
>    → 예 → `widgets/<widget-name>/`
> 6. **특정 라우트 전용 조합인가?**
>    → 예 → `views/<page-name>/`

기존 코드가 여러 곳에서 재사용된다는 이유로 같은 레이어 안에서 옆으로
공유하지 않습니다. FSD에서는 **재사용이 필요하면 더 아래 레이어(entities
또는 shared)로 내립니다.** 이 순서를 바꾸지 않고, 폴더를 늘리거나 이름을
바꾸기 전에 반드시 위 기준으로 먼저 판단합니다. `apps/`, `packages/`,
그리고 FSD 6개 레이어(`app views widgets features entities shared`) 같은
최상위 카테고리는 새로 만들지 않습니다. 다만 그 안에 들어가는 app 이름,
package 이름, 슬라이스 이름은 프로젝트 필요에 따라 늘어나는 것이 정상입니다.

# TypeScript 규칙
- JavaScript보다 TypeScript 사용을 우선합니다.
- `any` 사용을 피합니다.
- 명확한 타입 정의를 작성합니다.
- 객체 구조와 컴포넌트 Props는 interface 사용을 우선합니다.
- 타입은 그 타입이 속한 슬라이스의 `model/`에 정의합니다. 해당 파일이
  `@owner: human`이면 직접 만들지 말고 필요성을 먼저 설명하고, `@owner: ai`
  또는 새로 만드는 파일이면 자유롭게 작성하되 `@owner: ai` 태그를 답니다.
- 2개 이상 슬라이스/레이어가 공유하는 타입은 `shared/types/`에, 2개 이상
  app이 공유하는 타입은 `packages/types/`에 둡니다.
- 여러 app/서버가 공유하는 외부 계약(API/소켓 payload 등)의 타입도
  `packages/types/`에 정의하고, 클라이언트/서버 양쪽에서 동일한 이름 규칙을
  사용합니다.

좋은 예:
~~~ts
interface User {
  id: string;
  name: string;
}
~~~

피해야 할 예:
~~~ts
const user: any = {};
~~~

# 문서화 규칙
다음 코드에는 TSDoc 작성:
- 외부에서 사용하는 함수
- 중요한 Hook
- 복잡한 비즈니스 로직
- 재사용 가능한 유틸 함수
- 외부 API/소켓 등과 통신하는 함수 (무엇을 언제 주고받는지 명시)

예:
~~~ts
/**
 * 새로운 사용자를 생성합니다.
 *
 * @param email - 사용자 이메일
 * @returns 생성된 사용자 정보
 */
async function createUser(email: string) {
}
~~~

단순한 코드에는 불필요한 주석을 추가하지 않습니다.

# 프로젝트 문서 관리 (Obsidian / Quartz)
코드 외의 프로젝트 문서(기획, 구현 프롬프트, 개발 프로세스, 회의/결정 기록 등)는
저장소 루트의 `docs/content/`(Obsidian Vault, Quartz 5로 사이트 빌드)에서
관리되는 마크다운 파일로 작성합니다. `docs/` 폴더에는 Quartz 5 관련 설정/코드가
함께 있으므로, Vault(문서)는 반드시 `docs/content/` 하위에만 작성하고 `docs/`
바로 아래(Quartz 설정 파일들이 있는 위치)에는 문서를 두지 않습니다. 이 문서들은
각 app/package 하위의 코드 문서화(TSDoc)와는 별개입니다.

**문서 작성 방식(폴더 구조, frontmatter, 태그, MOC 링크, 문서 최신성 관리
등)은 `docs/CLAUDE.md`에서 관리합니다.** `docs/` 하위에서 작업할 때는 이
파일과 `docs/CLAUDE.md`가 함께 적용되므로, 문서 관련 세부 규칙은 여기서
반복하지 않고 그쪽을 따릅니다. 이 파일(루트)에는 "문서는 `docs/content/`
안에만 두고 `docs/` 최상위(Quartz 설정 위치)에는 두지 않는다"는 경계만
유지합니다.

# Next.js 규칙
## App Router
- `app/` 폴더는 Next.js의 파일 기반 라우팅 규칙을 그대로 따릅니다 (세그먼트
  폴더, `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx` 등). 이 폴더의
  내부 모양은 프레임워크가 정하는 것이므로 임의로 재구성하지 않습니다.
  **주의**: `page.tsx`는 Next.js App Router의 예약 파일명이며, 아래 FSD의
  `views/` 레이어(라우트별 화면 조합)와는 별개 개념입니다. `page.tsx`는
  라우팅 진입점 역할만 하고, 실제 화면 조합 로직은 `views/`에 둡니다.
- 루트 `layout.tsx`와 `providers.tsx`에는 라우팅 조립과 전역 Provider 조합만
  두고, 비즈니스 로직은 두지 않습니다. 실제 로직은 FSD의 `views/`,
  `widgets/`, `features/` 등으로 분리합니다.
- 각 라우트의 `page.tsx`는 대응하는 `views/` 레이어 슬라이스를 조합해 실제
  화면을 구성하는 역할만 하고, 하위 레이어의 구현을 직접 담지 않습니다.

## Server/Client Component
- 기본은 Server Component이며, 상호작용(state, effect, 이벤트 핸들러 등)이
  필요한 컴포넌트에만 최상단에 `"use client"`를 명시합니다.
- `"use client"` 경계는 최대한 트리 아래쪽(실제로 상호작용이 필요한
  컴포넌트)에 두고, 불필요하게 상위 컴포넌트 전체를 클라이언트 컴포넌트로
  만들지 않습니다.
- 서버 전용 로직(DB 접근, 비밀 키 사용 등)은 Client Component에서 직접
  import하지 않습니다.

## 컴포넌트
- Functional Component를 사용합니다.
- Props는 TypeScript 타입을 정의합니다.
- 하나의 컴포넌트는 하나의 책임만 가지도록 합니다.
- 너무 큰 컴포넌트는 작은 컴포넌트로 분리합니다.
- 불필요한 상태 관리를 만들지 않습니다.
- 컴포넌트는 해당 슬라이스의 `ui/` 세그먼트에 두고, 새로 만들 때
  `@owner: ai`를 답니다. 재사용 범위에 따라 위 "코드 배치 판단 기준"에
  따라 더 아래 레이어(entities, shared)나 `packages/ui/`로 내립니다.

## Hook
- 반복되는 로직은 Custom Hook으로 분리합니다.
- 하나의 Hook은 하나의 역할만 담당합니다.
- 컴포넌트 내부에 큰 비즈니스 로직을 작성하지 않습니다.
- 상태를 다루는 Hook은 보통 `model/`에, 상태 없이 UI 로직만 담는 Hook은
  `ui/`나 `lib/`에 둡니다. 작업 가능 여부는 폴더가 아니라 파일의 `@owner`
  태그를 따릅니다.

이름 규칙:
~~~
useAuth.ts
usePosts.ts
~~~

# 프로젝트 구조
다음 구조를 유지합니다. **이 구조는 프로젝트 규모/도메인과 무관하게 고정입니다.**
모노레포 최상위 카테고리(`apps/`, `packages/`, `docs/`)와 각 app 내부의 FSD
레이어(`app views widgets features entities shared`)를 새로 만들지 않고, 새
앱은 `apps/` 아래에, 새 공유 코드는 `packages/` 아래에, 새 도메인/기능은
알맞은 FSD 레이어 안에 슬라이스로 배치합니다. `apps/`, `packages/`, 슬라이스
하위의 실제 이름([[web, admin, user, auth 등]])만 프로젝트마다 달라집니다.
아래 트리는 배치 기준이며, 각 파일의 실제 작업 가능 여부는 폴더가 아니라
`@owner` 태그로 결정됩니다.

~~~
project-root/
├── apps/
│   └── [[web]]/                          # Next.js 앱 (프로젝트별 이름)
│       └── src/
│           ├── app/                        # Next.js App Router — 라우팅 + 레이아웃 + 전역 Provider 조립
│           │   ├── (routes)/                 # 라우트 세그먼트 (page.tsx, layout.tsx 등)
│           │   ├── layout.tsx                  # 루트 레이아웃 (Provider 조합)
│           │   └── providers.tsx                 # 전역 Provider 묶음 (Client Component)
│           │
│           ├── views/                      # 라우트별 화면 조합 (FSD "pages" 레이어의 대체 명칭 — Next.js의
│           │   │                           #   레거시 Pages Router 예약 폴더명(pages/)과 충돌을 피하기 위해 사용)
│           │   └── [[page-name]]/
│           │       ├── ui/
│           │       └── model/
│           │
│           ├── widgets/                    # 여러 feature/entity를 조합한 큰 UI 블록
│           │   └── [[widget-name]]/
│           │       ├── ui/
│           │       ├── model/
│           │       └── lib/
│           │
│           ├── features/                   # 사용자 인터랙션 단위 기능
│           │   └── [[feature-name]]/
│           │       ├── ui/
│           │       ├── model/
│           │       ├── api/
│           │       └── lib/
│           │
│           ├── entities/                   # 비즈니스 엔티티
│           │   └── [[entity-name]]/
│           │       ├── ui/
│           │       ├── model/
│           │       ├── api/
│           │       └── lib/
│           │
│           └── shared/                     # 도메인 지식 없는 재사용 인프라
│               ├── ui/                       # 공용 UI 키트
│               ├── api/                      # 공용 API 클라이언트 초기화
│               ├── lib/                      # 공용 유틸/헬퍼
│               ├── config/                   # 환경변수, 전역 상수
│               └── types/                    # 앱 전역 공통 타입
│
├── packages/
│   ├── ui/                                 # 2개 이상 app이 공유하는 UI 컴포넌트
│   ├── config/                             # eslint-config, tsconfig, tailwind-config 등 공용 설정
│   ├── types/                              # 2개 이상 app/package가 공유하는 타입
│   ├── utils/                              # 2개 이상 app/package가 공유하는 순수 함수
│   └── [[도메인 패키지, 필요 시 추가]]/
│
├── docs/                                    # Quartz 5 관련 코드/설정
│   └── content/                               # Obsidian Vault (문서 사이트)
│       ├── index.md
│       ├── 기획/
│       ├── 개발/
│       ├── private/
│       ├── .obsidian/
│       └── templates/
│
├── turbo.json
├── pnpm-workspace.yaml
└── package.json
~~~

**레이어/세그먼트 한 줄 설명**

| 레이어/세그먼트 | 기준 |
|---|---|
| `apps/` | 실행 가능한 Next.js 앱들 |
| `packages/` | 2개 이상 app이 공유하는 코드만 |
| `app/` (각 app 내부) | Next.js App Router. 라우팅과 전역 Provider를 "조립"만 하는 곳 |
| `views/` | 특정 라우트 전용 화면 조합 (FSD 표준 명칭 "pages"의 프로젝트 내 대체 명칭) |
| `widgets/` | 여러 feature/entity를 조합한 화면 블록 |
| `features/` | 사용자 인터랙션 단위 기능 |
| `entities/` | 비즈니스 엔티티의 데이터/표현 |
| `shared/` | 도메인 지식 없는 재사용 인프라 |
| `ui/` (슬라이스 내부) | 컴포넌트 |
| `model/` (슬라이스 내부) | 상태, 타입, 도메인 로직 |
| `api/` (슬라이스 내부) | 서버 통신 |
| `lib/` (슬라이스 내부) | 슬라이스 전용 헬퍼 |

담당(AI/Human)은 이 표가 아니라 각 파일 상단의 `@owner` 태그로 결정됩니다
("AI/Human 작업 경계 규칙" 참고).

# 파일명 규칙
## Component
PascalCase 사용:
~~~
UserCard.tsx
PostList.tsx
LoginForm.tsx
~~~

## Hook
use 접두사 사용:
~~~
useAuth.ts
usePosts.ts
~~~

## Utility
camelCase 사용:
~~~
formatDate.ts
validateEmail.ts
~~~

## 프로젝트 문서 (docs/content/)
파일명·frontmatter·태그 규칙은 `docs/CLAUDE.md`를 따릅니다 (`프로젝트 문서
관리` 섹션 참고).

# 스타일링 규칙
- Tailwind CSS 사용을 우선합니다.
- Tailwind 설정은 `packages/config/`의 공용 설정을 각 app에서 확장(extend)해서
  씁니다. app마다 설정을 중복 작성하지 않습니다.
- 특별한 이유가 없다면 inline style을 사용하지 않습니다.
- 기존 UI 컴포넌트를 재사용합니다 (`packages/ui/` → `shared/ui/` → 해당
  슬라이스의 `entities/`·`features/` 순으로 확인 후 없으면 새로 만듭니다).
- className은 읽기 쉽게 작성합니다.

# 상태 관리 규칙
상황에 맞는 도구를 사용합니다.

로컬 상태:
~~~
useState
useReducer
~~~

전역 상태(Client 상태):
~~~
Redux Toolkit
Zustand
~~~

서버 상태:
~~~
React Query (또는 Next.js의 fetch 캐싱/revalidate)
~~~

- 상태의 원본 소스는 항상 서버이며, 클라이언트(Client Component)는 서버에서
  받은 상태를 그대로 반영한다는 원칙을 지킵니다. 가능한 경우 데이터 fetching은
  Server Component에서 먼저 시도하고, 상호작용이 필요한 부분만 Client
  Component + 전역/서버 상태 라이브러리로 넘깁니다.
- 상태 정의·타입·스토어 로직은 해당 슬라이스의 `model/`에 둡니다. 새로
  만드는 경우 `@owner: ai`를 달고 자유롭게 작성하고, 이미 `@owner: human`인
  파일은 그대로 호출만 하고 수정이 필요하면 먼저 설명하고 요청합니다.
- 여러 feature/entity가 공유하는 상태 로직은 더 아래 레이어(`entities/`,
  `shared/`)로 내리고, 2개 이상 app이 공유하는 경우 `packages/`로 올립니다.
- 새로운 상태 관리 라이브러리를 추가하기 전에 이유를 설명합니다.

# 통신 규칙
최상단 "프로젝트 설정 > 통신 방식"에서 고른 방식에 맞게 아래 예시를 이
섹션 전체에 걸쳐 다시 작성하세요. 지금은 Next.js Route Handler + REST API
기준 예시가 채워져 있습니다.

예시(Next.js Route Handler + REST API 기반인 경우):
- API 엔드포인트는 각 app의 `src/app/api/**/route.ts`(Route Handler)에
  정의하거나, 별도 백엔드가 있다면 그 서버의 REST API를 호출합니다.
- HTTP 클라이언트 인스턴스는 `shared/api/`(또는 `packages/`의 공용 패키지)에서
  단일 인스턴스로 관리하고, 여러 곳에서 개별적으로 fetch/axios를 새로 설정하지
  않습니다.
- 특정 entity/feature의 API 호출 로직은 각 슬라이스의 `api/` 세그먼트에서
  `shared/api/`의 인스턴스를 가져다 씁니다. 요청/응답 스키마는 해당 슬라이스의
  `model/`을 참조합니다(`@owner: human`이면 직접 수정 금지).
- 데이터를 변경하는 로직은 가능한 경우 Server Action으로 작성하고, 그 외에는
  Route Handler + 클라이언트 호출로 작성합니다.
- 네트워크 실패/재시도 상황을 항상 고려합니다.
- 2개 이상 app/서버가 공유하는 요청/응답 타입은 `packages/types/`에 정의한
  뒤 사용합니다.

# 에러 처리 규칙
- 에러는 명확하게 처리합니다.
- 빈 catch 문을 사용하지 않습니다.
- 사용자에게 의미 있는 에러 메시지를 제공합니다.

피해야 할 예:
~~~ts
try {
} catch {}
~~~

권장:
~~~ts
try {
} catch (error) {
  console.error("Failed:", error);
}
~~~

# 리팩토링 규칙
리팩토링 시:
1. 기존 기능을 유지합니다.
2. 작은 단위로 변경합니다.
3. 관련 없는 파일은 수정하지 않습니다.
4. `@owner: human` 파일은 리팩토링 대상에서 제외합니다.
5. 구조 변경 시 이유를 설명합니다.

# Git 규칙
- 하나의 커밋은 하나의 목적만 가집니다.
- 관련 없는 변경을 섞지 않습니다.
- 기존 기능을 삭제하기 전에 확인합니다.
- `@owner: human` 태그가 붙은 파일 변경이 포함된 커밋은 Human이 작성한
  것인지 확인합니다.

# AI 작업 규칙
AI는 다음을 지킵니다.
1. **코드를 만들기 전에 대상 파일 상단의 `@owner` 태그를 확인합니다.**
   `@owner: human`이거나 태그가 아예 없으면(기본값 Human) 코드를 작성하지
   않고 필요한 변경사항을 설명만 합니다. `@owner: ai`이거나 새로 만드는
   파일이면 자유롭게 작업하고, 새 파일에는 반드시 `// @owner: ai`를
   답니다.
2. 코드를 수정하기 전에 기존 구현을 확인합니다.
3. 변경 이유를 설명합니다.
4. 새 파일 생성 시 전체 코드를 제공합니다.
5. 영향 범위를 알려줍니다.
6. 큰 구조 변경은 먼저 사용자에게 확인합니다.
7. 새 파일을 만들 때는 항상 다음 순서로 판단합니다: (1) 2개 이상 app이
   공용인가 → `packages/`, (2) 도메인 지식 없는 재사용 코드인가 →
   `shared/`, (3) 엔티티 데이터/표현인가 → `entities/`, (4) 사용자 인터랙션
   기능인가 → `features/`, (5) 여러 feature/entity 조합 블록인가 →
   `widgets/`, (6) 라우트 전용 조합인가 → `views/` (`FSD 아키텍처 원칙`
   섹션 참고). 위치를 정한 뒤에는 `@owner: ai` 태그를 달아 새 파일을
   만듭니다. `apps/`, `packages/`, FSD 6개 레이어 같은 최상위 카테고리는
   임의로 늘리지 않습니다.
8. 새로운 app이나 package를 추가할 때는 왜 필요한지(예: 2개 이상에서 쓰이는
   코드인지, 별도로 배포해야 하는 앱인지)를 먼저 설명하고, 기존
   app/package와 역할이 겹치지 않는지 확인합니다.
9. `app/` 폴더 내부는 Next.js 라우팅 규칙(세그먼트, `page.tsx`,
   `layout.tsx` 등)을 따르며, 이 규칙과 무관하게 임의로 하위 폴더 이름을
   바꾸지 않습니다.
10. 상위 레이어가 하위 레이어만 참조하는 FSD import 규칙을 어기는 코드를
    만들지 않습니다.
11. 도메인 판단(임계값, 정책, 신뢰도/안전/데이터 무결성에 영향)이 필요하다고
    느껴지면, `@owner: ai` 상태여도 계속 밀어붙이지 않고 먼저 Human에게
    검토를 요청합니다.
12. 새로운 기능에 대한 구현 프롬프트나 개발 프로세스를 작성/수정할 때는
    `docs/content/` 폴더(Obsidian Vault)의 알맞은 주제별 폴더(`기획/`, `개발/` 등)에
    저장합니다. `docs/content/` 바로 아래에 파일을 흩어놓지 않고, `docs/` 최상위
    (Quartz 설정 위치)에는 절대 문서를 두지 않습니다. 세부 작성 규칙(frontmatter,
    태그, MOC 링크, 최신성 관리 등)은 `docs/CLAUDE.md`를 따릅니다.

# 개발 선호 사항
선호:
- 깔끔한 TypeScript 코드
- Functional React Component
- Server Component 우선, 필요한 곳에만 `"use client"`
- TSDoc 문서화
- Tailwind CSS
- 재사용 가능한 컴포넌트
- 명확한 관심사 분리
- `@owner` 태그를 존중하고, 애매하면 먼저 물어보는 태도

피하기:
- 불필요한 추상화
- 과도한 의존성 추가
- 너무 큰 컴포넌트
- `any` 사용
- 이유 없는 구조 변경
- 이유 없이 새로운 app/package/레이어 추가 (`FSD 아키텍처 원칙` 위반)
- 불필요하게 넓은 범위의 `"use client"` 선언
- `@owner: human` 파일이나 태그 없는 기존 파일을 임의로 수정하는 것
- 새 파일을 만들면서 `@owner: ai` 태그를 빠뜨리는 것

# 개발 환경
- 코드 수정 시 사용 중인 에디터/툴 환경(최상단 "프로젝트 설정 > 개발 환경"
  참고)을 고려합니다.
- ESLint, Prettier, TypeScript 규칙을 준수합니다 (`packages/config/`의 공용
  설정 기준).
- `turbo run` 기반 스크립트(`build`, `dev`, `lint` 등)를 각 app/package의
  `package.json`에 일관되게 정의합니다.
- 자동 생성 코드라도 프로젝트 기존 스타일을 우선합니다.
