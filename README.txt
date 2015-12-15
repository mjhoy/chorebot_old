* Omega Chore Bot

A simple bot that divvies up chores and sends out emails.

** What it does

Once a week, the omega chore bot will look at a list of chores and
decide what needs to be done. A chore might be required once a week,
or once every two weeks, or once every month, and so on.

The chores for the week then get divvied up among a group of
chore-doers. This happens randomly. Each chore has a certain
difficulty level, and the bot tries to account for this and balance
the chores everyone gets.

There are some additional tweaks the bot makes:

- Some chores might have permanent assignments, so they will always go
  to the same chore-doer.

- A chore-doer might veto a certain chore, so they are never assigned
  to it.

- Ideally, chore-doers are not assigned the same chore twice in a row.

- The list of chores and chore-dores is flexible. If someone is away
  on vacation, they should be temporarily removed from
  consideration. The list of chores may easily be added to or
  adjusted, and the bot will incorporate these changes into next
  week's calculations.

** Defining chores

A list of chores is defined in chores.txt. A chore is defined in a
special format, separated by a newline from other chores. The basic
format is:

[Chore title]: [Interval] [Difficulty]
[Description]

For instance,

  Third floor bathroom: 1 Hard
  Clean and scrub tub/shower/sink to remove grime, clean toilet bowl,
  sweep and mop floors, clean countertop, clean mirror, change towels
  and floor mats, replenish TP and soap as needed.

The description is optional.

The interval is the number of weeks until a chore is repeated. "1"
means the chore is repeated every week, "2" every other week, and so
on.

The difficulty is the word "Hard", "Medium" or "Easy". The exact
calculation may be adjusted, but it should be something like: one hard
chore is worth slightly less than two medium chores, and one medium
chore is worth two easy chores.

You can copy the `chores.example.txt' file to use as a start for
`chores.txt'.

** Defining chore-doers

The chore-doers are defined in a "doers.txt" file, with a special
format, separated by newlines:

[Name] <[email]>
Absent: [Date 1], [Date 2], [...]
Assigned: [Chore 1], [Chore 2], [...]
Veto: [Chore 1], [Chore 2], [...]

The three lines starting with Absent, Assigned and Vetoes are
optional.

For instance,

  Joey Bob <joey@foo.com>
  Absent: 12/12/15
  Assigned: President
  Veto: Third floor bathroom, Mop kitchen

The Absent: line defines dates for which the chore-doer should be
removed from the chore assignments. This date should fall on the day
that the chore bot runs; for instance, if the chore bots runs every
monday, this date should be the monday of the week during which the
chore-doer is absent.

The Assigned: line establishes chores that are permanently assigned to
this chore-doer. Above Joey will be permanently assigned the
"President" chore.

The Veto: line lists chores for which this chore-doer will never be
assigned. It should either match the chore title exactly
(case-insensitive) or, if it includes an asterisk at the end, it will
be used as a pattern to match chores. For instance, "vaccuum*" would
match any chore with "vaccuum" present in the title.

In a list of dates or chores, the items should be separated by commas.

** The chore log

The chore bot runs once a week and must maintain some state about
which chores have been assigned. The bot will log to a file
"assignments.txt" in the format:

Week [Week #]
[Chore 1]: [Doer]
[Chore 2]: [Doer]
[...]
Absent: [Doer 1], [Doer 2], [...]

This file will be written to whenever the chore bot runs and sends
assignment emails. The most recent week will be added to the top of
the file.

The week numbers are simply incrementing integers starting at 1 from
whenever the bot first runs.
