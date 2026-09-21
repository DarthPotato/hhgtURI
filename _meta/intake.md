# Intake — where outside material enters the book

Nothing goes from a source straight into an entry. Everything lands here first,
gets triaged, and becomes markdown only once someone (you) has decided it is
true and written it in the book's voice.

## Five streams

1. **Archive** — DigitalCommons@URI (Grist, Good 5¢ Cigar, Beacon, Black Gold,
   Freshman Record, course catalogs, annual reports, URI Photographs and
   Images), the Special Collections timeline, rhodycigar.com. Reading room by
   appointment: archives@uri.edu. Scans land in assets/scans/, citation goes in
   the entry's `sources:` list.
2. **Web** — official URI pages for anything policy, price, or procedure. These
   rot. Date every one in `sources:`.
3. **Interviews** — transcripts in interviews/, one file per source, using
   _templates/interview.md. Attribution recorded exactly as the source gave it.
4. **Public submissions** — Google Form into a private sheet. See below.
5. **Your phone** — notes and photos dropped in the `URI Inbox` folder of your
   personal vault. `./intake.sh` moves them into `_inbox/` here, photos included.
   Sort them into entries, interview notes, or the trash.

## Submission form → sheet → entry

The form is the front door. Keep it to six fields so people finish it:

- What's the tip / story? (long text)
- What is it about? (dropdown: building, club, class or department, campus
  systems, history, other)
- How do you know? (dropdown: happened to me / I saw it / someone told me /
  I read it somewhere)
- Roughly when? (short text)
- How should we credit you? (name / first name + class year / anonymous /
  don't credit at all)
- Email, only if you're OK with follow-up questions (optional)

Sheet gets three columns you add yourself:

- `triage` — new / keep / reject / needs-verify
- `entry` — the slug it became
- `checked` — what you did to confirm it

Rules that keep this from becoming a liability:

- A submission is a lead, not a fact. `how do you know` = "someone told me"
  means it ships as [ORAL — anonymous submission] or not at all.
- Credit exactly as the field says. Never upgrade "anonymous" later because you
  happened to learn who it was.
- Anything naming a living person, or that could get someone in trouble, does
  not get entered in the sheet as a quote. Triage it and delete it.
- Word the form as "things you wish you'd known," not "loopholes." A public
  form soliciting loopholes is a written record of loopholes with your name
  attached to it.
