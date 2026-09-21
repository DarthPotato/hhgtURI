# Dashboard

Needs the Dataview plugin. Only renders inside Obsidian — on GitHub this page
looks like code blocks, which is fine. It's a tool for you, not the book.

## Field values (what to type in each property)

- **section** — survival · buildings · clubs · history · network
- **status** — stub (idea only) · draft (written, has holes) · final (no holes, done)
- **flow** — composed (fixed space, cut to fit) · flowing (can run onto the next page)
- **sources** — one item per source: a URL with the date you checked it, an
  archive citation, or "author, ITS desk shifts"

## Inbox — phone captures waiting to be sorted

```dataview
LIST
FROM "_inbox"
SORT file.ctime ASC
```

Each one becomes part of an entry, an interview note, or gets deleted.

## Everything unfinished

```dataview
TABLE section, status, flow
FROM "entries"
WHERE status != "final"
SORT section ASC, status ASC
```

## Written but no sources listed

```dataview
LIST
FROM "entries"
WHERE status != "stub" AND length(default(sources, [])) = 0
```

## Interviews not yet used

```dataview
TABLE attribution, date, status
FROM "interviews"
WHERE status != "mined"
```

## Holes in the text

Dataview reads the properties at the top of a file, not the writing. For
[NEED SOURCE] markers in the body, run `./build.sh` — it lists every one — or
search `[NEED SOURCE]` in Obsidian's search pane.
