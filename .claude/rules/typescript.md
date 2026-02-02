# TypeScript Patterns

## Type Definitions

```typescript
// Simple aliases - 'type'
type Vector2 = { x: number; y: number };
type Props = { name: string };

// Object contracts - 'interface'
interface Config {
  speed: number;
  damage: number;
}

// Config objects - 'as const satisfies'
export const WEAPON = {
  speed: 200,
  damage: 10,
} as const satisfies Config;

// Extract types from implementations
type ConfigKey = keyof typeof WEAPON;
export type UseFeature = ReturnType<typeof useFeature>;
```

## Type Imports

```typescript
import type { Vector2 } from './types';
import { Component } from './component';
```

## No `any` Types

**Rule**: `any` is forbidden except in rare cases with documented justification.

```typescript
// ❌ BAD - Lazy typing
const data: any = fetchData();

// ✅ GOOD - Proper typing
const data: UserData = fetchData();

// ⚠️ ALLOWED - With explanation
// Using any because third-party lib has incorrect types
// and we need to access undocumented property for workaround
const widget: any = createWidget();
widget._internalMethod();
```

**Alternatives to `any`:**
- `unknown` - for truly unknown data (forces type checking)
- Generic types - `<T>` for flexible but type-safe code
- Union types - `string | number` for known variants
- Type guards - narrow `unknown` to specific types
