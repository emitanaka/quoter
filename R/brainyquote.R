bq_topic_max_pages <- function(topic, check_online = FALSE) {
  if(topic == "all") topic <- bq_topics("all", check_online = check_online)
  if(check_online) {
    return(sapply(topic, find_max_page))
  } else {
    all_topics <-
      c(age = 39, alone = 39, amazing = 39, anger = 35, anniversary = 7,
        architecture = 31, art = 39, attitude = 39, beauty = 39, best = 39,
        birthday = 22, brainy = 9, business = 39, car = 39, chance = 39,
        change = 39, christmas = 39, communication = 34, computers = 29,
        cool = 39, courage = 39, dad = 39, dating = 22, death = 39, design = 39,
        diet = 36, dreams = 39, easter = 4, education = 39, environmental = 28,
        equality = 31, experience = 39, experience = 39, failure = 39,
        faith = 39, family = 39, famous = 39, fathersday = 3, fear = 39,
        finance = 20, fitness = 19, food = 39, forgiveness = 15, freedom = 39,
        friendship = 31, funny = 39, future = 39, gardening = 8, god = 39,
        good = 39, government = 39, graduation = 9, great = 39, happiness = 39,
        health = 39, history = 39, home = 39, hope = 39, humor = 39,
        imagination = 39, independence = 26, inspirational = 17, intelligence = 39,
        jealousy = 8, jealousy = 8, knowledge = 39, leadership = 39,
        learning = 39, legal = 38, life = 39, love = 39, marriage = 39,
        medical = 36, memorialday = 2, men = 39, mom = 39, money = 39,
        morning = 39, mothersday = 2, motivational = 10, movies = 39,
        movingon = 8, music = 39, nature = 39, newyears = 3, parenting = 16,
        patience = 21, patriotism = 13, peace = 39, pet = 14, poetry = 39,
        politics = 39, positive = 39, power = 39, relationship = 39,
        religion = 39, religion = 39, respect = 39, romantic = 39, sad = 39,
        saintpatricksday = 2, science = 39, smile = 34, society = 39,
        space = 39, sports = 39, strength = 39, success = 39, sympathy = 14,
        teacher = 39, technology = 39, teen = 18, thankful = 21, thanksgiving = 8,
        time = 39, travel = 39, trust = 39, truth = 39, valentinesday = 6,
        veteransday = 2, war = 39, wedding = 19, wisdom = 39, women = 39,
        work = 39)
    all_topics[topic]
  }
}

bq_topics <- function(which = c("top10", "all"), check_online = FALSE) {
  top10 <- c("motivational", "nature", "inspirational", "life", "funny",
             "positive", "sad", "love", "dreams", "work")
  which <- which[1]
  if(which == "top10") return(top10)
  if(which == "all") {
    if(check_online) {
      # a bit slow
      all_topics <- html_session("https://www.brainyquote.com/topics")
      all_topics <- html_nodes(all_topics, ".topicIndexChicklet")
      all_topics <- html_attr(all_topics, "href")
      all_topics <- gsub("/topics/", "", all_topics)
    } else {
      # checked on 2019/07/28
      all_topics <- c("age", "alone", "amazing", "anger", "anniversary", "architecture",
        "art", "attitude", "beauty", "best", "birthday", "brainy", "business",
        "car", "chance", "change", "christmas", "communication", "computers",
        "cool", "courage", "dad", "dating", "death", "design", "diet",
        "dreams", "easter", "education", "environmental", "equality",
        "experience", "experience", "failure", "faith", "family", "famous",
        "fathersday", "fear", "finance", "fitness", "food", "forgiveness",
        "freedom", "friendship", "funny", "future", "gardening", "god",
        "good", "government", "graduation", "great", "happiness", "health",
        "history", "home", "hope", "humor", "imagination", "independence",
        "inspirational", "intelligence", "jealousy", "jealousy", "knowledge",
        "leadership", "learning", "legal", "life", "love", "marriage",
        "medical", "memorialday", "men", "mom", "money", "morning", "mothersday",
        "motivational", "movies", "movingon", "music", "nature", "newyears",
        "parenting", "patience", "patriotism", "peace", "pet", "poetry",
        "politics", "positive", "power", "relationship", "religion",
        "religion", "respect", "romantic", "sad", "saintpatricksday",
        "science", "smile", "society", "space", "sports", "strength",
        "success", "sympathy", "teacher", "technology", "teen", "thankful",
        "thanksgiving", "time", "travel", "trust", "truth", "valentinesday",
        "veteransday", "war", "wedding", "wisdom", "women", "work")
    }
    return(all_topics)
  }
}


get_bq_page_no <- function(bq_url, page_sep = "_") {
  sec <- tail(str_split(bq_url, "/")[[1]], 1)
  as.integer(tail(str_split(sec, page_sep)[[1]], 1))
}

get_next_url <- function(bq_url) {
  out <- xml2::read_html(bq_url)
  out <- html_node(out, css = "link[rel='next']")
  html_attr(out, "href")
}

find_max_page <- function(topic, page_jump = 15,
                          base_url = "https://www.brainyquote.com",
                          page_sep = "_", page_start = 1
                          ) {
  curr_url <- paste0(base_url, topic)
  next_url <- get_next_url(curr_url)
  next_page_no <- get_bq_page_no(next_url, page_sep)
  curr_page_no <- page_start
  while(!is.na(next_page_no)) {
    # jump by 15 pages first and half jump if it goes over
    curr_page_no <- curr_page_no + page_jump
    curr_url <- paste0(base_url, topic, page_sep, curr_page_no)
    next_url <- get_next_url(curr_url)
    next_page_no <- get_bq_page_no(next_url, page_sep)
    # if it goes over it will go back to initial page so next index will be 2
    # redo above starting with half the page jump
    if(!is.na(next_page_no) && next_page_no == 2 && page_jump != 1) {
      curr_page_no <- curr_page_no - page_jump
      page_jump <- round(page_jump / 2)
    }
  }
  curr_page_no
}

#' Get brainy quote
bq_get_quote <- function(topic = NULL, check_online = FALSE, page_sep = "_") {
  # if null get top 10 topics
  if(is.null(topic)) {
    atopic <- tolower(sample(bq_topics(), 1))
  } else {
    atopic <- tolower(sample(topic, 1))
  }

  # maximum page only found by visitng page
  # first check there is more than 1 page
  base_url <- "https://www.brainyquote.com/topics/"
  # online takes too long
  max_page <- bq_topic_max_pages(atopic, check_online = check_online)
  apage <- sample(1L:max_page, 1)
  quotes <- xml2::read_html(paste0(base_url, atopic, page_sep, apage))
  quotes <- rvest::html_nodes(quotes, ".clearfix")
  display_quote <- sample(quotes, 1)
  text <- rvest::html_nodes(display_quote, ".b-qt")
  text <- rvest::html_text(text)
  source <- rvest::html_nodes(display_quote, ".bq-aut")
  source <- rvest::html_text(source)

  quote <- data.frame(
    topic = atopic,
    text  = text,
    source = source,
    stringsAsFactors = FALSE)
  class(quote) <- c("quote", class(quote))
  quote
}




