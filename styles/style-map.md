# Markdown → InDesign style names

These are the exact style names pandoc 3.x emits, verified by converting a test
entry and reading the ICML. Create styles with these names in InDesign and
placed text lands pre-styled. Don't rename them — rename and the next import
comes in unstyled.

## What pandoc actually generates

| markdown | style name in the ICML |
|---|---|
| `# Title` | `Header1` |
| `## Subhead` | `Header2` |
| plain paragraph | `Paragraph` |
| `::: {custom-style="Deck"}` | `Deck > Paragraph` |
| `::: {custom-style="SidebarBody"}` | `SidebarBody > Paragraph` |
| `::: {custom-style="StatBlock"}` | `StatBlock > Paragraph` |
| `![caption](photo.jpg)` | `PhotoNote > Paragraph` (see Images below) |
| `[[wifi\|The WiFi]]` | character style `XRef`, text `→ The WiFi` |
| `**bold**` | character style `Bold` |
| `*italic*` | character style `Italic` |

Note the `>` — a custom-style div becomes a style *group* named after your
custom style, containing a `Paragraph` style inside it. That's why the body
style is `Paragraph` and your sidebar body is `SidebarBody > Paragraph`.

## Setup, once

1. `./build.sh` on a single entry that uses every construct you plan to use.
2. File → Place that ICML into a scratch InDesign document.
3. Open the Paragraph Styles panel. Every name above will be sitting there,
   unstyled.
4. Style them. Save that document as your template.
5. From then on, every entry you place into a document based on that template
   arrives already formatted.

Add a new `custom-style` later and it shows up unstyled on next import. That's
your cue to define it once. Don't invent new ones casually — each is a design
decision you then owe a style for.

## Images

Tested: pandoc brings photos into InDesign at raw pixel size, anchored inside
the text frame. A phone photo arrives about 56 inches wide and shoves the rest
of the entry into overset. So `filters/photo-markers.lua` swaps every image for
a one-line marker instead:

    PHOTO → rhodywifi-screenshot.png | caption text

Write photos either way in Obsidian — both work:

    ![[photo.png|caption text]]      Obsidian style (what pasting gives you)
    ![caption text](photo.png)       standard markdown

Styled as `PhotoNote > Paragraph` (make it loud — bright color, so you can't
miss one). In InDesign: File → Place the real file from the entry's attachments/ folder into its
own frame, cut the caption out of the marker into a caption frame, delete the
marker. You'd be positioning and cropping every photo by hand anyway.

## Known limits

- Tables convert but come in plain. Style them in InDesign.
- Footnotes convert. Nested lists convert to depth.
