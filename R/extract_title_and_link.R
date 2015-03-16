
extract_title_and_link <- function(main_page_link, dictionary, how_many){
   
   page_link <- html(main_page_link)
   link_and_title <- html_nodes(page_link, "a")
   
   links <- html_attr(link_and_title, name="href")
   titles <- html_text(link_and_title)
   
   which_contain_dictionary <- lapply(lapply(stri_extract_all_words(titles), stri_trans_tolower), function(x){
      sum((x %in% dictionary)) >= how_many
   })
   
   titles_dictionary <- titles[which(unlist(which_contain_dictionary)==1)]
   links_dictionary <- unlist(links[which(unlist(which_contain_dictionary)==1)])
   
   correct_links_dictionary <- unlist(stri_extract_all_regex(links_dictionary, "[h][t][t][p].+"))
   
   if(length(correct_links_dictionary)==0 || is.null(correct_links_dictionary) || is.na(correct_links_dictionary)){
      c("There isn't any correct link!")
   } else {
      correct_links_dictionary <- na.omit(correct_links_dictionary)
      correct_titles_dictionary <- titles_dictionary[links_dictionary %in% correct_links_dictionary]
      data.frame(TITLE=correct_titles_dictionary, LINK=correct_links_dictionary)
   }
}

# # example:
# 
# dic <- c("bronisław", "komorowski",
#          "andrzej", "duda",
#          "magdalena", "ogórek")
# onet <- "http://www.onet.pl/"
# table <- extract_title_and_link(onet, dic, 2)
