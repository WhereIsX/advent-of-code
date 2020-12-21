require "./input_21.cr"

ex = "
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
"

def parse(puzzle)
  puzzle.split("\n", remove_empty: true).map do |line|
    ingredients, allergens = line.split(" (contains ")

    {ingredients.split(" "), allergens.chomp(")").split(", ")} 
  end 
  # => [{[]Recipe, "allergen"}] 
end 

def solve_part_1(puzzle)
  recipe_list = parse(puzzle)
  allergen_recipe_map = make_allergen_recipe_map(recipe_list) 

  allergenic_ingredients = Hash(String, Array(String)).new
  allergen_recipe_map.each do |allergen, recipes|
    allergenic_ingredients[allergen] = recipes.reduce{ |final_bawss, recipe| final_bawss & recipe }
  end 
  
  recipes = recipe_list.map{ |(ingredients, allergens)| ingredients }.flatten
  non_allergenic_ingredients = allergen_recipe_map.values.flatten.to_set - allergenic_ingredients.values.flatten.to_set
  return recipes.count{ |ingredient| non_allergenic_ingredients.includes?(ingredient) }
end 

def make_allergen_recipe_map(recipe_list)
  allergen_recipe_map = Hash(String, Array(Array(String))).new do |hash, key|
    hash[key] = Array(Array(String)).new
  end
  
  recipe_list.each do |recipe|
    ingredients, allergens = recipe
    allergens.each do |allergen|
      allergen_recipe_map[allergen].push ingredients
    end 
  end
  return allergen_recipe_map # {"dairy" => [Recipe1, Recipe2, ...]}
end

def solve_part_2(puzzle)
  recipe_list = parse(puzzle)
  allergen_recipe_map = make_allergen_recipe_map(recipe_list) 

  allergenic_ingredients = Hash(String, Array(String)).new
  allergen_recipe_map.each do |allergen, recipes|
    allergenic_ingredients[allergen] = recipes.reduce{ |final_bawss, recipe| final_bawss & recipe }
  end 

  return map_allergen_to_native_lang(allergenic_ingredients).sort.map(&.last.first).join(",")

end 

def map_allergen_to_native_lang(allergenic_ingredients)
  allergens_names = Array(Tuple(String, Array(String))).new
  
  next_allergen = allergenic_ingredients.find{ |_, ingredients| ingredients.size == 1 }
  # next_allergen == {"nuts" => ["spl"]}
  until next_allergen.nil? 
    name_in_native_lang = next_allergen.last.first
    allergens_names.push next_allergen.clone
    allergenic_ingredients.each do |_, potential_names| 
      potential_names.delete(name_in_native_lang)
    end 
    next_allergen = allergenic_ingredients.find{ |_, ingredients| ingredients.size == 1 }
  end 
  return allergens_names
end 

p! solve_part_2(INPUT)