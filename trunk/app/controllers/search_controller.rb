
class SearchController < ApplicationController
  def initialize
    @keyboard_distance =
      [[0,5,3,2,3,3,4,5,8,6,7,8,7,6,9,9,1,4,1,5,7,4,2,2,6,1],
       [5,0,2,3,4,2,1,1,4,2,3,5,2,1,6,7,6,4,3,2,5,1,5,3,3,4],
       [3,2,0,1,2,1,2,3,6,4,5,6,4,3,6,7,4,3,2,4,6,1,3,1,5,2],
       [2,3,1,1,1,1,2,3,6,4,5,6,5,4,6,7,3,1,1,3,5,2,2,1,4,2],
       [3,4,2,1,0,2,3,4,5,6,7,8,6,5,6,7,2,1,1,2,4,3,1,2,3,2],
       [3,2,1,1,2,0,1,2,5,3,4,5,4,3,5,6,4,1,2,1,3,1,3,2,2,3],
       [4,1,2,2,3,1,0,1,4,2,3,4,3,2,4,5,5,2,3,1,2,1,4,3,2,4],
       [5,1,3,3,4,2,1,0,3,1,2,3,2,1,3,4,6,3,4,2,2,2,5,4,1,5],
       [8,4,6,6,5,5,4,3,0,1,1,2,2,3,1,2,7,4,6,3,1,4,6,6,2,7],
       [6,2,4,4,6,3,2,1,1,0,1,2,1,1,2,3,6,4,5,3,1,3,6,5,2,6],
       [7,3,5,5,7,4,3,2,1,1,0,1,1,2,1,3,8,5,6,4,2,4,7,6,3,7],
       [8,5,6,6,8,5,4,3,2,2,1,0,2,3,1,2,8,6,7,5,3,5,8,7,4,8],
       [7,2,4,5,6,4,3,2,2,1,1,2,0,1,2,4,8,5,6,4,2,3,7,7,3,6],
       [6,1,3,4,5,3,2,1,3,1,2,3,1,0,3,4,7,4,4,3,2,2,6,4,2,5],
       [9,6,6,6,6,5,4,3,1,2,1,1,2,3,0,1,8,5,7,4,2,5,7,6,3,8],
       [9,7,7,7,7,6,5,4,2,3,3,2,4,4,1,0,9,6,8,5,3,6,8,8,4,9],
       [1,6,4,3,2,4,5,6,7,6,8,8,8,7,8,9,0,3,2,4,6,6,1,3,5,2],
       [4,3,3,1,1,1,2,3,4,4,5,6,5,4,5,6,3,0,2,1,2,2,2,2,2,3],
       [1,4,2,1,1,2,3,4,6,5,6,7,6,4,7,8,2,2,0,3,5,3,1,1,4,1],
       [5,2,4,3,2,1,1,2,3,3,4,5,4,3,4,5,4,1,3,0,2,2,3,3,1,4],
       [7,4,6,5,4,3,2,2,1,1,2,3,2,2,2,3,6,2,5,2,0,3,5,5,1,6],
       [4,1,1,2,3,1,1,2,4,3,4,5,3,2,5,6,6,2,3,2,3,0,4,2,2,3],
       [2,5,3,2,1,3,4,5,6,6,7,8,7,6,7,8,1,2,1,3,5,4,0,2,4,2],
       [2,3,1,1,2,2,3,4,6,5,6,7,7,4,6,8,3,2,1,3,5,2,2,0,4,1],
       [6,3,5,4,3,2,2,1,2,2,3,4,3,2,3,4,5,2,4,1,1,2,4,4,0,5],
       [1,4,2,2,2,3,4,5,7,6,7,8,6,5,8,9,2,3,1,4,6,3,2,1,5,0]]
  end
  
  def mda(width,height, type)
    a = Array.new(width, type)
    a.map! { Array.new(height, type) }
    return a
  end
  
  def distance
    length1 = @str.length
    length2 = @search.length
    tab = mda(length1+1, length2+1, 0.0)
    for k in (1..length1)
      tab[k][0] = 1.0 * k
    end
    for l in (1..length2)
      tab[0][l] = 1.0 * l
    end
    for i in (1..length1)
      for j in (1..length2)
        if (@str[i-1] == @search[j-1])
          costs = 0.0
        else
          costs =  1.0-
            Math.tan(0.5/(@keyboard_distance[@str[i-1]-97][@search[j-1]-97]))
        end
        tab[i][j] =
          [tab[i-1][j  ] + 1.0,
           tab[i  ][j-1] + 1.0,
           tab[i-1][j-1] + costs].min
      end
    end
    @distance = tab[length1][length2]
    return (@distance <= 2.0)
  end
  
  def index
    search
    #@seriestables = Seriestable.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
  end
  
  def search_l (params_array)
#    @arr = ["doctor house","planete tresor","evades",
#            "tueurs nes", "malcolm", "family guys griffins",
#            "star wars", "scrubs", "numero neuf"]
    @arr = Video.get_all_names

    @result = 0.0
    @nb_word = 0
    @arr.each do |@table|
      @table.split.each do |@str|
        params_array.each do |@search|
          if distance
            @result = @result + @distance
            @nb_word = @nb_word + 1
          end
        end
      end
      if (@nb_word != 0)
        video = Video.find_last_by_safe_name @table
        @answer[@answer.length] = [video.id.to_int, @table.to_s, video.name.to_s]
      end
      @result = 0.0
      @nb_word = 0
    end
  end

  def search
    initialize
    @answer = []
    @params = params[:q]
    @research_params = (params[:q]).split
    research(@research_params, @research_params.length)

  end

  def research (params_array, length)
    @series = true
    for i in (0..length)
      if (params_array[i] == "in")
        @series = false
        #Search in the list
        #get the identifiant of the series
        #search episode with the identifiant of the series
        #make a research function for find a single identifiant
        break
      else
        if (params_array[i] == "or")
          if (i < length)
            search_l (params_array[0..i-1])
            research (params_array[i+1..length], length - i - 1)
            @series = false
          else
            break
          end
          #Search @researh (0,i-1) @ @research(i+1, @q.length - 1)
          break
        else
          if (params_array[i] == "and")#delete this
            #delete
          else
            #
          end
        end
      end
    end
    if (@series)
      search_l (params_array)
    end
  end
end
