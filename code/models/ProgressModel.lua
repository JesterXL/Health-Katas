require "vo.LevelVO"
require "vo.KataVO"
require "services.ProgressService"

ProgressModel = {}

function ProgressModel:new()

	local model = {}
	model.levels = {}
	model.currentLevel = nil
	model.currentKata = nil
	model.kataLookupHash = nil

	function model:init()
		local level1Katas = {}
		local level1 = LevelVO:new("Level 1", "The Basics", level1Katas)
		self:addKata(level1Katas, "Lesser Evil?", 
									"Do you drink soda or pop?", 
									"Replace 1 of your soft drinks per day with a diet version.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "Baked vs. Fried", 
									"Do you eat potato chips?", 
									"Eat Baked Potato Chips vs. regular chips.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "Smaller Size Me", 
									"Do you eat fast food?", 
									"For 2 consecutive days, order single vs. double (cheese) burger, with medium fries vs. large/super-size, and medium drink vs. large/super.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "Do The Math", 
									"Have you ever counted calories?", 
									"Count your calories for 1 day.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "Go Green", 
									"Do you eat vegatables on a regular basis?", 
									"Eat something green for 3 consecutive days.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "An Apple A Day", 
									"Do you eat apples?", 
									"Eat 1 apple a day for 4 days.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "An Apple A Day", 
									"Do you eat apples?", 
									"Eat 1 apple a day for 4 days.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "Meal Challenge 1", 
									"Have you ever eaten more than 3 meals a day?", 
									"Eat 4 consecutive meals in 1 day.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "Meal Challenge 2", 
									"Have you ever eaten more than 4 meals a day?", 
									"Eat 5 consecutive meals in 1 day.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "Meal Challenge 3", 
									"Have you ever eaten more than 5 meals a day?", 
									"Eat 6 consecutive meals in 1 day.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "Cortisol Killer", 
									"Do you eat in the evening?", 
									"Don't eat 3 hours prior to bed time for 3 days straight.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "Start Your Day Right", 
									"Do you eat breakfast?", 
									"Eat breakfast for 7 consecutive days.",
									"Success!",
									"Already a success!")

		self:addKata(level1Katas, "Cow Fat", 
									"Do you drink D or 2% milk?", 
									"Replace 1 meal with skim milk vs. 2% or D: coffee, cereal, or a drink",
									"Success!",
									"Already a success!")

		local level2Katas = {}
		local level2 = LevelVO:new("Level 2", "Try New Things", level2Katas)
		self:addKata(level2Katas, "Chef In Training 1",
									"Have you ever cooked a non-frozen meal in the microwave?",
									"Cook 1 part of a meal using a microwave. Frozen meals don't count, but frozen ingredients are ok.",
									"Success!",
									"Already a success!")

		self:addKata(level2Katas, "Chef In Training 2",
									"Have you eaten food made in a toaster or oven in the past 2 weeks?",
									"Cook 1 part of a meal using an oven or toaster.",
									"Success!",
									"Already a success!")

		self:addKata(level2Katas, "Chef In Training 3",
									"Have you eaten something heated on your stove top in the past 2 weeks?",
									"Cook 1 part of a meal using a stove top.",
									"Success!",
									"Already a success!")

		self:addKata(level2Katas, "Good Garnish 1",
									"Have you ever eaten sunflower seeds or flax seeds on a meal?",
									"Add 1 of the following on top of something you eat: sunflower or flax seeds.",
									"Success!",
									"Already a success!")

		self:addKata(level2Katas, "Dark Side Rice",
									"Have you ever tried brown rice instead of white rice?",
									"Eat brown rice instead of white race for 1 dish. We suggest using a stove top vs. instant for taste reasons, but whatever is more likely to get you to try it.",
									"Success!",
									"Already a success!")

		self:addKata(level2Katas, "Dark Side Pasta",
									"Have you ever tried whole wheat pasta?",
									"Eat whole wheat pasta instead of enriched flour/multi-grain pasta for 1 dish.",
									"Success!",
									"Already a success!")

		self:addKata(level2Katas, "Dark Side Rice",
									"Have you ever tried brown rice instead of white rice?",
									"Eat brown rice instead of white race for 1 dish. We suggest using a stove top vs. instant for taste reasons, but whatever is more likely to get you to try it.",
									"Success!",
									"Already a success!")

		self:addKata(level2Katas, "Dark Side Bread",
									"Have you ever tried brown rice instead of white rice?",
									"Eat 1 sandwich or bread dish using whole wheat bread (not encroached, not multi-grain).",
									"Success!",
									"Already a success!")

		self:addKata(level2Katas, "Dark Side Tortilla",
									"Have you ever tried brown rice instead of white rice?",
									"Eat a whole wheat tortilla instead of an enriched flour/multi-grain pasta for 1 dish.",
									"Success!",
									"Already a success!")

		self:addKata(level2Katas, "Try Quinoa 1",
									"Have you ever tried Quinoa (pronounced Qween-whaaaaaa)?",
									"Eat 1 entree with boiled quinoa.",
									"Success!",
									"Already a success!")

		self:addKata(level2Katas, "Try Quinoa 2",
									"Have you ever tried Quinoa pasta?",
									"Eat 1 entree with quinoa quinoa.",
									"Success!",
									"Already a success!")

		local level3Katas = {}
		local level3 = LevelVO:new("Level 3", "Vegitarian Path", level3Katas)
		self:addKata(level3Katas, "Where's The Beef?",
									"Have you ever gone without red meat for at least 5 days?",
									"Replace all meat dishes for 5 consecutive days with chicken and/or fish instead.",
									"Success!",
									"Already a success!")

		self:addKata(level3Katas, "Alty Burger 1",
									"Have you every tried a turkey burger?",
									"Try 1 turkey burger.",
									"Success!",
									"Already a success!")

		self:addKata(level3Katas, "Alty Burger 2",
									"Have you every tried a quinoa burger?",
									"Try 1 quinoa burger.",
									"Success!",
									"Already a success!")

		self:addKata(level3Katas, "Alty Dog",
									"Have you every tried a turkey hot dog?",
									"Try 1 turkey hot dog.",
									"Success!",
									"Already a success!")

		self:addKata(level3Katas, "Return of the Meat",
									"Have you ever cooked a lean steak before?",
									"Buy, Cook yourself, and Eat a Lean Steak. Cut off excess fat if any before cooking.",
									"Success!",
									"Already a success!")

		self:addKata(level3Katas, "BBQ",
									"Have you tried chicken BBQ?",
									"Replace 1 meat BBQ meal with a chicken one instead.",
									"Success!",
									"Already a success!")
		local level4Katas = {}
		local level4 = LevelVO:new("Level 4", "Vegan Path", level4Katas)
		self:addKata(level4Katas, "Morning Creamer",
									"Do you drink coffee with milk or creamer?",
									"Replace the creamer in your coffee for 1 day with soy or almond milk.",
									"Success!",
									"Already a success!")

		self:addKata(level4Katas, "Easter Eggs",
									"Do you eat eggs?",
									"Replace 1 helping of eggs for 1 day with a banana and/or sunflower seeds.",
									"Success!",
									"Already a success!")

		self:addKata(level4Katas, "Temporary Tempeh",
									"Have you tried tempeh?",
									"Try Tempeh: Cut into 1/2 inch pieces, sauté with olive oil, soy sauce, or teriyaki sauce and spread onto a bed of greens.",
									"Success!",
									"Already a success!")

		self:addKata(level4Katas, "Meat Fast",
									"Have you gone without meat, and chicken for more than 2 days?",
									"Go without meat, fish, and chicken for 3 consecutive days.",
									"Success!",
									"Already a success!")

		self:addKata(level4Katas, "Animal Fast",
									"Have you gone without eggs and dairy for more than 2 days?",
									"Go without eggs and dairy for 3 consecutive days.",
									"Success!",
									"Already a success!")

		self:addKata(level4Katas, "Protein Addition",
									"Have you ever made a protein shake?",
									"Try a Protein Shake: 1/2 cup of water, 1/2 cup of almond or soy milk, 1 banana, 1/2 cup of blueberries, 1 serving of hemp, brown rice, or soy protein powder, mix in blender. \n\nOther good additions include peanut or almond butter, dried goji berries, and/or cocoa.",
									"Success!",
									"Already a success!")

		self:addKata(level4Katas, "Nut Snack",
									"Do you eat nuts?",
									"Replace 1 snack for a day with nuts of your choice: almond, sunflower, walnuts, or cashews.",
									"Success!",
									"Already a success!")

		self:addKata(level4Katas, "Beans Staple",
									"Have you ever eaten a meal that has beans as the primary staple vs. meat?",
									"Replace 1 dish that has meat/chicken/fish to use black, pinto, or chick peas instead.",
									"Success!",
									"Already a success!")


		table.insert(self.levels, level1)
		table.insert(self.levels, level2)
		table.insert(self.levels, level3)
		table.insert(self.levels, level4)

		self.currentLevel = level1
		self.currentKata = level1.katas[1]
	end

	function model:addKata(list, name, question, info, success, alreadyASuccess)
		local vo = KataVO:new(name, question, info, success, alreadyASuccess)
		table.insert(list, vo)
	end

	function model:saveState()
		local memento = {}
		if self.currentLevel ~= nil then
			memento.currentLevelName = self.currentLevel.name
		end
		if self.currentKata ~= nil then
			memento.currentKataName = self.currentKata.name
		end

		memento.levels = {}

		local i = 1
		local levels = self.levels
		while levels[i] do
			local level = levels[i]
			local katas = level.katas
			local levelMemento = {}
			levelMemento.katas = {}
			table.insert(memento.levels, levelMemento)
			local k = 1
			while katas[k] do
				local kata = katas[k]
				table.insert(levelMemento.katas, {name=kata.name, complete=kata.complete, started=kata.started})
				k = k + 1
			end
			i = i + 1
		end

		local service = ProgressService:new()
		service:saveProgress(memento)
	end

	function model:loadState()
		if self.levels == nil then
			error("No levels found, probably called before init.")
		end

		local service = ProgressService:new()
		local memento = service:loadProgress()
		if memento == nil then
			return false
		end

		if memento.currentLevelName then
			self.currentLevel = self:findLevelByName(memento.currentLevelName)
		end

		if memento.currentKataName then
			self.currentKata = self:findKataByName(memento.currentKataName)
		end

		local l = 1
		local mLevels = memento.levels
		while mLevels[l] do
			local mLevel = mLevels[l]
			local mKatas = mLevel.katas
			local k = 1
			while mKatas[k] do
				local mKata = mKatas[k]
				local foundKata = self:findKataByName(mKata.name)
				if foundKata then
					foundKata.complete = mKata.complete
					foundKata.started = mKata.started
				end
				k = k + 1
			end
			l = l + 1
		end

		if self.currentLevel == nil then
			self.currentLevel = self.levels[1]
			self.currentKata = self.currentLevel.katas[1]
		end

		if self.currentKata == nil then
			self.currentKata = self.currentLevel.katas[1]
		end
	end

	function model:findLevelByName(name)
		assert(name ~= nil, "You cannot pass a nil name.")
		local levels = self.levels
		local i = 1
		while levels[i] do
			local level = levels[i]
			if level.name == name then
				return level
			end
			i = i + 1
		end
		return nil
	end

	function model:findKataByName(name)
		assert(name ~= nil, "You cannot pass a nil name.")

		if self.kataLookupHash == nil then
			self.kataLookupHash = {}
		else
			if self.kataLookupHash[name] ~= nil then
				return self.kataLookupHash[name]
			end
		end

		local levels = self.levels
		local i = 1
		while levels[i] do
			local level = levels[i]
			local katas = level.katas
			local k = 1
			while katas[k] do
				local kata = katas[k]
				self.kataLookupHash[kata.name] = kata
				if kata.name == name then
					return kata
				end
				k = k + 1
			end
			i = i + 1
		end
		return nil
	end

	function model:findIncompleteKata()
		local levels = self.levels
		local l = 1
		while levels[l] do
			local level = levels[l]
			local katas = level.katas
			local k = 1
			while katas[k] do
				local kata = katas[k]
				if kata.complete == false then
					return kata, level
				end
				k = k + 1
			end
			l = l + 1
		end
		return nil
	end

	function model:startKata(kataVO)
		kataVO.started = true
		self:saveState()
		Runtime:dispatchEvent({name="ProgressModel_kataStarted"})
	end

	function model:kataAlreadySuccessful(kataVO)
		kataVO.complete = true
		self:saveState()
		Runtime:dispatchEvent({name="ProgressModel_kataCompleted"})
	end

	function model:kataCompleted(kataVO)
		kataVO.complete = true
		self:saveState()
		Runtime:dispatchEvent({name="ProgressModel_kataCompleted"})
	end

	function model:nextKata()
		local currentKata = self.currentKata
		local currentLevel = self.currentLevel
		local kataIndex = table.indexOf(currentLevel.katas, currentKata)
		kataIndex = kataIndex + 1
		local nextKata = currentLevel.katas[kataIndex]
		if nextKata == nil then
			-- we've gone to a new level
			local levelIndex = table.indexOf(self.levels, currentLevel)
			levelIndex = levelIndex + 1
			local nextLevel = self.levels[levelIndex]
			if nextLevel == nil then
				-- we've run out of levels, let's find a kata that hasn't been completed yet
				local incompleteKata, incompleteKatasLevel = self:findIncompleteKata()
				if incompleteKata == nil then
					-- user has completed all kata's
					self:saveState()
					Runtime:dispatchEvent({name="ProgressModel_allKatasCompleted"})
					return true
				else
					self.currentLevel = incompleteKatasLevel
					self.currentKata = incompleteKata
					self:saveState()
					Runtime:dispatchEvent({name="ProgressModel_currentKataChanged"})
					return true
				end
			else
				-- TODO: they COULD have completed katas in this level, check to see if it's
				-- complete or not
				self.currentLevel = nextLevel
				self.currentKata = nextLevel.katas[1]
				self:saveState()
				Runtime:dispatchEvent({name="ProgressModel_currentKataChanged"})
				return true
			end
		else
			self.currentKata = nextKata
			self:saveState()
			Runtime:dispatchEvent({name="ProgressModel_currentKataChanged"})
			return true
		end
	end

	model:init()

	return model

end

return ProgressModel