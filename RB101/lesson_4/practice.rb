munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

munsters.each do | name, bio |
  case bio["age"]
  when 0..17
    bio["age_group"] = "kid"
  when 18..64
    bio["age_group"] = "adult"
  else
    bio["age_group"] = "senior"
  end
end

p munsters

# Output: modified hash
# { "Herman" => { "age" => 32, "gender" => "male", "age_group" => "adult" },
#   "Lily" => {"age" => 30, "gender" => "female", "age_group" => "adult" },
#   "Grandpa" => { "age" => 402, "gender" => "male", "age_group" => "senior" },
#   "Eddie" => { "age" => 10, "gender" => "male", "age_group" => "kid" },
#   "Marilyn" => { "age" => 23, "gender" => "female", "age_group" => "adult" } }


# Algorithm
# - Iterate over each hash in munsters
# - Insert a new hash into the nested hash
# - The new hash should have key "age_group" and value should be determined by age
  # - If age <= 17, then kids
  # - If age 18..64 then adults
  # - If age > 65, then senior