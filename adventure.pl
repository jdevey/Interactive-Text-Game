:- dynamic here/1.
:- dynamic has/1.
:- dynamic location/2.
:- dynamic s/0.

ne(A) :- A \= "".

print_name(A) :- name(A, B), ne(B), write(B), nl, fail.
print_name(_).

print_short_desc(A) :- short_desc(A, B), ne(B), write(B), nl, fail.
print_short_desc(_).

print_long_desc(A) :- long_desc(A, B), ne(B), write(B), nl, fail.
print_long_desc(_).

e(A, B) :- door(A, B).
e(A, B) :- door(B, A).

in(A, B) :- location(A, B).
in(A, B) :- location(C, B), container(C), location(A, C).

takeable(A) :- here(B), location(A, B).
takeable(A) :- here(B), location(C, B), container(C), location(A, C).

pd(A) :- e(A, B), write("  * "), print_name(B), write("      "), print_short_desc(B), nl, fail.
pd(_).

pc(A) :- location(B, A), write("  * "), print_name(B), write("      "), print_short_desc(B), nl, fail.
pc(_).

uc_look(A) :- nl, write("LOCATION:\n  * "), print_name(A), write("      "), print_long_desc(A), write("\nCONNECTED TO:\n"), pd(A), write("CONTENTS:\n"), pc(A), assert(s), fail.
uc_look(_).
look(A) :- assert(s), retractall(s), here(B), (e(A, B); here(A)), uc_look(A), fail.
look(A) :- not(s), write("Look at "), write(A), write(" not allowed.\n\n"), fail.
look(_).

uc_study(A) :- nl, write("OBJECT:\n  * "), print_name(A), write("      "), print_long_desc(A),  write("\nCONTENTS:\n"), pc(A), assert(s), fail.
uc_study(_).
study(A) :- assert(s), retractall(s), here(B), in(A, B), uc_study(A), fail.
study(A) :- not(s), write("Study "), write(A), write(" not allowed.\n\n"), fail.
study(_).

inventory() :- nl, write("INVENTORY:\n"), has(A), write("  * "), print_name(A), fail.
inventory() :- nl.

uc_move(A) :- here(B), retract(here(B)), assert(here(A)), assert(s), fail.
uc_move(A) :- write("Moved to "), write(A), write(".\n\n").
move(A) :- assert(s), retractall(s), here(B), e(B, A), uc_move(A), fail.
move(A) :- not(s), write("Move to "), write(A), write(" not allowed.\n\n"), fail.
move(_).

uc_take(A) :- not(heavy(A)), assert(has(A)), location(A, B), retract(location(A, B)), assert(s), fail.
uc_take(A) :- write("You took "), write(A), write(".\n\n").
take(A) :- assert(s), retractall(s), takeable(A), uc_take(A), fail.
take(A) :- not(s), write("You cannot take "), write(A), write(".\n\n"), fail.
take(_).

uc_put(A, B) :- retract(has(A)), assert(location(A, B)), assert(s), fail.
uc_put(A, B) :- write("You put "), write(A), write(" into "), write(B), write(".\n\n").
put(A, B) :- assert(s), retractall(s), has(A), here(B), uc_put(A, B), fail.
put(A, B) :- not(s), has(A), here(C), location(B, C), uc_put(A, B), fail.
put(A, B) :- not(s), write("Put "), write(A), write(" into "), write(B), write(" not allowed.\n\n"), fail.
put(_, _).

list_found([A | B]) :- has(A), list_found(B).
list_found([]).
list_retract([A | B]) :- retract(has(A)), list_retract(B).
list_retract([]).
uc_make(A) :- assert(has(A)), assert(s), fail.
uc_make(A) :- write("Created "), write(A), write(" successfully.\n\n").
make(A) :- assert(s), retractall(s), create_recipe(B, C, A), equipment(B), here(D), location(B, D), list_found(C), uc_make(A), list_retract(C), fail.
make(A) :- not(s), write("Cannot create "), write(A), write(".\n\n"), fail.
make(_).

win() :- location(small_disk, pylon_c), location(medium_disk, pylon_c), location(large_disk, pylon_c), write("Congrats! You won!\n\n").
valid(A, _) :- A = small_disk.
valid(A, B) :- A = medium_disk, location(small_disk, C), B \= C.
valid(A, B) :- A = large_disk, location(small_disk, C), B \= C, location(medium_disk, D), B \= D.
uc_transfer(A, B) :- location(A, C), retract(location(A, C)), assert(location(A, B)), assert(s), fail.
uc_transfer(A, B) :- write("Moved "), write(A), write(" to "), write(B), write(".\n\n"), win(), fail.
uc_transfer(_, _).
transfer(A, B) :- assert(s), retractall(s), here(secret_lab), valid(A, B), uc_transfer(A, B), fail.
transfer(A, B) :- not(s), write("Cannot move "), write(A), write(" to "), write(B), write(".\n\n"), fail.
transfer(_, _).

here(bedroom).

room(agricultural_science).
room(animal_science).
room(avenue).
room(bedroom).
room(bedroom_closet).
room(chemistry_lab).
room(common_room).
room(computer_lab).
room(elevator).
room(engr).
room(eslc_north).
room(eslc_south).
room(geology_building).
room(green_beam).
room(hall).
room(hub).
room(kitchen).
room(laser_lab).
room(laundry_room).
room(library).
room(observatory).
room(old_main).
room(plaza).
room(quad).
room(roof).
room(roommate_room).
room(secret_lab).
room(ser_1st_floor).
room(ser_2nd_floor).
room(ser_basement).
room(ser_conference).
room(gas_lab).
room(special_collections).
room(tsc_patio).
room(tsc).
room(tunnels_east).
room(tunnels_north).
room(tunnels_west).

door(avenue,quad).
door(bedroom,bedroom_closet).
door(bedroom,hall).
door(eslc_north,chemistry_lab).
door(eslc_north,tsc_patio).
door(eslc_south,eslc_north).
door(hall,common_room).
door(hall,laundry_room).
door(hall,roommate_room).
door(hub,tunnels_west).
door(kitchen,hall).
door(library,plaza).
door(library,special_collections).
door(old_main,computer_lab).
door(plaza,avenue).
door(plaza,common_room).
door(plaza,engr).
door(plaza,ser_1st_floor).
door(quad,agricultural_science).
door(quad,animal_science).
door(quad,eslc_south).
door(quad,geology_building).
door(quad,old_main).
door(quad,tsc_patio).
door(roof,elevator).
door(roof,green_beam).
door(roof,observatory).
door(ser_1st_floor,elevator).
door(ser_2nd_floor,elevator).
door(ser_2nd_floor,ser_conference).
door(ser_basement,elevator).
door(ser_basement,gas_lab).
door(ser_2nd_floor,laser_lab).
door(tsc,hub).
door(tsc_patio,tsc).
door(tunnels_east,ser_1st_floor).
door(tunnels_north,animal_science).
door(tunnels_north,tunnels_west).
door(tunnels_west,secret_lab).
door(tunnels_west,tunnels_east).

location(closet,eslc_south).
location(kitchen_trashcan,kitchen).
location(tower_of_pizza_boxes, kitchen).
location(goggles,closet).
location(note,bedroom).
location(bone,geology_building).
location(book_a,special_collections).
location(book_b,special_collections).
location(book_c,special_collections).
location(bunsen_burner,chemistry_lab).
location(coat,green_beam).
location(combination_gas,ser_conference).
location(dirty_clothes, bedroom_closet).
location(figurine,bedroom).
location(flask,chemistry_lab).
location(fly,roommate_room).
location(key,coat).
location(large_disk,pylon_a).
location(laser,laser_lab).
location(laundry_soap,laundry_room).
location(lost_homework,engr).
location(medium_disk,pylon_a).
location(movie, roomate_room).
location(pylon_a,secret_lab).
location(pylon_b,secret_lab).
location(pylon_c,secret_lab).
location(recipe,book_a).
location(small_disk,pylon_a).
location(kitchen_stove, kitchen).
location(sauce, kitchen).
location(spaghetti, kitchen).
location(wash_machine,laundry_room).

container(closet).
container(kitchen_trashcan).
container(coat).
container(book_a).
container(pylon_a).
container(pylon_b).
container(pylon_c).

equipment(laser).
equipment(kitchen_stove).
equipment(bunsen_burner).
equipment(wash_machine).

create_recipe(kitchen_stove,[spaghetti, sauce], cooked_spaghetti).
create_recipe(laser,[bone],charged_bone).
create_recipe(bunsen_burner,[flask,charged_bone,fly],potion).
create_recipe(wash_machine,[dirty_clothes,laundry_soap],clean_clothes).

heavy(laser).
heavy(bunsen_burner).
heavy(closet).
heavy(pylon_a).
heavy(pylon_b).
heavy(pylon_c).
heavy(kitchen_trashcan).
heavy(small_disk).
heavy(medium_disk).
heavy(large_disk).
heavy(wash_machine).

name(agricultural_science,"Agricultural Sciences Building").
name(animal_science,"Animal Science Building").
name(avenue,"A tree lined avenue").
name(bedroom,"Your bedroom").
name(bedroom_closet, "Your Bedroom's Closet").
name(bone,"large dragon bone").
name(book_a,"Corpus Hermiticum").
name(book_b,"War and Peace").
name(book_c,"Great Expectations").
name(bunsen_burner,"bunsen burner").
name(charged_bone,"charged dragon bone").
name(chemistry_lab,"Student Chemistry Lab").
name(clean_clothes, "Your Clothes").
name(closet,"equipment closet").
name(coat,"Dr. Sundberg's lab coat").
name(combination_gas,"A scrap of paper with a sequence of numbers scribbled on it").
name(common_room,"Dorm common room").
name(computer_lab,"Student Computer Lab").
name(dirty_clothes, "Your Dirty Clothes").
name(elevator,"Elevator").
name(engr,"ENGR - The Main Engineering Building").
name(eslc_north,"Eccels Science Learning Center").
name(eslc_south,"Eccels Science Learning Center").
name(figurine,"alien figurine").
name(flask,"glass flask").
name(fly,"dead fly").
name(gas_lab, "The Get Away Special Lab").
name(geology_building,"Geology Building").
name(goggles,"dark saftey goggles").
name(green_beam,"The 'Grean Beam' enclosure").
name(hall,"Hallway").
name(hub,"The Hub").
name(ice_cream, "Aggie Creamery").
name(key,"key").
name(kitchen,"Kitchen").
name(kitchen_trashcan,"trashcan").
name(large_disk,"large energy disk").
name(laser,"laser array").
name(laser_lab,"Laser Lab").
name(laundry_room,"Laundry Room").
name(laundry_soap,"Laundry Soap").
name(library,"Merill-Caizer Library").
name(lost_homework,"Some student's lost geometry homework.").
name(medium_disk,"medium energy disk").
name(movie, "Men in Black").
name(note,"note").
name(observatory,"Observatory").
name(old_main,"Old Main").
name(plaza,"Engineering plaza").
name(potion,"potion").
name(pylon_a,"red pylon").
name(pylon_b,"blue pylon").
name(pylon_c,"green pylon").
name(quad,"The Quad").
name(recipe,"alchemical recipe").
name(roof,"On the roof of the SER Building").
name(roommate_room,"Your dormmate's room").
name(secret_lab,"Dr. Sundberg's Secret Lab").
name(ser_1st_floor,"1st Floor of SER Building").
name(ser_2nd_floor,"2nd Floor of SER Building").
name(ser_basement,"Basement of the SER Building").
name(ser_conference,"The SER Conference Room").
name(small_disk,"small energy disk").
name(special_collections,"Special Collections Room").
name(tower_of_pizza_boxes,"tower of pizza boxes").
name(tsc,"Taggart Student Center").
name(tsc_patio,"Patio of the TSC").
name(tunnels_east,"Underground Tunnels").
name(tunnels_north,"Underground Tunnels").
name(tunnels_west,"Underground Tunnels").
name(spaghetti, "Spaghetti").
name(sauce, "Marinara Sauce").
name(cheese, "Shredded Cheese").
name(stove, "A Kitchen Stove.").
name(cooked_spaghetti, "Lot's a Spaghetti").
name(wash_machine,"Washing Machine").
name(_,"").


short_desc(agricultural_science,"Looks like a nice place to grab a bite.").
short_desc(animal_science,"a cozy-looking, white-bricked old building.").
short_desc(avenue,"A broad walkway lined with trees.").
short_desc(bedroom,"your bedroom - complete with dirty laundry and heaps of old homework, the sad remains of many hard fought battles waged over Dr. Sundberg's homework").
short_desc(bedroom_closet, "A cozy little room used for storing your valuables").
short_desc(bone,"a large dark bone").
short_desc(book_a,"a copy of 'Corpus Hermiticum' a book on alchemy").
short_desc(book_b,"a copy of 'War and Peace'").
short_desc(book_c,"a copy of 'Great Expectations'").
short_desc(bunsen_burner,"Piece of equipment commonly found in a laboratory.  It produces a single open gas flame.").
short_desc(charged_bone,"A charged piece of 'dragon' bone").
short_desc(chemistry_lab,"A lab with fume hoods and various chemical instuments").
short_desc(clean_clothes, "Clean clothes fresh from the wash").
short_desc(closet,"The equipment closet used to store extra materials for science experiments").
short_desc(coat,"A large white lab coat with lots of pockets").
short_desc(common_room,"A place where students gather for homework, food, and naps").
short_desc(computer_lab,"Many computers lined up together and a desk at the front of the room").
short_desc(dirty_clothes, "Gritty clothes you should probably wash").
short_desc(elevator,"You are in a plain metal box.  There are buttons labeled with various locations.").
short_desc(engr,"A large building with many classrooms, you're surprised to see students wandering the halls at this time.").
short_desc(eslc_north,"You are on the north side of the ESLC.").
short_desc(eslc_south,"You are on the south side of the ESLC.").
short_desc(figurine,"Your roommate's alien figurine sitting atop a shelf.").
short_desc(flask,"a glass flask suitable for mixing reagents").
short_desc(fly,"the partially squished body of a dead house fly").
short_desc(gas_lab, "A place of space research and frendship").
short_desc(geology_building,"Large building with rocks and trees surrounding it").
short_desc(goggles,"dark eye protection left over from the 'Great American Eclipse'").
short_desc(green_beam,"Dr. Sundberg is standing at a large machine which is emitting a bright beam of green light.  You overhear a conversation indicating that he has set up a wormhole generator in his secret lab.  This will allow the alien invasion force to reach earth.").
short_desc(hall,"Long pathway that has pictures hanging on wall").
short_desc(hub,"Smells of coffee and pizza linger in the air. Students congregate around tables slaving away at endless homework.").
short_desc(key,"an ornate key glowing with alien energies").
short_desc(kitchen,"A small room containing the bare essentials, including a leaning tower of pizza boxes").
short_desc(kitchen_trashcan,"This is the trashcan that resides in the kitchen.").
short_desc(large_disk,"a large disk glowing with alien energy").
short_desc(laser,"Pulsating with energy, this laser could be used to imbue something with energy").
short_desc(laser_lab,"Lasers shine in a beautiful array of cornea charing horror, good thing you have goggles on!").
short_desc(laundry_room,"A place for doing laundry").
short_desc(laundry_soap,"Used for washing dirty clothes").
short_desc(library,"Endless floors of books full of knowledge. A smiling librarian greets you as you enter, \"welcome to the library\" she says.").
short_desc(lost_homework,"The abandoned pages call out to a grader, a grader who will never see them.").
short_desc(medium_disk,"a medium sized disk glowing with alien energy").
short_desc(movie, "A movie about policing and monitoring aliens").
short_desc(note,"a handwritten note from your roommate").
short_desc(observatory,"A tower where you can stargaze.").
short_desc(old_main,"The building is full of nerdy looking people.").
short_desc(plaza,"A large open space between engineering buildings").
short_desc(potion,"An oily black potion").
short_desc(pylon_a,"a glowing red pyramid shaped structure").
short_desc(pylon_b,"a glowing blue pyramid shaped structure").
short_desc(pylon_c,"a glowing green pyramid shaped structure").
short_desc(quad,"four large fields split up by sidewalks").
short_desc(recipe,"a page from 'Corpus Hermiticum' containing a recipe for an invisibility potion").
short_desc(roof,"the roof of the dorm building.").
short_desc(roommate_room,"its even messier than your room!").
short_desc(tower_of_pizza_boxes,"A stack of (hopefully) empty pizza boxes").
short_desc(secret_lab,"a secret lab?! This must be where Dr. Sundberg is hiding his secret!").
short_desc(ser_1st_floor,"The bottom floor of the SER building. Nothing too exciting is happening here.").
short_desc(ser_2nd_floor,"The 2nd floor of the SER building. You can see flashing lights near the laser lab room.").
short_desc(ser_basement,"The basement of the SER building.").
short_desc(small_disk,"a small disk glowing with alien energy").
short_desc(special_collections,"the 'special' section of the library. Holds the more important and classical books.").
short_desc(tsc,"community center for students, faculty, and alumni").
short_desc(tsc_patio,"a place to sit an study or eat outside the TSC.").
short_desc(tunnels_east,"The underground tunnels are a confusing place.  I hope you don't get lost.").
short_desc(tunnels_north,"The underground tunnels are a confusing place.  I hope you don't get lost.").
short_desc(tunnels_west,"The underground tunnels are a confusing place.  I hope you don't get lost.").
short_desc(spaghetti, "The food of champions.").
short_desc(sauce, "Rich and flaverfull Marinara Sauce").
short_desc(cheese, "A variety blend of shredded cheese").
short_desc(stove, "A kitchen stove for cooking food.").
short_desc(cooked_spaghetti, "The essence of perfection.").
short_desc(wash_machine,"An old beat up washing machine used for cleaning students' foul smelling clothes").
short_desc(_,"").

long_desc(agricultural_science, "There is a line of students waiting to eat at the cafe. Everyone seems to be in a hurry.").
long_desc(avenue,"A myriad of people walk every which way along the avenue.  All are seemingly unaware of their imminent destruction at Dr.Sundberg's hand.").
long_desc(bedroom,"The college dorm room where you currently reside. These walls have witnessed more late night study sessions than you care to consider. The bed is soaked with the dried tears of uncounted tests failed. Fortunately, the building is aired frequently enough that you can't still smell the years of dirty laundry that have sat in the closet.").
long_desc(bedroom_closet, "Four shelves stand before you, piles of your clothes at your feet, its quiet cramped in here.").
long_desc(bone,"The femur bone from a dragon discovered in the hills of St. Ignatius, Montana.").
long_desc(book_a,"An ancient work on alchemy containing many magical formulae.").
long_desc(book_b,"A seemingly very old copy of War and Peace. A classic story about a Russian family during the invasion of Napoleon Bonaparte.").
long_desc(book_c,"The classic story of an orphan boy named Pip from the marshes of Kent.").
long_desc(bunsen_burner,"A Bunsen burner, named after Robert Bunsen, is a common piece of laboratory equipment that produces a single open gas flame, which is used for heating, sterilization, and combustion.").
long_desc(charged_bone, "A piece of dragon bone imbued with energy from the laser lab.").
long_desc(chemistry_lab,"A laboratory for research in chemistry. You see a few goofy looking students with big green goggles mixing chemicals.").
long_desc(clean_clothes, "These are all you have of value in this world but at least they are clean.").
long_desc(closet,"Amid all the extra equipment and junk in the closet, you notice some saftey goggles that are just your size.").
long_desc(coat,"A spiffy looking lab coat. The pockets are lined with some kind of residue from Dr. Sundberg's experiments. It smells like aliens... Gross!").
long_desc(common_room,"The common room in the SER building. You see a few scattered couches, benches, and tables. It smells like Little Cesears Pizza here...").
long_desc(computer_lab,"The room is filled with the glow and hum of many computers and the feverish typing of college students.").
long_desc(dirty_clothes, "These are all you have of value in this world are these crusted gritty clothes, that need to be washed.").
long_desc(elevator,"A large metal container used to transport people and large objects to different floors in a building.").
long_desc(engr,"There is a display for Orbital ATK and chairs to collapse into after class. You hear your footsteps echoing down the halls as you walk.").
long_desc(eslc_north,"A large open area where you can see chemistry labs , and the doors out to the TSC patio.").
long_desc(eslc_south,"Smaller area lined with classrooms, labs, and closets. You notice a lot of students are wearing lab coats and goggles.").
long_desc(figurine,"Your roommate's alien figurine.  They've been obsessed with aliens since you first met.  You always wondered why, but after reading that note about Dr.Sundberg, it is all beginning to make sense.").
long_desc(flask,"A small container made of glass that is wide at the base and narrow at the neck.  A purple liquid seems to have been left over from a previous experiment.").
long_desc(fly,"Scientifically known as Syrphus Ribessi, this nuisance enjoys long buzzes around human faces and landing on perfectly good food. This particular house fly met an untimely death by squishing.").
long_desc(gas_lab,"Founded in 1976, the Get Away Special team is a student-driven, space research team which has established and upheld Utah State University's reputation as the university that has flown more experiments into space than any other university in the world.").
long_desc(geology_building,"An old looking building that secretly hides the math department. The only reason people want to go in, is to see the large 'dinosaur' bone exhibit they have in there.").
long_desc(goggles,"Specialized Eclipse goggles that allow you to stare at the sun, or intense lasers without going blind.").
long_desc(green_beam,"Dr. Sundberg is standing at a large machine which is emitting a bright beam of green light.  You overhear a conversation indicating that he has set up a wormhole generator in his secret lab.  This will allow the alien invasion force to reach earth.").
long_desc(hall,"A narrow area or passage that connects rooms of an edifice.  The passage is laid with dark red carpeting with pictures hanging on its walls.").
long_desc(hub,"Choose from 9 different areas to eat at while enjoying a large seating area, which is perfect for hanging out and studying.").
long_desc(key,"You feel the alien energy flowing from the key. Could it be? Have you been chosen as the next wielder of the Keyblade? You hold out your hand to the side, but sadly, nothing happens. It's just a normal alien key....").
long_desc(kitchen,"There are an assortment of pots and pans. Someone is cooking your favorite food but it doesn't look like they are going to share.").
long_desc(kitchen_trashcan,"A black, round, plastic container lined with a flexible bag. It's as generic as can be, lacking any logo or branding.").
long_desc(large_disk,"a large disk on the bottom of the red pylon. You worked out today so if there isn't anything on top of it, you could probably move it...").
long_desc(laser,"A rather powerful laser for research. Probably shouldnt look into it.").
long_desc(laser_lab,"You imagine yourself as a secret agent in Mission Impossible flipping and sliding around the room to avoid the lasers... Maybe then you could get a date.").
long_desc(laundry_room,"A dimly lit room that has a musty smell from all the laundry piling up.").
long_desc(laundry_soap,"This soap looks like it has been sitting here for years without being used.").
long_desc(library,"Endless floors of books full of knowledge. A smiling librarian greets you as you enter, 'Welcome to the library!'").
long_desc(lost_homework,"This homework appears to be a geometric proof of the origin of the green beam that is sometimes seen in the sky. The proof shows that the beam originates on the roof of the SER building.").
long_desc(medium_disk,"a medium sized disk in between the small and large disks on the red pylon. It looks like you can move it if there isn't anything on top of it...").
long_desc(movie, "Stars Will Smith and Tommy Lee Jones as members of a secret task force dedicated to protecting earth from alien invaders and earth's inhabitants from any knowledge of aliens. Your dormmate must have been conducting research").
long_desc(note,"In the handwriting of your roommate is hastily scrawled: 'You've got to help.  Dr. Sundberg is an alien and wants to take over the world.  I think he is on to me, you are the only hope left! Try to find out what he is doing with the green beam.'").
long_desc(observatory,"Welcome to the Atmospheric Lidar Observatory. Here you will find information about the 'Green Beam' at Utah State University.").
long_desc(old_main,"The building has four floors, and is the location of much pain during the Evil Dr. Sundber's class.  Few can navigate their way to the 4th floor where dreams become computer programs.").
long_desc(plaza,"A well known spot for Pokemon Go players. It is home to 2 Gyms and 3 pokestops. Terf wars have been known to occur here, so avoid wearing solid blue, yellow or red clothes to avoid potential conflict.").
long_desc(pylon_a,"A red platform with a rod coming out of the middle that comes up to your chest. There are three disks that have been placed here on the rod from smallest to biggest forming a pyramid.").
long_desc(pylon_b,"A blue platform with a rod coming out of the middle that comes up to your chest. It looks like you could put something on the rod...").
long_desc(pylon_c,"A green platform with a rod coming out of the middle that comes up to your chest. It looks like you could put something on the rod...").
long_desc(quad,"A large grass field quarted by concrete sidewalks and bordered by large trees. A favorite destination of students and pets alike. Multiple buildings face into the field, most of them quite historic looking.").
long_desc(recipe,"A potion for invisibility: Bathe the bone of a dragon in pure light.  Distill charged bone with the wings of a fly.  Let cool before quaffing.").
long_desc(roof,"Not a place to be caught in a windstorm - the shingles are slippery and cracked.").
long_desc(roommate_room,"Not quite as messey as yours, your roommate's room has a mini fridge stocked with Dr. Pepper. You see the sun shining through the locked window. ").
long_desc(secret_lab,"You notice your surroundings are almost identical to the cartoon Dexter's laboratory. There are many experiments being done around the room.").
long_desc(ser_1st_floor,"...even though I said nothing exciting happens here, you want to know more? Sorry, I got nothing...").
long_desc(ser_2nd_floor,"The main part of the 2nd floor is the laser lab. The students in there experiment with what they can cut, burn, or imbue with magical energy with lasers.").
long_desc(ser_basement, "Behind every door is another labrotory. The hallways are strewn with machines that appear to belong to a mad scientist although it's probably only Dr. JR Dennison").
long_desc(small_disk,"A small disk pulsates in your hand, glowing an toxic green color as it breathes slowly, a slight warm gasey feel pukes from the disk.").
long_desc(special_collections,"a small section of the library that is home to all sorts of extrordiary books. You can read up on Russian Literature, Classic Dickens, Alchemy, and even more!").
long_desc(tower_of_pizza_boxes,"Domino's, Pizza-Hut, Little Ceaser's and more. All are rendered equal in this towering graveyard of cardboard.").
long_desc(tsc,"This massive building is the perfect place to go to spend way too much money on overpriced things... You'll find students eating, studying, socializing, and lamenting their massive student debts.").
long_desc(tsc_patio,"An open area with birds chirping and hipsters drinking their coffee. You won't find any CS majors here as they're all in cavedwelling in Old Main.").
long_desc(tunnels_east,"The tunnel seems to go on forever. Its dark and you are having a hard time seeing anything. You try to not let your imagination take over as you think you hear someone following you...").
long_desc(tunnels_north,"The tunnel seems to go on forever. Its dark and you are having a hard time seeing anything. You try to not let your imagination take over as you think you hear someone following you...").
long_desc(tunnels_west,"The tunnel seems to go on forever. Its dark but you see what looks like a door off to your right. You try to not let your imagination take over as you think you hear someone following you...").
long_desc(spaghetti, "These long thin pasta noodles are a staple for a student on a budget. So much better than ramen, can be combined with various sauces for maximum effect.").
long_desc(sauce, "Marinara Sauce").
long_desc(cheese, "A combiniation of colby, montery jack, and cheddar cheese.").
long_desc(stove, "A stove splattered with various substances that you assume, or at least hope used was food.").
long_desc(cooked_spaghetti, "Al dente spaghetti dressed up with the best sauce imaginable. If there ever was a reason to save the world, this is it.").
long_desc(wash_machine,"You open the door and to your surprise the washing machine is empty and available to use. You shut the door again.").
long_desc(_,"").

puzzle(laser_lab):-has(goggles),!.
puzzle(laser_lab):-write("It is too dangerous to go in without eye protection."),nl,!,fail.
puzzle(secret_lab):-has(key),!.
puzzle(secret_lab):-write("The door is locked, so you can't get in"),nl,!,fail.
puzzle(gas_lab):-has(combination_gas),!.
puzzle(gas_lab):-write("The light's are off and the door is locked. There must not be any friends in the GAS Lab right now, you need the combination to unlock the door").
puzzle(green_beam):-has(potion),write("You quaff some potion so that Dr. Sundberg can't see you."),nl.
puzzle(green_beam):-write("Dr. Sundberg escorts you out saying 'Sorry, this is a restricted area'."),nl,!,fail.
puzzle(_).

read_words(W):-read_string(user_input,"\n\r","\n\r",_,L),split_string(L,"\t ","\t ",W).
