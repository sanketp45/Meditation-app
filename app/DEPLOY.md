# Deploying `app/` to Vercel

This repo is a monorepo (`app/`, `packages/design_system/`, `widgetbook/`,
`tokens/`), so the Vercel project must be scoped to this directory.

## Vercel project settings (dashboard, one-time)

1. **Root Directory**: set to `app` (Project Settings → General → Root
   Directory → Edit → select `app`). This is required — it cannot be set via
   `vercel.json`. With Root Directory set, Vercel still checks out the whole
   repo, but runs the install/build commands from inside `app/`, so the
   `../packages/design_system` path dependency in `pubspec.yaml` still
   resolves correctly.
2. **Framework Preset**: `Other` (already set via `"framework": null` in
   `app/vercel.json`).
3. Leave Build Command / Output Directory / Install Command as **Vercel
   project settings default** — they're defined in `app/vercel.json` and
   Vercel reads that file automatically once Root Directory is `app`.

## What happens on each build

`vercel.json` points `buildCommand` at `vercel-build.sh`, which:

1. Downloads a pinned Flutter SDK (matching the version used in local/CI
   development) directly from `storage.googleapis.com` — no Flutter buildpack
   exists on Vercel, so this step is what makes the build possible at all.
2. Runs `flutter pub get` and `flutter build web --release`.
3. Vercel serves the resulting `build/web` directory (set as
   `outputDirectory`), with a SPA rewrite so deep links fall back to
   `index.html`.

To bump the Flutter version used on Vercel, edit `FLUTTER_VERSION` at the top
of `vercel-build.sh` (keep it in sync with the SDK version used for local
development to avoid drift).

## Connecting the repo

In the Vercel dashboard: **Add New → Project → Import** the
`sanketp45/Meditation-app` GitHub repo, then apply the Root Directory setting
above before the first deploy. Every push to the connected branch triggers a
rebuild.
