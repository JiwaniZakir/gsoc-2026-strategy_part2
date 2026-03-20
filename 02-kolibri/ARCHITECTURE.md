# kolibri — Codebase Architecture

**Repo:** https://github.com/learningequality/kolibri
**Language:** Python (Django) + JavaScript (Vue.js)
**Python:** 3.9+ | **Node:** 16+

---

## Directory Structure

```
kolibri/
├── kolibri/
│   ├── core/                   # Core Django apps
│   │   ├── auth/               # User auth, facility management
│   │   ├── content/            # Content nodes, channels, metadata
│   │   ├── device/             # Device settings, sync
│   │   ├── tasks/              # Async task queue (django-q)
│   │   ├── notifications/      # User notifications
│   │   ├── logger/             # Learning analytics logging
│   │   └── assets/             # Core frontend JS/Vue
│   │       ├── src/
│   │       │   ├── api-resources/      # DRF API resource definitions
│   │       │   ├── composables/        # Vue composables
│   │       │   ├── views/              # Page-level Vue components
│   │       │   └── router/             # Vue Router config
│   │       └── test/                   # Frontend tests (Jest)
│   ├── plugins/
│   │   ├── device/             # Device plugin (settings, import/export)
│   │   │   ├── assets/
│   │   │   │   ├── src/        # Vue components
│   │   │   │   └── test/       # Jest tests ← TARGET FOR MIGRATION
│   │   ├── learn/              # Student learning interface
│   │   ├── facility_management/ # Admin / coach views
│   │   ├── user/               # User profile plugin
│   │   └── html5_app_renderer/ # Renders H5P, EPUB, QTI content
│   └── deployment/             # systemd, nginx, Docker configs
├── packages/
│   ├── kolibri-design-system/  # Shared UI component library (KDS)
│   └── kolibri-tools/          # Build tooling, webpack config
├── docs/
├── integration_testing/        # Playwright E2E tests
├── pytest.ini
├── package.json
└── .github/
    └── workflows/
        ├── tox.yml             # Python CI
        └── node.yml            # JS CI
```

---

## Backend Architecture (Django)

### Django Apps
Each `kolibri/core/<app>/` follows standard Django structure:
```
auth/
├── models.py           # FacilityUser, Facility, Classroom, etc.
├── serializers.py      # DRF serializers
├── api.py              # DRF viewsets
├── urls.py             # URL routing
├── permissions.py      # Custom DRF permissions
└── migrations/         # Django migrations
```

### REST API
- Built with **Django REST Framework**
- API endpoints: `/api/auth/`, `/api/content/`, `/api/device/`, etc.
- Pagination, filtering, and serialization per DRF conventions
- JSON responses only

### Task Queue
- Uses **django-q** for async tasks (content import, sync, etc.)
- Tasks defined in `kolibri/core/tasks/`

### Database
- **SQLite** by default (offline-first design)
- PostgreSQL optional for large deployments
- Migrations managed with Django migrations

---

## Frontend Architecture (Vue.js)

### Component Organization
```
plugins/device/assets/src/
├── views/
│   ├── DeviceSettingsPage.vue
│   ├── ManageContentPage/
│   │   ├── index.vue
│   │   ├── AvailableStorageSlider.vue
│   │   └── ...
│   └── ...
├── api-resources/      # kolibri-public-api resource definitions
└── store/              # Vuex store modules
    ├── index.js
    └── pluginModule.js
```

### Testing Setup
```
plugins/device/assets/test/
├── availableStorageSlider.spec.js
├── deviceSettingsPage.spec.js
├── manageContent.spec.js
└── ...
```

Test runner: **Jest** + **@vue/test-utils** (being migrated to VTL)

### Vue Testing Library Pattern
```javascript
import { render, screen, fireEvent } from '@testing-library/vue'
import { createTestingPinia } from '@pinia/testing'
// or for Vuex:
import Vuex from 'vuex'

render(MyComponent, {
  global: {
    plugins: [store],
    stubs: { RouterLink: true },
  }
})

// Query by role (preferred)
screen.getByRole('button', { name: /import/i })
screen.getByLabelText(/facility name/i)
screen.getByText(/no content available/i)

// Fire events
await fireEvent.click(screen.getByRole('button', { name: /submit/i }))
await fireEvent.change(input, { target: { value: 'new value' } })
```

### i18n Pattern
```javascript
// In Vue SFC:
export default {
  name: 'DeviceSettingsPage',
  $trs: {
    pageTitle: { message: 'Device settings', context: 'Page title' },
  },
}
// Template: <h1>{{ $tr('pageTitle') }}</h1>
```
**Never hardcode user-visible strings — always use `$tr()`.**

---

## Build and Test Commands

```bash
# Backend setup
pip install -e ".[dev]"
python -m kolibri manage migrate
python -m kolibri start --foreground

# Backend tests
pytest kolibri/ -v -q
pytest kolibri/plugins/device/ -v  # device plugin only
pytest kolibri/ -k "test_auth" -v  # filtered

# Frontend setup
cd kolibri/core/assets && yarn install
# (or from root) yarn install

# Frontend tests (all)
yarn run test

# Frontend tests (device plugin only)
yarn workspace @kolibri/plugin-device test

# Frontend linting
yarn run lint

# Build frontend
yarn run build

# Run dev server (hot reload)
yarn run dev
```

---

## Where to Start Contributing

| Goal | File to Read First |
|------|--------------------|
| Vue component test | `kolibri/plugins/device/assets/test/*.spec.js` |
| Add new device setting | `kolibri/plugins/device/assets/src/views/DeviceSettingsPage.vue` |
| REST API change | `kolibri/core/device/api.py` + `serializers.py` |
| New Django model | `kolibri/core/<app>/models.py` + `migrations/` |
| QTI accessibility | `kolibri/plugins/html5_app_renderer/assets/src/` |

---

## QTI Viewer (Issue #14347 Target)

**Location:** `kolibri/plugins/html5_app_renderer/`

QTI (Question and Test Interoperability) is an XML-based format for educational assessments. Kolibri renders QTI content in the browser. The issue is that:
- `ChoiceInteraction` doesn't use proper radio/checkbox roles
- `SimpleChoice` items lack `aria-checked` state
- `TextEntryInteraction` inputs lack `aria-label` or `aria-required`

**Fix approach:**
1. Add `role="radio"` / `role="checkbox"` to choice elements
2. Add `aria-checked` binding to selected state
3. Add `aria-label` derived from prompt text to text inputs
4. Add keyboard event handlers (Space/Enter to select choices)
