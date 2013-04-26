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

		local level2Katas = {}
		local level2 = LevelVO:new("Level 2", "Try New Things", level2Katas)
		self:addKata(level2Katas, "Chef In Training 1",
									"Have you ever cooked a non-frozen meal in the microwave?",
									"Cook 1 part of a meal using a microwave. Frozen meals don't count, but frozen ingredients are ok.",
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
		local k = 1
		local levels = self.levels
		while levels[i] do
			local level = levels[i]
			local katas = level.katas
			local levelMemento = {}
			levelMemento.katas = {}
			table.insert(memento.levels, levelMemento)
			while katas[k] do
				local kata = katas[k]
				table.insert(levelMemento.katas, {name=kata.name, complete=kata.complete})
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



	return model

end

return ProgressModel