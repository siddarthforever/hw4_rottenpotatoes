Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
	if (movie["director"] == "")
	   movie["director"] = nil
        end
	Movie.create!(movie)
  end
end


Then /^(?:|the) director of "([^"]*)" should be "([^"]*)"$/ do |movie_name, director_name|
    page.find(:xpath,'//li', :text => director_name).text.should match Movie.find_by_title(movie_name).director
end 

####################################################################

####################################################################

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Then /I should see the movies in the order/ do |movies_table|
    expected_order = movies_table.raw.map { |option| option.slice(0..1)}
    actual_order = page.all("table tr").collect{|option| option.text}.map{|actual_order| actual_order.gsub!(/[\n]+/, ",").split(',').slice(0..1)}
    expected_order[1..expected_order.length-1].should == actual_order[1..actual_order.length-1]
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
      rating_list.to_s.split(',').each do |rating|
	step (!uncheck.nil? && "#{uncheck}" <=> "un") ? %Q{I uncheck "ratings[#{rating}]"} :  %Q{I check "ratings[#{rating}]"}
      end
   And %Q{I press "ratings_submit"}
end

Then /I should (not )?see movies with ratings: (.*)/ do |not_check, rating_list|
     rating_list.split(',').each do |rating|
    if (!not_check.nil? && "#{not_check}" <=> "not ") 
	%Q{I should not see "#{rating}"} 
	page.all(:xpath,"//td", :text => /\b#{rating}\b/).count.should == 0
	#page.should_not have_content(/\b#{rating}\b/)
    else
	%Q{I should see "#{rating}"}
    end
 end
     if (not_check.nil? )
       Movie.where("rating in (?)", rating_list.split(",")).count.should == (page.all("table tr").collect{|option| option.text}.map{|actual_order| actual_order.gsub!(/[\n]+/, ",").split(',').slice(0..1)}.count)-1

     end
end


Then /I should (not )?see all of the movies/ do |not_check|
    (!not_check.nil? && "#{not_check}" <=> "not ") ? page.all("table tr").count.should == 1 : page.all("table tr").count.should == (Movie.find(:all).count)+1
end




