Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
	Movie.create!(movie)
  end
end


Then /^(?:|the) director of "([^"]*)" should be "([^"]*)"$/ do |movie_name, director_name|
    page.find(:xpath,'//li', :text => director_name).text.should match Movie.find_by_title(movie_name).director
end 


