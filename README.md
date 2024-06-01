# rink

*rink*, an ink parser for Roblox Lua/Luau, which uses [*pink*](https://github.com/premek/pink/tree/main), an ink parser for pure Lua. 

## DISCLAIMER
This parser's behavior is subject to change! *pink* is still WIP, and as such, its derived projects are also WIP.

## Dependencies
- [*import*](https://github.com/vocksel/import) by Vocksel

## Setup

Download the src folder and put it in your folder of choice.

## Usage

```
local getStory = require(path.to.pink)

local storyPath: StringValue = "/ReplicatedStorage/Dialogue/Story"
local story = getStory(storyPath)

story.continue() -- Prints all lines before a choice
story.chooseChoiceIndex(1) -- Choose a choice
story.continue() -- Prints the choice (if not surrounded by square brackets) and all lines after it
... -- Reach the end of the story (-> END or -> DONE in ink file)
story.continue() -- Returns ""
```

## TODOs

- Proper test dialogue using ink test cases
- Publish to wally

## Gotchas

Some of these gotchas reflects the expected behavior as documented in [*Writing With Ink*](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md), while others are incorrect behavior.

- Ink files are `StringValues` in Roblox; they must have the `.txt` extension.
- `story.continue()` returns all lines before selecting an option (incorrect: should return a single line)
- After selecting an option, if the option isn't suppressed (e.g. `[option]`), then story.continue() also prints the option and the lines after it.
- After selecting an option with `story.chooseChoiceIndex(k)`, the choice is removed from `story.currentChoices`.
- pink trims the last character on the last line, which can result in some unexpected behavior. I recommend adding an empty line in your ink file.
