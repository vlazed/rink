local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DevPackages = ReplicatedStorage.DevPackages
local JestGlobals = require(DevPackages.JestGlobals)

local pink = require(script.Parent.Parent.pink)

local it = JestGlobals.it
local expect = JestGlobals.expect
local describe = JestGlobals.describe

describe("read Simple", function()
	local path = "/ReplicatedStorage/InkLua/__tests__/Simple"

	-- Gotcha: possibly for Roblox, pink trims the last string. Might be a mistake as the length of a string shouldn't be trimmed at the end
	it("prints every line in simple", function()
		expect(pink(path).continue()).toEqual(
			"Hello, i am a movie fan\nGuess my favorite movie\nNo worries, ill guess for you\nAE AR EE MOO VEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE Arc 1: LOOO psees revenge"
		)
	end)
end)

describe("read Dialogue1", function()
	local path = "/ReplicatedStorage/InkLua/__tests__/Dialogue1"
	it("gets the story from Dialogue1", function()
		expect(pink(path)).toBeDefined()
	end)

	it("expects the story from Dialogue1 to be filled", function()
		expect(pink(path)).toHaveProperty("canContinue")
	end)

	it("should be able to continue before reading the first line of dialogue", function()
		local story = pink(path)
		expect(story.canContinue).toBe(true)
	end)

	it("should not continue after reading the first dialogue because of choices", function()
		local story = pink(path)
		story.continue()
		expect(story.canContinue).toBe(false)
	end)

	it("should have choices after reading the first line of dialogue", function()
		local story = pink(path)
		story.continue()
		expect(#story.currentChoices).toBeGreaterThan(0)
	end)

	it("expects the first choice text to remain preserved after parsing", function()
		local story = pink(path)
		story.continue()
		expect(story.currentChoices[1].text).toEqual("Im A fLyInG LoTuS lIkE u")
	end)

	-- Gotcha: After continuing, the option and the response is attached together.
	it("chooses the first choice and shows it on the next line", function()
		local story = pink(path)
		story.continue()
		story.chooseChoiceIndex(1)
		expect(story.continue()).toEqual("Im A fLyInG LoTuS lIkE u\nlLeW sA sUtOl GnIyLf Mi LoL")
	end)

	-- Gotcha: Suppress dialogue option with [] (e.g. * [option]). This prevents the character from `repeating` your dialogue
	it("chooses the third choice and only shows the response", function()
		local story = pink(path)
		story.continue()
		story.chooseChoiceIndex(3)
		expect(story.continue()).toEqual("promotional of the BEST nightmare fuel: AREVERSE")
	end)

	-- FIXME: Test should pass
	-- it("expects nonexistent choices to throw an error (attempt to index nil with option)", function()
	-- 	local story = pink(path)
	-- 	story.continue()
	-- 	expect(story.chooseChoiceIndex(7)).toThrow("attempt to index nil with 'option'")
	-- end)

	it("expects an empty string when -> END is called", function()
		local story = pink(path)
		story.continue()
		story.chooseChoiceIndex(1)
		story.continue()
		expect(story.continue()).toEqual("")
	end)

	-- Gotcha: The response is defined as the text after the option. It also includes other lines
	-- Dialogue box would need to keep track of each line and advance when needed (automatically or manual input)
	it("expects the second choice (which has a tag) to only print the text", function()
		local story = pink(path)
		story.continue()
		story.chooseChoiceIndex(2)
		expect(story.continue()).toEqual(
			"Your art sucks and it smells bad also get clothe\nmy art doesnt sweat like a keyboard warrior, put some cologne on bimbo\nooooooooh\nthats some stank ahh warriah smell (SAWS)"
		)
	end)

	it("expects dialogue to move to the gmodworkflow knot and then immediately show the choices again", function()
		local story = pink(path)
		story.continue()
		story.chooseChoiceIndex(5)
		expect(story.continue()).toEqual(
			"my three mental cpus find gud idea and make it in gmod\ngmod has many assets such as nintendo and 🤢🤮 trippers"
		)
		expect(story.canContinue).toEqual(false)
	end)

	-- Gotcha: Choices are removed after selection in the story.
	it("expects a choice to be removed after selection", function()
		local story = pink(path)
		story.continue() -- to choices
		local currentChoices = #story.currentChoices
		story.chooseChoiceIndex(3) -- select choice 3
		story.continue() -- print response and then show choices again
		expect(#story.currentChoices).never.toEqual(currentChoices)
	end)
end)
