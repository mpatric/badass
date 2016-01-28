module HomeHelper
  def home_paginate(collection)
    current_page = collection.current_page
    total_pages = collection.total_pages
    links = []
    if current_page > 1
      links << "<span class='newer-posts'>" + link_to("Newer posts", home_url({'page' => current_page - 1})) + "</span>"
    end
    if current_page < total_pages
      links << "<span class='older-posts'>" + link_to("Older posts", home_url({'page' => current_page + 1})) + "</span>"
    end
    links << "<span class='post-pages'>" + "Page #{current_page} of #{total_pages}" + "</span>"
    links.join.html_safe
  end
  
  def home_url(params={})
    url = request.fullpath
    params.keys.each do |param|
      url.scan(/[?&]?(#{param}=\w*)[&\z]?/).flatten.each do |m|
        url.gsub!(m, '')
      end
    end
    url.chomp!('?')
    params.each do |param,value|
      if url.include?('?')
        url += '&'
      else
        url += '?'
      end
      url += "#{param}=#{value}"
    end
    url.gsub!('&&', '&')
    url
  end
end