# Deploying `widgetbook/` to Vercel

This repo is a monorepo (`app/`, `packages/design_system/`, `widgetbook/`,
`tokens/`), so the Vercel project must be scoped to this directory. This
should be a **separate Vercel project** from the one used for `app/` — the
component catalog and the app ship as two independent sites (two URLs), even
though they live in the same repo.

## Vercel project settings (dashboard, one-time)

1. **Root Directory**: set to `widgetbook` (Project Settings → General →
   Root Directory → Edit → select `widgetbook`). This is required — it
   cannot be set via `vercel.json`. With Root Directory set, Vercel still
   checks out the whole repo, but runs the install/build commands from
   inside `widgetbook/`, so the `../packages/design_system` path dependency
   in `pubspec.yaml` still resolves correctly.
2. **Framework Preset**: `Other` (already set via `"framework": null` in
   `widgetbook/vercel.json`).
3. Leave Build Command / Output Directory / Install Command as **Vercel
   project settings default** — they're defined in `widgetbook/vercel.json`
   and Vercel reads that file automatically once Root Directory is
   `widgetbook`.

## What happens on each build

`vercel.json` points `buildCommand` at `vercel-build.sh`, which:

1. Downloads a pinned Flutter SDK (matching the version used in local/CI
   development) directly from `storage.googleapis.com` — no Flutter buildpack
   exists on Vercel, so this step is what makes the build possible at all.
2. Marks the extracted SDK as a safe git directory
   (`git config --global --add safe.directory`). This is needed because
   Vercel's build image runs as a different user than the one that owns the
   checkout, so git refuses to operate inside the extracted SDK ("detected
   dubious ownership") otherwise — the same failure hit on the `app/`
   deploy, fixed here up front.
3. Runs `flutter pub get` and `flutter build web --release`.
4. Vercel serves the resulting `build/web` directory (set as
   `outputDirectory`), with a SPA rewrite so deep links fall back to
   `index.html`.

To bump the Flutter version used on Vercel, edit `FLUTTER_VERSION` at the top
of `vercel-build.sh` (keep it in sync with the SDK version used for local
development and with `app/vercel-build.sh` to avoid drift).

## Connecting the repo

In the Vercel dashboard: **Add New → Project → Import** the
`sanketp45/Meditation-app` GitHub repo again (as a second, distinct
project), then apply the Root Directory setting above before the first
deploy. Every push to the connected branch triggers a rebuild.
