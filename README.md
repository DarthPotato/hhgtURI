# The Hitchhiker's Guide to URI — source repo

Markdown is the book. InDesign is the layout. Nothing else is authoritative.

**Rule 1:** corrections happen in the markdown, never in InDesign.
**Rule 2:** never edit files on github.com. GitHub only ever receives.

## How the pieces connect

    PHONE                          DESKTOP
    personal vault                 uri-guide vault (this folder)
    └─ URI Inbox/  ──Obsidian──►   └─ _inbox/ ──you sort──► entries/
       notes, photos    Sync            ▲                      │
                                   ./intake.sh            ./build.sh
                                                               ▼
                                              layout/icml ──► InDesign
                                                    │
                                             git push ──► GitHub

Two scripts, two jobs. `intake.sh` reaches into your personal vault, so it
only runs when you ask it to. `build.sh` never leaves this folder.

The phone is for capture. The desk is for writing. This vault never touches
Obsidian Sync and never goes on the phone. Read drafts on your phone through
github.com if you need to; fix them at the desk.

## Setup (Windows desktop, once)

1. Install Git for Windows (includes Git Bash) and pandoc:
   `winget install Git.Git` and `winget install JohnMacFarlane.Pandoc`
2. Put this folder anywhere that isn't inside your personal vault.
   Obsidian → Open folder as vault → this folder. Attachment location and
   template folder are already set.
3. Settings → Core plugins → Templates: on. Give "Insert template" a hotkey.
4. Community plugins → install Dataview. Open `_meta/dashboard.md`.
5. Make an empty private repo on GitHub. In Git Bash, inside this folder:

        git init -b main
        git add . && git commit -m "scaffold"
        git remote add origin https://github.com/YOU/uri-guide.git
        git push -u origin main

   The first push opens a browser to log in. After that it remembers.
6. Copy `intake.conf.example` to `intake.conf` and put in your personal
   vault's path. In your personal vault, make a folder called `URI Inbox`.

Optional: community plugin **Git** in this vault for automatic backup every
10 minutes. Leave its pull options off.

## Daily loop

- **On the phone:** drop notes and photos into `URI Inbox` in your personal
  vault. Don't worry about format. It's raw material.
- **Sorting captures:** `./intake.sh` moves everything from `URI Inbox` into
  `_inbox/`, photos included, wherever your personal vault stored them. It
  checks everything before moving anything; a note whose photos are missing
  or ambiguous stays put, with the reason printed. Then sort `_inbox/` into
  entries, interview notes, or the trash. The dashboard shows what's waiting.
- **Laying out:** `./build.sh` converts every entry to ICML, lists every open
  source tag, and commits and pushes to GitHub (`NO_PUSH=1 ./build.sh` to
  skip the push).
- In InDesign, update the out-of-date links (yellow triangle, Links panel).

## Writing

- New entry: new file in the right `entries/` folder, template hotkey, `entry`.
- Photos: paste them in. They save to an `attachments/` folder beside the entry.
- Cross-refs: `[[wifi|The WiFi]]` arrives in InDesign as `→ The WiFi`.
- `flow: flowing` can run onto the next page; `flow: composed` has a fixed
  space and gets cut to fit.

## Folders

    entries/      the book, one file per entry; photos in each attachments/
    _inbox/       phone captures waiting to be sorted
    interviews/   raw transcripts, one per source
    assets/       maps, scans; originals/ is local-only
    layout/       .indd lives here; layout/icml/ is generated, not tracked
    _templates/   entry + interview boilerplate
    _meta/        dashboard, intake pipeline, image rights log
    styles/       markdown → InDesign style name map
    filters/      pandoc filter: photo markers + cross-refs
