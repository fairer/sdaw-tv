 ###############################################################################
##                                                                           ##
##                          Cadre qui ne sert a rien                         ##
##                                                                           ##
###############################################################################
#
#charactere spéciaux recherche -- Done
#recherche all -- Done
#recherche episode -- Done
#recherche episode all
#
#
#
class SearchController < ApplicationController

  def initialize
    @series = false
    #Keyboard Distance
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
    @d = Array.new(10, 0.0)
    for i in (0..9)
      @d[i] = 1.0 - Math.tan(0.5 / i)
    end
  end

  #create a matrice
  def mda(width, height, type)
    a = Array.new(width, type)
    a.map! { Array.new(height, type) }
    return a
  end

  def is_char?(i)
    return ((i > 0) && (i <= 26))
  end


  def distance
    @str.downcase!
    @search.downcase!
    length1 = @str.length
    length2 = @search.length
    tab = mda(length1+1, length2+1, 0.0)
    for k in (1..length1)
      tab[k][0] = k
    end
    for l in (1..length2)
      tab[0][l] = l
    end
    for i in (1..length1)
      for j in (1..length2)
        if (is_char?(@str[i-1]-97) && is_char?(@search[j-1]-97))
          if (@str[i-1] == @search[j-1])
            costs = 0.0
          else
            costs = @d[@keyboard_distance[@str[i-1]-97][@search[j-1]-97]]
          end
          tab[i][j] =
            [tab[i-1][j  ] + 1,
             tab[i  ][j-1] + 1,
             tab[i-1][j-1] + costs].min
        else
          if (is_char?(@str[i-1]-97))
            tab[i][j] = tab[i][j-1]
          else
            tab[i][j] = tab[i-1][j]
          end
        end
      end
    end
    @distance = tab[length1][length2]
    return (@distance <= 2.0)
  end

  def index
    initialize
    search()
    respond_to do |format|
      format.html
      format.xml {render :xml=> @videos}
    end
  end

  def search_l (params_array)
    @arr = Video.get_all_names
    @arr.each do |@table|
      result = 0.0
      nb_word = 0
      @table.split.each do |@str|
        params_array.each do |@search|
          if distance
            result  = result + @distance
            nb_word = nb_word + 1
          end
        end
      end
      if (nb_word != 0)
        video = Video.find_last_by_name @table
        @answer[@answer.length] = [video.id.to_int,
                                   @table.to_s,
                                   video.name.to_s,
                                   result / nb_word]
      end
    end
  end

  def search
    @answer = []
    @params = params[:q]
    if (@params != "")
      @research_params = (params[:q]).split
      l = @research_params.length.- 1
      research(@research_params, l)
    else
      @answer = []
    end
  end

  def search_episode(params_array, id)
    @answer = []
    @arr = Episode.find(:all, :conditions => {:serie => id})
    @test = @arr != []
    if @test
      @arr.each do |line|
        @table = line.tags.to_s
        result = 0.0
        nb_word = 0
        @table.split.each do |@str|
          params_array.each do |@search|
            if distance
              result = result + @distance
              nb_word = nb_word + 1
            end
          end
        end
        if (nb_word != 0)
          @answer[@answer.length] = [id,
                                     @table.to_s,
                                     line.name,
                                     result / nb_word]
        end
      end
    end
  end

  def get_all() #à tester
    @arr = Video.get_all_names
    @arr.each do |@table|
      video = Video.find_last_by_name @table
      @answer[@answer.length] = [video.id.to_int,
                                 @table.to_s,
                                 video.name.to_s,
                                 0.0]
    end
  end

##############################################################
  def get_all_episode_from (id) #à tester
    @arr = Video.find_all_by_serie(id)
    @arr.each do |@table|
      video = Video.find_last_by_name @table
      @answer[@answer.length] = [video.id.to_int,
                                 @table.to_s,
                                 video.name.to_s,
                                 0.0]
    end
  end
#############################################################
  def research (params_array, length)
    other = true
    for i in (0..length)
      if ((params_array[i] == "in") && (i < length))
        other = false
        search_l(params_array[i+1..length])
        if (@answer.length != 0)
          search_episode(params_array[0..i-1], @answer[0][0])######
          @series = true;
        end
        break
      else
        if (params_array[i] == "or")
          if (i < length)
            search_l(params_array[0..i-1])
            research(params_array[i+1..length], length - i)
            other = false
          end
          break
        else
          if (params_array[i] == "all")
            if (i == length)
              other = false
              get_all() #à tester
            else
              if ((i < length -1) && (params_array[i+1] = "in"))
                research(params_array[i+2..length], lengtj - i -1)
                get_all_episode_from(@answer[0][0])############
              end
            end
          end
        end
      end
    end
    #Research
    if (other)
      search_l (params_array)
    end
  end
end
