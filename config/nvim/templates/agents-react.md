# AGENTS.md

# 프로젝트 개요

이 프로젝트는 Vite 기반의 React + TypeScript 애플리케이션입니다.
코드는 유지보수하기 쉽고 이해하기 쉬운 구조를 유지하는 것을 목표로 합니다.


# 기술 스택

- React
- TypeScript
- Vite
- Tailwind CSS
- React Router
- React Icons
- clsx


# 기본 개발 원칙

## 코드를 수정하기 전에

항상 다음을 지킵니다.

1. 기존 코드를 먼저 확인합니다.
2. 현재 프로젝트 구조와 코딩 스타일을 유지합니다.
3. 필요하지 않은 리팩토링은 하지 않습니다.
4. 큰 구조 변경이 필요한 경우 먼저 이유를 설명합니다.
5. 복잡한 해결책보다 단순하고 명확한 해결책을 우선합니다.


# TypeScript 규칙

- JavaScript보다 TypeScript 사용을 우선합니다.
- `any` 사용을 피합니다.
- 명확한 타입 정의를 작성합니다.
- 객체 구조와 컴포넌트 Props는 interface 사용을 우선합니다.
- 여러 곳에서 사용하는 타입은 별도 파일로 분리합니다.

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


# React 규칙

## 컴포넌트

- Functional Component를 사용합니다.
- Props는 TypeScript 타입을 정의합니다.
- 하나의 컴포넌트는 하나의 책임만 가지도록 합니다.
- 너무 큰 컴포넌트는 작은 컴포넌트로 분리합니다.
- 불필요한 상태 관리를 만들지 않습니다.


## Hook

- 반복되는 로직은 Custom Hook으로 분리합니다.
- 하나의 Hook은 하나의 역할만 담당합니다.
- 컴포넌트 내부에 큰 비즈니스 로직을 작성하지 않습니다.

이름 규칙:

~~~
useAuth.ts
usePosts.ts
~~~


# 프로젝트 구조

다음 구조를 유지합니다.

~~~
src/
├── app/
├── assets/
├── components/
│   ├── layout/
│   └── ui/
├── constants/
├── features/
├── hooks/
├── lib/
├── pages/
├── services/
├── store/
├── styles/
├── types/
└── utils/
~~~


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


# 스타일링 규칙

- Tailwind CSS 사용을 우선합니다.
- 특별한 이유가 없다면 inline style을 사용하지 않습니다.
- 기존 UI 컴포넌트를 재사용합니다.
- className은 읽기 쉽게 작성합니다.


# 상태 관리 규칙

상황에 맞는 도구를 사용합니다.

로컬 상태:

~~~
useState
useReducer
~~~

전역 상태:

~~~
Redux Toolkit
Zustand
~~~

서버 상태:

~~~
React Query
~~~

새로운 상태 관리 라이브러리를 추가하기 전에 이유를 설명합니다.


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
4. 구조 변경 시 이유를 설명합니다.


# Git 규칙

- 하나의 커밋은 하나의 목적만 가집니다.
- 관련 없는 변경을 섞지 않습니다.
- 기존 기능을 삭제하기 전에 확인합니다.


# AI 작업 규칙

AI는 다음을 지킵니다.

1. 코드를 수정하기 전에 기존 구현을 확인합니다.
2. 변경 이유를 설명합니다.
3. 새 파일 생성 시 전체 코드를 제공합니다.
4. 영향 범위를 알려줍니다.
5. 큰 구조 변경은 먼저 사용자에게 확인합니다.


# 개발 선호 사항

선호:

- 깔끔한 TypeScript 코드
- Functional React Component
- TSDoc 문서화
- Tailwind CSS
- 재사용 가능한 컴포넌트
- 명확한 관심사 분리

피하기:

- 불필요한 추상화
- 과도한 의존성 추가
- 너무 큰 컴포넌트
- `any` 사용
- 이유 없는 구조 변경

# Neovim 개발 환경

- 코드 수정 시 Neovim 환경을 고려합니다.
- ESLint, Prettier, TypeScript 규칙을 준수합니다.
- 자동 생성 코드라도 프로젝트 기존 스타일을 우선합니다.
