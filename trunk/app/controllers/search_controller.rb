
class SearchController < ApplicationController

  def initialize
    @epi = []
    @answer = []
    @all = false
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
    search()
    @p = (params[:p]).to_i
    @test = Planning.find(:all)
    respond_to do |format|
      format.html
      format.xml {render :xml=> @videos}
    end
  end

  def search_l (params_array)
    @arr = Video.find(:all)
    @arr.each do |table|
      name = table.tags
      result = 0.0
      nb_word = 0
      name.split.each do |@str|
        params_array.each do |@search|
          if distance
            result  = result + @distance
            nb_word = nb_word + 1
          end
        end
      end
      if (nb_word != 0)
        @answer[@answer.length] = [table.id.to_int,
                                   table.name,
                                   table.is_film,
                                   table.desc,
                                   table.nb_seasons.to_int,
                                   table.average_episode_duration.to_int,
                                   table.genre,
                                   table.tags,
                                   result / nb_word]
      end
    end
  end

  def search
    initialize()
    @params = params[:q]
    if (@params != "")
      @research_params = @params.split
      research(@research_params)
    end
    @answer.sort_by {|res| res[res.length.- 1]}
    @epi.sort_by {|res| res[res.length.- 1]}
  end

  def search_episode(params_array, id)
    @series = true
    @arr = Episode.find(:all, :conditions => {:serie => id})
    if @arr != []
      @arr.each do |line|
        if line.serie == id
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
            @epi[@epi.length] = [id,
                                 line.name,
                                 line.description,
                                 line.season,
                                 line.episode_number,
                                 line.tags,
                                 line.serie,
                                 get_serie(id),
                                 get_length(id),
                                 result / nb_word]
          end
        end
      end
    end
  end

  def get_all()
    @arr = Video.find(:all)
    @arr.each do |table|
      @answer[@answer.length] = [table.id.to_int,
                                 table.name,
                                 table.is_film,
                                 table.desc,
                                 table.nb_seasons.to_int,
                                 table.average_episode_duration.to_int,
                                 table.genre,
                                 table.tags,
                                 table.id]
    end
  end

  def get_all_episode_from (id)
    @series = true
    @arr = Episode.find(:all)
    if @arr != []
      @arr.each do |line|
        if line.serie == id
          @epi[@epi.length] = [id,
                               line.name,
                               line.description,
                               line.season,
                               line.episode_number,
                               line.tags,
                               line.serie,
                               get_serie(id),
                               get_length(id),
                               line.season*100 + line.episode_number]
        end
      end
    end
  end

  def get_length(id)
    arr = Video.find(:all)
    arr.each do |line|
      if (line.id == id)
        return line.average_episode_duration
      end
    end
  end

  def get_serie(id)
    arr = Video.find(:all)
    arr.each do |line|
      if (line.id == id)
        return line.name
      end
    end
  end

  def search_episode_where(params_array)
    @series = true
    @arr = Episode.find(:all)
    if @arr != []
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
          @epi[@epi.length] = [line.id,
                               line.name,
                               line.description,
                               line.season,
                               line.episode_number,
                               line.tags,
                               line.serie,
                               get_serie(line.id),
                               get_length(line.id),
                               result / nb_word]
        end
      end
    end
  end

  def research (params_array)
    length = params_array.length - 1
    other = true
    for i in (0..length)
      if ((params_array[i] == "in") && (i < length) && (i != 0))
        if ((i == length - 1) && (params_array[length]) == "all")
          other = false
          @answer = []
          search_episode_where(params_array[0..i-1])
        else
          search_l(params_array[i+1..length])
          if (@answer.length != 0)
            other = false
            @answer = @answer.sort_by {|res| res[res.length.- 1]}
            search_episode(params_array[0..i-1], @answer[0][0])
            @similar_research = params_array[0..i-1].join(" ") +" in "
          end
        end
        break
      else
        if (params_array[i] == "or")
          if (i < length)
            search_l(params_array[0..i-1])
            research(params_array[i+1..length])
            other = false
          end
          break
        else
          if (params_array[i] == "all")
            if (i == length)
              other = false
              @answer = []
              get_all()
              @test = @answer.length
              @all = true
            else
              if ((i < length -1) && (params_array[i+1] = "in"))
                research(params_array[i+2..length])
                other = false
                if (@answer.length != 0)
                  @answer = @answer.sort_by {|res| res[res.length.- 1]}
                  get_all_episode_from(@answer[0][0])
                  @all = true
                  @similar_research = "all in "
                end
                break
              end # else reseach
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
